# HANDOFF — Tiếp tục review skills

## Context project
CMO AI product cho SME spa/clinic — Telegram Bot + n8n + Claude API + Supabase.
Skills nằm tại `skills/vi/` — đang review và update từng file để adaptive theo memory/mode/ngành.

## Branch đang làm
`feature/retention-skills`

## Nguyên tắc cốt lõi khi sửa skills (ĐÃ XÁC LẬP)

1. **Memory-first:** Mọi skill đọc `customer_memory` trước khi hỏi — chỉ hỏi những gì còn thiếu
2. **Mode quick/full:** quick = Telegram response ngắn, full = export file .md đầy đủ
3. **Industry-adaptive:** detect ngành từ memory, chỉ hỏi nếu chưa có
4. **Resource-adaptive:** template thay đổi theo quy mô team (1 người / 2–3 người / 4+)
5. **Results-based timeline:** tiến theo kết quả đạt được, không theo lịch cố định
6. **RACI với tên thật:** hỏi vai trò thực tế, build RACI với tên người dùng cung cấp, mỗi deliverable đúng 1 A

## Trạng thái từng skill

| Skill | Trạng thái | Ghi chú |
|-------|-----------|---------|
| 00-ke-hoach-mkt | ✅ Done | Memory-first, mode quick/full, industry detect 8 ngành, results-based timeline |
| 01-lich-noi-dung | ✅ Done | Memory-first, mode, resource-adaptive template (1 người vs 2-3 người) |
| 02-brief-chien-dich | ✅ Done | Memory-first, mode, 5 phase models, RACI adaptive với tên thật + giải thích RACI |
| 30-retention-strategy | ✅ Done | Skill mới — framework retention 3 giai đoạn, 4 nhóm khách, KPI |
| 31-winback-campaign | ✅ Done | Skill mới — sequence 3 bước, test-first 10%, scripts theo ngành |
| **03-danh-gia-hieu-suat** | 🔄 **Đang làm** | Đã review xong, chưa sửa — xem issues bên dưới |
| 04–21 | ⏳ Chưa làm | |

## Issues cần sửa Skill 03 (ĐÃ XÁC ĐỊNH, CHƯA SỬA)

1. **[Critical]** Thêm bước đọc memory trước khi hỏi — pre-fill kênh, KPI từ memory, chỉ hỏi số liệu hiện tại + vấn đề cụ thể
2. **[Critical]** Thêm mode quick/full — quick: diagnostic + top 3 action (3–5 dòng); full: 9 phần đầy đủ
3. **[High]** 48h Action Plan phải dynamic theo kết quả diagnostic tree, không phải template cứng 8 bước
4. **[High]** Benchmark table thiếu ngành: Clinic thẩm mỹ, Gym/Fitness — thêm vào bảng theo ngành
5. **[Medium]** MCP section simplify — chỉ giữ: "nếu tài khoản đã kết nối, data pull tự động"; ẩn technical details

Vấn đề phụ (fix nhẹ): Weekly checklist cần 2 version (solo vs team), Trend analysis thêm seasonal context VN (Tết, mùa hè...), thêm handling khi data < 1,000 impressions.

## Cách tiếp tục

Paste vào đầu session mới:

> "Tiếp tục project CMO AI — đọc file HANDOFF.md tại root để biết context. Bắt đầu bằng việc sửa Skill 03 theo 5 issues đã xác định."

## Files quan trọng
- `CLAUDE.md` — identity + workflow của toàn bộ hệ thống
- `sub-agents/memory-schema.md` — schema JSONB cho customer memory
- `skills/vi/` — 32 skills tiếng Việt
