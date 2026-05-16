# HANDOFF — CMO AI Product

## Context project
CMO AI product cho SME spa/clinic — Telegram Bot + n8n + Claude API + Supabase.
Skills nằm tại `skills/vi/` — đang review và update từng file để adaptive theo memory/mode/ngành.

## Branch đang làm
`feature/retention-skills`

---

## Kiến trúc đã xác lập

### Flow tổng thể

```
SIMPLE PATH (đa số Telegram interactions):
Telegram → Haiku classify {agent_id, skill_id, mode}
         → n8n load {agent system prompt + skill sections + session_context}
         → Sonnet call 1: Sub-agent execute skill
         → Sonnet call 2: Master Agent critic review
         → APPROVED → trả về user
         → NEEDS_FIX → sub-agent sửa đúng section bị flag → re-review

COMPLEX PATH (multi-skill workflow, ambiguous, cross-agent):
Telegram → Haiku detect "complex"
         → Master Agent (Sonnet): orchestrate skill sequence / disambiguate
         → Sub-agent+Skill calls (tuần tự)
         → Master Agent critic review từng output
         → Aggregate → trả về user
```

### Master Agent — 6 roles

| Role | Khi nào |
|------|---------|
| Context injection | Mọi call — inject session_context vào sub-agent |
| Classifier/router | Ambiguous requests — Haiku không đủ confident |
| Workflow orchestrator | Multi-skill workflows — giữ state xuyên suốt |
| Cross-agent handoff | Sub-agent out-of-scope → route sang agent đúng |
| **Critic/reviewer** | **Mọi output trước khi trả về user** |
| Fallback handler | Sub-agent fail hoặc output kém chất lượng |

**Quan trọng:** Master Agent KHÔNG thể bị bỏ khỏi bất kỳ path nào vì Critic role bắt buộc phải có.

### Sub-agents — giữ nguyên, không bỏ

Sub-agents có 4 giá trị thật ngoài routing:
1. **Domain expertise**: 5 working principles riêng theo domain
2. **Pre-skill diagnostics**: performance-analyst có cây chẩn đoán tầng agent trước khi gọi skill
3. **Hard boundaries**: "không làm X → chuyển sang Y" — scope enforcement
4. **Compliance rules**: personal-brand-builder có legal/ethical guardrails (Nghị định 147/2024)

### Session context — Master Agent đọc 1 lần

```
n8n fetch customer_memory từ Supabase (1 lần/session)
→ Master Agent build session_context
→ inject vào mỗi skill call qua prefix format (xem sub-agents/master-agent-contract.md)
```

Skills KHÔNG tự đọc database. Skills nhận session_context từ Master Agent.

---

## Critic Pattern (mới — session hôm nay)

File: `sub-agents/master-agent-critic.md`

**Cơ chế:**
- Sub-agent wrap output bằng `<!-- SECTION: name -->` markers
- Master Agent Critic review theo checklist 3 tầng: CRITICAL / HIGH / MEDIUM
- Nếu NEEDS_FIX → trả về {SECTION, SEVERITY, PROBLEM, FIX_INSTRUCTION}
- Sub-agent chỉ sửa đúng section bị flag, không đụng phần còn lại
- Tối đa 2 vòng → sau đó approve với warning

**CRITICAL checks:** benchmark sai ngành, phép tính lệch, placeholder chưa điền, sai mode
**HIGH checks:** không hợp team size, sai channel theo ngành, budget mâu thuẫn
**Nguyên tắc:** Critic KHÔNG rewrite — chỉ flag và hướng dẫn sửa

---

## Skills — Nguyên tắc cốt lõi khi sửa

1. **session_context thay memory-first:** Skills nhận context từ Master Agent, không tự đọc DB
2. **context_requirements trong YAML:** Khai báo fields cần từ session_context
3. **Output format — ĐÃ ĐỔI:** ~~quick/full~~ → **Telegram** = bullet point tóm tắt ý chính | **Full** = file hoàn chỉnh xuất qua Google Sheet (link GG Sheet của owner)
4. **Industry-adaptive:** detect ngành từ context, chỉ hỏi nếu chưa có
5. **Resource-adaptive:** số bài/tuần = số người × 3–4; số kênh = min(số người + 1, 5) — không dùng tier cố định
6. **Results-based timeline:** tiến theo kết quả đạt được, không theo lịch cố định
7. **RACI với tên thật:** hỏi vai trò thực tế, mỗi deliverable đúng 1 A
8. **Section markers trong output:** bắt buộc để Critic có thể flag chính xác
9. **MCP skill 08:** Owner chủ động chạy MCP (Facebook Ads Library) — khách chỉ cần cung cấp link fanpage đối thủ, không cần khách tự setup
10. **First conversation flow:** Handle bởi Master Agent — không cần sửa trong skill
11. **Skill 02:** Thêm section "Tạo offer chiến dịch" — giá, gói, mechanic ưu đãi
12. **Negative examples:** Mỗi skill cần thêm ví dụ output xấu vs output tốt cho section quan trọng để Claude có anchor cụ thể

---

## Trạng thái từng skill

| Skill | Trạng thái | Ghi chú |
|-------|-----------|---------|
| 00-ke-hoach-mkt | ✅ Done | session_context, mode, 8 ngành, results-based timeline |
| 01-lich-noi-dung | ✅ Done | Adaptive team size (số người × 3–4 bài/tuần, không tier cố định) |
| 02-brief-chien-dich | ⚠️ Done nhưng còn thiếu | Cần thêm section "Tạo offer chiến dịch" (giá, gói, mechanic ưu đãi) |
| 03-danh-gia-hieu-suat | ✅ Done | session_context, mode quick/full, dynamic action plan |
| 04-script-video | ✅ Done | v3.0.0 — session_context mode, coaching question (viết sẵn vs tự viết), hooks theo ngành, TOFU/MOFU/BOFU variants, negative examples, hashtag theo nền tảng |
| 05-copy-quang-cao | ✅ Done | v3.0.0 — session_context mode, Zalo OA copy, negative examples PAS+AIDA, Personal Brand T1/T2/S1/S2 hoàn chỉnh, Telegram vs Full output |
| 06-brief-ugc-egc | ⏳ Assessment xong, chưa viết | Cần thêm: YAML, adaptive intake, disclosure requirement, negative example brief, Telegram vs Full |
| 08-nghien-cuu-doi-thu | ✅ Done | v3.0.0 — MCP flow, 3-tier competitor, 5 core aspects, industry supplements |
| 09-insight-khach-hang | ✅ Done | v3.0.0 — adaptive intake, Customer Journey Spa demo, Internal Monologue demo, behavioral segmentation theory (action → skill 30) |
| 30-retention-strategy | ✅ Done | v2.0.0 — 4-nhóm action table (merge từ skill 09), adaptive intake |
| 31-winback-campaign | ✅ Done | v2.0.0 — YAML updated, adaptive intake |
| **07, 10–29** | ⏳ Chưa làm | Phase tiếp theo |

**Skill tiếp theo cần làm:**
1. **06-brief-ugc-egc** — viết file (assessment đã xong, xem ghi chú trên)
2. **02-brief-chien-dich** — thêm section "Tạo offer chiến dịch"
3. Sau đó: #SECTION markers + ingest Supabase cho toàn bộ skills vừa sửa

Protocol: đọc file → CMO review đầy đủ → user confirm → sửa

---

## Arkon-style Skill Storage — ĐÃ BUILD & TEST ✅

### Tổng quan

Thay vì đọc toàn bộ file SKILL.md mỗi lần gọi, skills được chia thành sections có metadata, lưu vào Supabase, và chỉ load sections liên quan theo mode + industry.

**Token savings đã đo:** Quick mode load 8/12 sections = tiết kiệm **44.2%** tokens so với full file.

### Cấu trúc #SECTION markers trong SKILL.md

```markdown
<!-- #SECTION
id: context_intake
type: context_intake
priority: 1
modes: [all]
industries: [all]
tags: [onboarding, session_context]
-->

... nội dung section ...

<!-- #/SECTION -->
```

**Priority logic:**
- `priority: 1` — luôn load (context_intake, data_collection, quality_checklist)
- `priority: 2` — load cho cả quick và full
- `priority: 3` — chỉ load khi `mode=full` hoặc industry match

### Files đã tạo

| File | Mục đích |
|------|---------|
| `db/schema.sql` | Tạo bảng `skills` + `skill_sections` trong Supabase |
| `scripts/ingest_skill.py` | Parse SKILL.md → upsert vào Supabase |
| `scripts/test_retrieval.sql` | SQL tests: view sections, quick/full filter, token comparison |
| `scripts/test_full_flow.py` | End-to-end test: Supabase → Claude Haiku → print output |
| `scripts/telegram_bot.py` | Telegram bot multi-turn với session history |
| `scripts/requirements.txt` | Python dependencies |

### Chạy ingestion

```bash
# Ingest 1 skill
python -X utf8 scripts/ingest_skill.py skills/vi/00-ke-hoach-mkt/SKILL.md

# Ingest tất cả
python -X utf8 scripts/ingest_skill.py --all

# Lưu ý: phải dùng -X utf8 trên Windows (Python 3.14)
```

### Skills đã ingested vào Supabase

| Skill | Sections | Quick sections | Full sections |
|-------|---------|---------------|--------------|
| 00-ke-hoach-mkt | 12 | 8 | 12 |
| 01-lich-noi-dung | 11 | 8 | 11 |
| 02-brief-chien-dich | 14 | 9 | 14 |
| 03-danh-gia-hieu-suat | 14 | 10 | 14 |

### Telegram Bot (Python local — để test)

```bash
python -X utf8 scripts/telegram_bot.py
```

Bot đã test thực tế trên Telegram:
- Multi-turn conversation history per chat_id
- Fetch sections từ Supabase real-time
- Gọi Claude Haiku-4-5 với session_context + skill sections
- `/start` reset session, `/reset` để bắt đầu lại

**Lưu ý:** Python bot = prototype test. Production sẽ dùng n8n.

**Vấn đề chưa fix:** Output "lỏ" — không bám sát template → nguyên nhân là Haiku (model yếu hơn). Fix: chuyển sang `claude-sonnet-4-5` (deferred).

### Supabase Schema (đã triển khai)

```sql
-- Xem db/schema.sql để full schema
table: skills
  skill_id (PK), name, description, agent, version, category,
  context_requirements (jsonb)

table: skill_sections
  skill_id (FK), section_id, section_type, content,
  priority, modes TEXT[], industries TEXT[], tags TEXT[]
  -- GIN indexes on modes, industries arrays
```

---

## Arkon analysis — Kết luận

File ZIP: `C:\Users\dtnhien\Downloads\arkon-main.zip`

**Arkon là gì:** Enterprise AI Knowledge Hub — biến tài liệu PDF/URL thành structured wiki, serve qua MCP.

**Tác động vào product:** Chủ yếu ở data layer (lưu/tìm kiếm memory tốt hơn). Không tác động đến skill quality hay marketing expertise.

**Ideas áp dụng được (implement từ scratch, không copy code — license PolyForm):**
1. Semantic skill routing via pgvector — thay keyword triggers
2. Wiki-style memory + incremental merge — làm cùng nhau (phase sau)
3. Section-by-section editing — prompt pattern (đã thiết kế trong Critic)
4. Crash-resume cho workflow dài
5. Image/screenshot processing cho skill 03

**Không áp dụng:** Full MRP pipeline, RBAC, MCP server, arq workers, MinIO.

---

## Files quan trọng

| File | Mục đích |
|------|---------|
| `CLAUDE.md` | Identity + workflow toàn hệ thống |
| `sub-agents/memory-schema.md` | Schema JSONB cho customer memory |
| `sub-agents/master-agent-contract.md` | session_context schema + inject format |
| `sub-agents/master-agent-critic.md` | Critic/reviewer pattern — section markers, checklist, fix loop |
| `skills/vi/` | 32 skills tiếng Việt |

---

## Cách tiếp tục ở session mới

Paste vào đầu session:

> "Tiếp tục project CMO AI — đọc HANDOFF.md tại root. Việc tiếp theo: viết file skill 06-brief-ugc-egc (assessment đã xong, xem trạng thái skill trong HANDOFF), sau đó thêm section Tạo offer chiến dịch vào skill 02."

---

## Pending tasks

| Task | Trạng thái | Ghi chú |
|------|-----------|---------|
| Skills 00-03: add #SECTION markers | ✅ Done | 4 skills đã ingested vào Supabase |
| Telegram bot local test | ✅ Done | Multi-turn, real Supabase, real Claude |
| Skill 06: viết file | ⏳ Việc tiếp theo | Assessment xong — xem ghi chú trong bảng trạng thái skill |
| Skill 02: thêm "Tạo offer chiến dịch" | ⏳ Việc tiếp theo | Sau skill 06 |
| Skills 04–05, 08–09, 30–31: add #SECTION markers + ingest | ⏳ Chưa làm | Sau khi content review xong toàn bộ |
| Skills 07, 10–29: content review | ⏳ Phase tiếp theo | Sau khi xong pre-launch set |
| Supabase re-ingest skills 01, 02, 03 | ⏳ Cần làm | Đã modify sau lần ingest cuối — data stale |
| Verify references tồn tại | ⏳ Todo | copy-frameworks-vn.md, quality-gates-vn.md trong skill 05 |
| n8n setup production | ⏳ Deferred | Sau khi đủ skills ingested |
| Fix output template (Haiku → Sonnet) | ⏳ Deferred | Đổi model trong telegram_bot.py |
| .env.example: thêm ANTHROPIC_API_KEY + TELEGRAM_BOT_TOKEN | ⏳ Todo | File hiện chỉ có SUPABASE_* keys |
