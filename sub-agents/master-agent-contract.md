# Master Agent Contract — Session Context

## Mục đích

Master Agent đọc `customer_memory` từ Supabase **1 lần duy nhất** khi session bắt đầu,
tóm tắt thành `session_context`, rồi inject vào mỗi skill call.

Skills KHÔNG tự đọc database. Skills chỉ nhận `session_context` từ Master Agent.

---

## Luồng hoạt động

```
Telegram message
  → n8n fetch customer_memory từ Supabase (1 lần)
  → Haiku classify: {agent, skills[], mode}
  → Master Agent nhận customer_memory + message
  → Master Agent build session_context
  → Master Agent gọi skill với session_context prefix
  → Skill chạy logic, KHÔNG hỏi lại data đã có trong context
  → Output trả về user
  → n8n trigger memory extraction sau 30 phút
```

---

## session_context Schema

```json
{
  "industry": "spa | clinic | fnb | fitness | education | ecommerce | saas | realestate | general",
  "business_name": "string",
  "business_stage": "launch | growth | mature",
  "active_channels": ["meta_ads", "tiktok_ads", "tiktok_organic", "facebook_organic", "zalo_oa", "email", "google_ads"],
  "kpi_targets": {
    "cpmess": 25000,
    "roas": 4,
    "monthly_revenue": 100000000,
    "monthly_orders": 50
  },
  "team_size": 1,
  "team_roles": ["chu_spa", "nhan_vien_content"],
  "budget_monthly": 10000000,
  "source_type_mix": {
    "fgc": 25,
    "brand": 30,
    "ugc": 25,
    "egc": 20
  },
  "customer_profile": {
    "age_range": "25-40",
    "gender": "female",
    "location": "HCM",
    "main_pain_points": ["string"],
    "purchase_triggers": ["string"]
  },
  "mode": "quick | full",
  "session_summary": "string — tom tat ngan session hien tai"
}
```

---

## Cách Master Agent build session_context

```
1. Doc customer_memory tu Supabase (da inject boi n8n)
2. Map cac field sang session_context schema
3. Them "mode" tu Haiku classify output
4. Neu field nao trong memory = null → de null, KHONG tu dien
5. Ghi ro nhung field nao null → skill se hoi user de fill
```

---

## Format inject khi gọi skill

Master Agent prefix mỗi skill call theo format sau:

```
[SESSION CONTEXT]
industry: {industry}
active_channels: {active_channels}
kpi_targets: {kpi_targets}
team_size: {team_size} nguoi
team_roles: {team_roles}
budget: {budget_monthly}/thang
source_type_mix: FGC {fgc}% / Brand {brand}% / UGC {ugc}% / EGC {egc}%
mode: {mode}
---
Cac field null (chua co, skill can hoi): {list_of_null_fields}
---

[SKILL INSTRUCTION]
{noi_dung_SKILL.md}
```

---

## Đọc context_requirements từ SKILL.md

Mỗi SKILL.md có phần `context_requirements` trong YAML header:

```yaml
context_requirements:
  required: []           # Field bat buoc — neu null thi hoi truoc khi chay
  optional:              # Field tuy chon — neu co thi dung, neu null thi skip hoac hoi
    - industry
    - active_channels
    - kpi_targets
    - team_size
    - mode
```

**Quy tắc Master Agent:**
1. Doc `context_requirements.required` → neu field nao trong session_context = null → hoi user NGAY, truoc khi chay skill
2. Doc `context_requirements.optional` → nu co trong session_context thi inject, neu khong co thi de null trong prefix
3. Skill tu xu ly null field (hoi user hoac dung default)

---

## Quy tắc không hỏi lại

| Điều kiện | Xử lý |
|-----------|-------|
| session_context.industry != null | KHONG hoi lai nganh |
| session_context.active_channels != null | KHONG hoi lai kenh |
| session_context.kpi_targets != null | KHONG hoi lai KPI muc tieu |
| session_context.team_size != null | KHONG hoi lai so nguoi |
| session_context.mode != null | KHONG hoi lai quick/full |

**Vi pham quan trong:** Neu skill van hoi user ve field da co trong session_context → do la bug trong SKILL.md, can sua.

---

## Cập nhật session_context trong session

Khi user cung cap thong tin moi trong session (VD: "budget cua toi la 20 trieu"), Master Agent:

1. Cap nhat session_context trong working memory
2. Dung gia tri moi cho cac skill tiep theo trong session
3. Danh dau de memory extraction job (chay sau 30 phut) luu vao Supabase

---

## Liên kết với memory-schema.md

`session_context` la subset cua `customer_memory` (Supabase JSONB).
Xem day du schema tai: `sub-agents/memory-schema.md`

Map:
- `session_context.industry` ← `customer_memory.business.industry`
- `session_context.active_channels` ← `customer_memory.marketing_status.running_channels`
- `session_context.kpi_targets` ← `customer_memory.marketing_status.kpi_targets`
- `session_context.team_size` ← `customer_memory.business.team_size`
- `session_context.team_roles` ← `customer_memory.business.team_roles`
- `session_context.budget_monthly` ← `customer_memory.marketing_status.monthly_budget`
- `session_context.source_type_mix` ← `customer_memory.marketing_status.source_type_mix`
- `session_context.customer_profile` ← `customer_memory.customer_profile`
