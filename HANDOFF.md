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
3. **Mode quick/full:** quick = Telegram response ngắn, full = export file .md đầy đủ
4. **Industry-adaptive:** detect ngành từ context, chỉ hỏi nếu chưa có
5. **Resource-adaptive:** template thay đổi theo quy mô team (1 người / 2–3 người / 4+)
6. **Results-based timeline:** tiến theo kết quả đạt được, không theo lịch cố định
7. **RACI với tên thật:** hỏi vai trò thực tế, mỗi deliverable đúng 1 A
8. **Section markers trong output:** bắt buộc để Critic có thể flag chính xác

---

## Trạng thái từng skill

| Skill | Trạng thái | Ghi chú |
|-------|-----------|---------|
| 00-ke-hoach-mkt | ✅ Done | session_context, mode, 8 ngành, results-based timeline |
| 01-lich-noi-dung | ✅ Done | session_context, mode, resource-adaptive template |
| 02-brief-chien-dich | ✅ Done | session_context, mode, 5 phase models, RACI adaptive |
| 03-danh-gia-hieu-suat | ✅ Done | session_context, mode quick/full, dynamic action plan, benchmark +2 ngành |
| 30-retention-strategy | ✅ Done | Skill mới — retention framework 3 giai đoạn, 4 nhóm khách |
| 31-winback-campaign | ✅ Done | Skill mới — sequence 3 bước, test-first 10% |
| **04–29** | ⏳ Chưa làm | Tiếp tục review theo thứ tự |

**Skill tiếp theo cần review: 04-script-video**
Protocol: đọc file → tóm tắt skill làm gì + output → user confirm → review CMO đầy đủ → sửa khi confirm

---

## Supabase Schema — chưa build, đã thiết kế hướng đi

Nên build schema đúng ngay từ đầu để không migrate 2 lần:

```sql
-- Skills stored in DB (không đọc từ file mỗi lần)
table: skills
  id, name, description, version, context_requirements (jsonb),
  description_embedding (vector)   -- cho semantic routing

table: skill_sections
  skill_id, section_type, content, embedding (vector), priority

-- Customer memory (flat JSONB hiện tại — đủ dùng giai đoạn đầu)
table: customer_memory
  customer_id, memory (jsonb), updated_at

-- Audit log
table: ai_audit_log
  customer_id, skill_id, agent_id, input_summary, output_summary,
  skill_version, review_rounds, created_at

-- Workflow state (cho crash-resume)
table: workflow_state
  session_id, workflow_type, completed_skills (jsonb),
  current_skill, created_at
```

Wiki-style memory (phase sau, sau khi có 50+ khách active):
- Chia customer_memory thành pages với embedding riêng
- Chỉ retrieve pages liên quan đến skill đang chạy

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

> "Tiếp tục project CMO AI — đọc HANDOFF.md tại root. Tiếp tục review skill 04-script-video theo protocol: đọc file → tóm tắt → user confirm → review CMO → sửa."
