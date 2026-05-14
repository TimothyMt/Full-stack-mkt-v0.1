# Customer Memory Schema

File này định nghĩa cấu trúc JSONB lưu trong bảng `customer_memory` (Supabase).
Extraction Prompt đọc schema này để biết cần rút gì sau mỗi session.
Master Agent đọc memory này để không hỏi lại thông tin cũ.

---

## Cấu trúc đầy đủ

```json
{
  "business": {
    "name": "Spa Luna",
    "industry": "spa",
    "sub_type": "skincare + trị mụn",
    "stage": "growth",
    "location": "Hà Nội",
    "aov": 500000,
    "team_size": null
  },

  "customer_profile": {
    "target_segment": "Phụ nữ 22–35, công sở, Hà Nội",
    "main_pain_points": ["da mụn", "da nhạy cảm"],
    "main_channels": ["TikTok", "Facebook", "Zalo"]
  },

  "marketing_status": {
    "running_channels": ["Meta Ads", "TikTok organic"],
    "monthly_budget": null,
    "current_challenges": ["khách cũ không quay lại", "CPMess cao"],
    "skills_completed": ["30-retention-strategy"]
  },

  "current_context": {
    "last_skill": "30-retention-strategy",
    "session_summary": "Đang setup hệ thống retention. Spa skincare+trị mụn, AOV 500k, chu kỳ 3-4 tuần. Đã gợi ý 3 bước: chặn rò rỉ tại điểm bán, chu kỳ Zalo OA, gói liệu trình 4 buổi.",
    "open_tasks": [
      "Soạn 3 tin nhắn Zalo mẫu (ngày 1-2, ngày 20-25, ngày 35)",
      "Xử lý nhóm khách bỏ 90+ ngày"
    ],
    "next_suggested_skills": ["05-copy-quang-cao", "31-winback-campaign"],
    "last_updated": "2026-05-14T10:30:00Z"
  }
}
```

---

## Quy tắc từng field

### `business`
| Field | Kiểu | Ghi chú |
|-------|------|---------|
| industry | string | spa / clinic / fnb / gym / education / ecommerce / saas |
| stage | string | new (0–6 tháng) / growth (6–24 tháng) / mature (2 năm+) |
| aov | number | VND, để null nếu chưa biết |

### `marketing_status`
| Field | Kiểu | Ghi chú |
|-------|------|---------|
| skills_completed | array | Danh sách skill đã chạy — tránh chạy lại không cần thiết |
| current_challenges | array | Tự động cập nhật khi khách đề cập vấn đề mới |

### `current_context` ← field mới
| Field | Kiểu | Mục đích |
|-------|------|---------|
| last_skill | string | Skill cuối cùng đã chạy |
| session_summary | string | Tóm tắt 2–3 câu — AI đọc để hiểu đang làm gì |
| open_tasks | array | Việc còn dang dở từ session trước |
| next_suggested_skills | array | Skill nên gọi tiếp theo |
| last_updated | ISO timestamp | Để biết context có còn fresh không |

---

## Extraction Prompt — Hướng dẫn rút data

Chạy sau 30 phút không có tin nhắn mới. Cần cập nhật:

```
1. Merge thông tin mới vào business + customer_profile + marketing_status
2. Cập nhật current_context:
   - last_skill: skill vừa chạy trong session
   - session_summary: tóm tắt 2–3 câu những gì đã làm
   - open_tasks: những việc AI đề xuất nhưng chưa thực hiện
   - next_suggested_skills: dựa trên open_tasks, gợi ý skill tiếp theo
   - last_updated: timestamp hiện tại
3. Giữ nguyên các field không thay đổi
```

---

## Master Agent — Cách dùng current_context

Khi nhận tin nhắn mới từ khách, đọc `current_context` trước:

```
Nếu current_context.open_tasks không rỗng:
  → Nhắc khách: "Lần trước mình đang làm [session_summary], 
     chị muốn tiếp tục [open_tasks[0]] không?"

Nếu khách hỏi việc mới:
  → Classify bình thường, nhưng truyền session_summary 
     vào context của sub-agent được gọi

Nếu last_updated > 7 ngày:
  → Coi như context cũ, không nhắc — bắt đầu fresh
```
