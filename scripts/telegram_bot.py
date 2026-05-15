"""
CMO AI — Telegram Bot (Real test version)
Multi-turn conversation + real session_context built from user answers

Flow:
  User message
    → Duy trì conversation history per chat_id
    → Fetch skill sections từ Supabase
    → Build prompt (session_context + sections + history)
    → Claude generate reply
    → Telegram reply
"""

import os
import asyncio
import logging
from dotenv import load_dotenv
from supabase import create_client, Client
import anthropic
from telegram import Update
from telegram.ext import (
    ApplicationBuilder, MessageHandler,
    CommandHandler, filters, ContextTypes
)

load_dotenv()

logging.basicConfig(
    format="%(asctime)s - %(levelname)s - %(message)s",
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# ── Clients ───────────────────────────────────────────────────────────────────
supabase: Client = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_SERVICE_KEY")
)
claude = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))
TELEGRAM_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")

# ── In-memory state (reset khi restart bot) ───────────────────────────────────
# {chat_id: {"history": [...], "session_context": {...}, "skill_id": "..."}}
chat_sessions: dict = {}


# ── Fetch sections từ Supabase ────────────────────────────────────────────────
def fetch_sections(skill_id: str, mode: str = "quick", industry: str = "general") -> list[dict]:
    res = supabase.table("skill_sections") \
        .select("section_id, section_type, priority, modes, industries, content") \
        .eq("skill_id", skill_id) \
        .order("priority") \
        .execute()

    filtered = []
    for sec in res.data:
        p = sec["priority"]
        modes = sec["modes"]
        industries = sec["industries"]

        if p <= 2:
            filtered.append(sec)
        elif ("all" in modes or mode in modes) and \
             ("all" in industries or industry in industries):
            filtered.append(sec)

    return filtered


# ── Detect skill từ message (đơn giản cho test) ───────────────────────────────
def detect_skill(message: str) -> str:
    msg = message.lower()
    if any(k in msg for k in ["kế hoạch", "ke hoach", "marketing plan", "chiến lược", "chien luoc", "gtm", "launch"]):
        return "00-ke-hoach-mkt"
    # Mặc định skill 00 (chỉ có 1 skill trong DB lúc này)
    return "00-ke-hoach-mkt"


# ── Build system prompt ───────────────────────────────────────────────────────
def build_system_prompt(session_context: dict, sections: list[dict]) -> str:
    # Fields nào đang null
    null_fields = [k for k, v in session_context.items() if v is None]

    ctx = session_context
    prefix = f"""[SESSION CONTEXT]
industry: {ctx.get('industry', 'null — chưa biết, cần hỏi')}
business_name: {ctx.get('business_name', 'null')}
business_stage: {ctx.get('business_stage', 'null')}
team_size: {ctx.get('team_size', 'null')}
active_channels: {ctx.get('active_channels', 'null')}
budget: {ctx.get('budget_monthly', 'null')}
kpi_targets: {ctx.get('kpi_targets', 'null')}
mode: {ctx.get('mode', 'quick')}
---
Các field null (cần hỏi user): {null_fields if null_fields else 'không có — đủ thông tin'}

[SKILL INSTRUCTION]
"""
    skill_content = "\n\n---\n\n".join(
        f"<!-- SECTION: {s['section_id']} -->\n{s['content']}\n<!-- /SECTION: {s['section_id']} -->"
        for s in sections
    )
    return prefix + skill_content


# ── Handlers ──────────────────────────────────────────────────────────────────
async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.message.chat_id

    # Reset session
    chat_sessions[chat_id] = {
        "history": [],
        "session_context": {
            "industry": None,
            "business_name": None,
            "business_stage": None,
            "team_size": None,
            "active_channels": None,
            "budget_monthly": None,
            "kpi_targets": None,
            "mode": "quick",
        },
        "skill_id": None,
    }

    await update.message.reply_text(
        "👋 Xin chào\\! Tôi là **CMO AI** — trợ lý marketing cho spa/clinic và SME\\.\n\n"
        "Bạn muốn làm gì hôm nay?\n\n"
        "💡 Thử nhắn:\n"
        "• *Lập kế hoạch marketing cho spa của tôi*\n"
        "• *Tôi cần chiến lược marketing mới*\n"
        "• *Giúp tôi audit hiệu suất quảng cáo*",
        parse_mode="MarkdownV2"
    )


async def reset(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.message.chat_id
    chat_sessions.pop(chat_id, None)
    await update.message.reply_text("🔄 Session đã reset. Nhắn lại để bắt đầu mới.")


async def handle_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    chat_id = update.message.chat_id
    user_message = update.message.text

    # Init session nếu chưa có
    if chat_id not in chat_sessions:
        chat_sessions[chat_id] = {
            "history": [],
            "session_context": {
                "industry": None,
                "business_name": None,
                "business_stage": None,
                "team_size": None,
                "active_channels": None,
                "budget_monthly": None,
                "kpi_targets": None,
                "mode": "quick",
            },
            "skill_id": None,
        }

    session = chat_sessions[chat_id]

    # Detect skill nếu chưa có
    if not session["skill_id"]:
        session["skill_id"] = detect_skill(user_message)
        logger.info(f"[{chat_id}] Skill detected: {session['skill_id']}")

    # Thêm message vào history
    session["history"].append({"role": "user", "content": user_message})

    # Typing indicator
    await context.bot.send_chat_action(chat_id=chat_id, action="typing")

    try:
        skill_id = session["skill_id"]
        ctx = session["session_context"]

        # Fetch sections
        industry = ctx.get("industry") or "general"
        mode = ctx.get("mode") or "quick"
        sections = fetch_sections(skill_id, mode, industry)

        logger.info(f"[{chat_id}] Fetched {len(sections)} sections from Supabase")

        # Build system prompt
        system_prompt = build_system_prompt(ctx, sections)

        # Gọi Claude với full conversation history
        response = claude.messages.create(
            model="claude-haiku-4-5",
            max_tokens=2048,
            system=system_prompt,
            messages=session["history"]
        )

        reply = response.content[0].text

        # Lưu reply vào history
        session["history"].append({"role": "assistant", "content": reply})

        logger.info(f"[{chat_id}] Reply: {len(reply)} chars | History: {len(session['history'])} turns")

        # Gửi reply — chia nhỏ nếu quá 4096 chars
        if len(reply) > 4000:
            chunks = [reply[i:i+4000] for i in range(0, len(reply), 4000)]
            for chunk in chunks:
                await update.message.reply_text(chunk)
        else:
            await update.message.reply_text(reply)

    except Exception as e:
        logger.error(f"[{chat_id}] Error: {e}", exc_info=True)
        await update.message.reply_text(
            f"⚠️ Có lỗi xảy ra: {str(e)[:100]}\n\nThử lại hoặc /reset để bắt đầu lại."
        )


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    if not TELEGRAM_TOKEN:
        print("❌ Thiếu TELEGRAM_BOT_TOKEN trong .env")
        return

    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    print("🤖 CMO AI Bot đang chạy...")
    print("   /start — bắt đầu session mới")
    print("   /reset — reset conversation")
    print("   Ctrl+C để dừng\n")

    app = ApplicationBuilder().token(TELEGRAM_TOKEN).build()
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("reset", reset))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))

    try:
        app.run_polling(drop_pending_updates=True)
    except KeyboardInterrupt:
        print("\n👋 Bot đã dừng.")


if __name__ == "__main__":
    main()
