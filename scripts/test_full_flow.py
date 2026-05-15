"""
CMO AI — Full Flow Test
Mô phỏng toàn bộ flow:
  1. Fetch sections từ Supabase (thay vì đọc file .md)
  2. Build prompt (session_context + skill sections)
  3. Gọi Claude API
  4. In output

Cách chạy:
  python scripts/test_full_flow.py
"""

import os
from dotenv import load_dotenv
from supabase import create_client, Client
import anthropic

load_dotenv()

# ── Clients ────────────────────────────────────────────────────────────────────
supabase: Client = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_SERVICE_KEY")
)
claude = anthropic.Anthropic(api_key=os.getenv("ANTHROPIC_API_KEY"))


# ── Simulated session_context (thay thế cho Haiku classify + memory fetch) ───
SESSION_CONTEXT = {
    "industry": "spa",
    "business_name": "Spa Luna",
    "business_stage": "launch",
    "team_size": 2,
    "budget_monthly": 15_000_000,
    "active_channels": ["tiktok_organic", "meta_ads", "zalo_oa"],
    "kpi_targets": {"cpmess": 25000, "roas": 3, "monthly_revenue": 80_000_000},
    "mode": "quick",
}

SKILL_ID = "00-ke-hoach-mkt"
USER_MESSAGE = "Lập kế hoạch marketing cho spa của tôi"


# ── Step 1: Fetch sections từ Supabase ────────────────────────────────────────
def fetch_sections(skill_id: str, mode: str, industry: str) -> list[dict]:
    """
    Query sections theo priority + mode + industry filter.
    Giống logic n8n sẽ làm sau này.
    """
    print(f"\n📦 Fetching sections: skill={skill_id} mode={mode} industry={industry}")

    res = supabase.table("skill_sections") \
        .select("section_id, section_type, priority, modes, industries, content") \
        .eq("skill_id", skill_id) \
        .order("priority") \
        .execute()

    all_sections = res.data
    filtered = []

    for sec in all_sections:
        p = sec["priority"]
        modes = sec["modes"]
        industries = sec["industries"]

        # Priority 1 & 2: luôn load
        if p <= 2:
            filtered.append(sec)
            continue

        # Priority 3: load nếu mode + industry match
        mode_ok     = "all" in modes     or mode     in modes
        industry_ok = "all" in industries or industry in industries
        if mode_ok and industry_ok:
            filtered.append(sec)

    print(f"  → {len(filtered)}/{len(all_sections)} sections loaded")
    for s in filtered:
        print(f"     [{s['section_id']}] priority={s['priority']} modes={s['modes']}")

    return filtered


# ── Step 2: Build prompt ───────────────────────────────────────────────────────
def build_prompt(session_context: dict, sections: list[dict], user_message: str) -> str:
    """
    Ghép session_context prefix + skill sections thành 1 prompt.
    Đây là format Master Agent sẽ dùng khi gọi sub-agent.
    """
    ctx = session_context

    context_prefix = f"""[SESSION CONTEXT]
industry: {ctx.get('industry')}
business_name: {ctx.get('business_name')}
business_stage: {ctx.get('business_stage')}
team_size: {ctx.get('team_size')} người
active_channels: {', '.join(ctx.get('active_channels', []))}
budget: {ctx.get('budget_monthly'):,}đ/tháng
kpi_targets: CPMess {ctx.get('kpi_targets', {}).get('cpmess', 'N/A')}đ | ROAS {ctx.get('kpi_targets', {}).get('roas', 'N/A')}x | Revenue {ctx.get('kpi_targets', {}).get('monthly_revenue', 0):,}đ/tháng
mode: {ctx.get('mode')}
---
Các field null (chưa có, skill cần hỏi): objectives, source_type_mix

[SKILL INSTRUCTION]
"""

    skill_content = "\n\n---\n\n".join(
        f"<!-- SECTION: {s['section_id']} -->\n{s['content']}\n<!-- /SECTION: {s['section_id']} -->"
        for s in sections
    )

    return context_prefix + skill_content


# ── Step 3: Gọi Claude API ────────────────────────────────────────────────────
def call_claude(system_prompt: str, user_message: str) -> str:
    print(f"\n🤖 Calling Claude... (prompt: {len(system_prompt):,} chars)")

    response = claude.messages.create(
        model="claude-haiku-4-5",          # dùng Haiku cho test (rẻ hơn)
        max_tokens=2048,
        system=system_prompt,
        messages=[
            {"role": "user", "content": user_message}
        ]
    )

    return response.content[0].text


# ── Main ───────────────────────────────────────────────────────────────────────
def main():
    print("=" * 60)
    print("CMO AI — Full Flow Test")
    print("=" * 60)

    mode     = SESSION_CONTEXT["mode"]
    industry = SESSION_CONTEXT["industry"]

    # Step 1: Fetch
    sections = fetch_sections(SKILL_ID, mode, industry)

    # Step 2: Build prompt
    system_prompt = build_prompt(SESSION_CONTEXT, sections, USER_MESSAGE)
    prompt_chars  = len(system_prompt)
    print(f"\n📝 Prompt built: {prompt_chars:,} chars (~{prompt_chars // 4:,} tokens)")

    # Step 3: Call Claude
    output = call_claude(system_prompt, USER_MESSAGE)

    # Result
    print("\n" + "=" * 60)
    print("OUTPUT:")
    print("=" * 60)
    print(output)
    print("=" * 60)
    print(f"\n✅ Full flow complete")
    print(f"   Prompt size : {prompt_chars:,} chars")
    print(f"   Mode        : {mode}")
    print(f"   Industry    : {industry}")
    print(f"   Sections    : {len(sections)}/12 loaded")


if __name__ == "__main__":
    main()
