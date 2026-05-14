---
name: 31-winback-campaign
description: Kịch bản win-back khách đã bỏ — gợi ý cụ thể theo ngành, đối tượng, kênh liên hệ và offer phù hợp. Không cần data CRM.
metadata:
  version: 1.0.0
  category: strategy
triggers:
  - "win-back"
  - "khách lâu không quay lại"
  - "kéo khách cũ về"
  - "khách bỏ"
  - "khách ngừng mua"
  - "lấy lại khách"
  - "khách churn"
  - "khách không liên lạc"
output: File .md gồm kịch bản win-back theo ngành + đối tượng, sequence liên hệ, offer phù hợp, script mẫu
related:
  - 30-retention-strategy
  - 09-insight-khach-hang
  - 14-email-marketing
  - 05-copy-quang-cao
---

# Win-back Campaign — Kéo Khách Đã Bỏ Quay Lại

> Win-back rẻ hơn acquisition 5–7 lần. Nhưng làm sai (spam, offer sai, timing sai) thì mất luôn.

---

## Thu thập thông tin

Hỏi tối đa 2 câu:

1. **Ngành và loại dịch vụ?** (Spa / Clinic / F&B / Gym / Ecommerce / Giáo dục / Khác)
2. **Đối tượng cần win-back là ai?**
   - Khách mua 1 lần, chưa quay lại
   - Khách đã mua nhiều lần, đột ngột dừng
   - Khách VIP cũ, mất liên lạc lâu

---

## Trước khi Win-back — Hiểu lý do họ bỏ

Không biết lý do → offer sai → bị chặn. Phân loại theo dấu hiệu:

| Nhóm | Dấu hiệu nhận biết | Lý do có thể | Cách tiếp cận |
|------|--------------------|-------------|--------------|
| **Quên mất** | Không tương tác, không phàn nàn | Busy, không ai nhắc | Nhắc nhở nhẹ nhàng, không offer ngay |
| **Chưa hài lòng** | Có phàn nàn cũ hoặc không để lại review | Trải nghiệm chưa tốt | Xin lỗi + cải thiện + offer đền bù |
| **Bị đối thủ kéo** | Tương tác với đối thủ trên MXH | Deal tốt hơn, offer hấp dẫn hơn | Offer cạnh tranh + nhấn mạnh điểm khác biệt |
| **Nhu cầu thay đổi** | Ngừng hẳn không có lý do rõ | Hoàn cảnh sống thay đổi | Giới thiệu dịch vụ/sản phẩm mới phù hợp hơn |

---

## Nguyên tắc Win-back

1. **Không giảm giá ngay lần đầu tiếp cận** — tạo cảm giác rẻ tiền, không bền vững
2. **Cá nhân hóa** — đừng gửi broadcast chung cho tất cả
3. **Thừa nhận sự vắng mặt** — "Lâu rồi mình chưa gặp nhau" tốt hơn "Ưu đãi hot"
4. **Giới hạn 3 lần liên hệ** — nếu không phản hồi, dừng lại. Spam = mất khách vĩnh viễn
5. **Offer tăng dần** — lần 1 giá trị thấp, lần 2 cao hơn, lần 3 cao nhất
6. **Test nhỏ trước — BẮT BUỘC** — vì đây là khách cũ, sai tone có thể bị block vĩnh viễn

### Quy trình test trước khi chạy toàn bộ

```
Bước 1 — Chọn 10% danh sách (tối thiểu 5 người, tối đa 10 người)
  → Ưu tiên chọn khách từng có tương tác tốt, ít rủi ro nhất

Bước 2 — Gửi Tin 1 cho nhóm test
  → Theo dõi 48–72h: reply rate, tone phản hồi, có ai bực bội không

Bước 3 — Đánh giá kết quả test
  → Reply rate > 30%: script đang tốt → chạy toàn bộ
  → Reply rate 10–30%: chỉnh lại Tin 1 → test lần 2
  → Reply rate < 10% hoặc có phản hồi tiêu cực: dừng, xem lại tone + offer

Bước 4 — Chỉ chạy toàn bộ sau khi test cho kết quả tốt
```

**Lý do phải test:** Danh sách khách cũ là tài sản — gửi sai 1 lần có thể mất cả danh sách. Tốn 3–5 ngày test nhưng bảo toàn được 90% còn lại.

---

## Sequence Win-back 3 bước

### Lần 1 — Nhắc nhở (Ngày 1)
**Mục tiêu:** Kết nối lại, không bán hàng
**Tone:** Quan tâm, cá nhân

> *"Chị [Tên], lâu rồi mình chưa gặp nhau. Không biết gần đây da chị thế nào rồi? Bên em vừa có thêm dịch vụ mới, để em chia sẻ chị tham khảo nhé."*

### Lần 2 — Offer nhẹ (Ngày 5–7 nếu không phản hồi)
**Mục tiêu:** Tạo lý do cụ thể để quay lại
**Tone:** Ưu đãi có giới hạn, không ép

> *"Chị [Tên], bên em đang có chương trình dành riêng cho khách cũ — [offer cụ thể]. Chỉ còn đến [ngày]. Chị có muốn em giữ lịch không?"*

### Lần 3 — Best offer (Ngày 12–14 nếu vẫn không phản hồi)
**Mục tiêu:** Offer tốt nhất, quyết định cuối
**Tone:** Trân trọng, không khẩn cấp giả tạo

> *"Chị [Tên], em biết chị bận. Đây là ưu đãi tốt nhất em có thể dành cho chị — [offer]. Nếu chị không tiện lần này, em hiểu. Khi nào chị cần, em vẫn ở đây."*

---

## Kịch bản Win-back theo Ngành

### Spa / Beauty Salon

**Trigger:** 45+ ngày không đặt lịch

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Hỏi thăm kết quả da, chia sẻ tips mùa mới | Không có offer | Zalo cá nhân |
| 2 | Nhắc dịch vụ phù hợp mùa hiện tại | Miễn phí 1 bước chăm sóc bổ sung | Zalo OA |
| 3 | Ưu đãi khách cũ có thời hạn | Giảm 15–20% hoặc tặng 1 sản phẩm nhỏ | Zalo cá nhân |

**Script mẫu Zalo — Lần 1:**
> *"Chị [Tên] ơi, lâu rồi em không được gặp chị. Không biết dạo này da chị thế nào rồi ạ? Mùa này thời tiết hanh khô, em thấy nhiều chị em phản hồi da hay bị khô và bong tróc hơn. Chị có đang gặp vấn đề tương tự không ạ?"*

---

### Clinic Thẩm mỹ

**Trigger:** 90+ ngày không tái khám

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Hỏi thăm kết quả liệu trình cũ | Không có offer | Zalo cá nhân (tư vấn viên phụ trách) |
| 2 | Thông báo dịch vụ bảo dưỡng / duy trì kết quả | Tái khám miễn phí | Zalo cá nhân |
| 3 | Offer liệu trình mới hoặc gói gia hạn | Ưu đãi 10–15% cho khách cũ | Zalo + cuộc gọi |

**Script mẫu — Lần 1:**
> *"Chị [Tên] ơi, em [Tên tư vấn viên] từ [Tên clinic] đây ạ. Đã gần [X] tháng từ lần chị làm [dịch vụ] — không biết kết quả hiện tại của chị thế nào rồi ạ? Nếu chị muốn, em có thể tư vấn thêm về việc duy trì kết quả dài hạn."*

---

### F&B (Nhà hàng / Quán cafe)

**Trigger:** 21+ ngày không ghé

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Thông báo món mới / thay đổi menu | Không có offer | Zalo OA / Messenger |
| 2 | Ưu đãi ngày thường | Giảm 15% bill hoặc free item | Zalo OA |
| 3 | Deal sinh nhật hoặc ưu đãi đặc biệt | Combo 2 người giá 1 người | Messenger cá nhân |

---

### Gym / Yoga / Studio

**Trigger:** Hết hẹn gói, không gia hạn sau 14 ngày

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Check-in kết quả tập, hỏi lý do dừng | Không có offer | Zalo cá nhân / Messenger |
| 2 | Giới thiệu gói linh hoạt hơn / phù hợp hơn lịch họ | Trial 1 tuần miễn phí | Zalo OA |
| 3 | Ưu đãi gia hạn có thời hạn | Giảm 20% gói 3 tháng | Zalo cá nhân |

**Insight quan trọng:** Khách gym bỏ thường vì *không thấy kết quả* hoặc *lịch không phù hợp* — không phải vì giá. Hỏi lý do trước khi offer.

---

### Ecommerce

**Trigger:** 45+ ngày không mua, đã mua ít nhất 1 lần

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Gợi ý sản phẩm liên quan đến lần mua trước | Không có offer | Email / Messenger |
| 2 | "Sản phẩm bạn hay mua sắp hết hàng" hoặc "Mùa mới" | Free ship | Email |
| 3 | Ưu đãi khách cũ | Voucher 10–15% | Email + Messenger |

---

### Giáo dục (Trung tâm / Khóa học)

**Trigger:** Hết khóa 30+ ngày, chưa đăng ký tiếp

| Lần | Nội dung | Offer | Kênh |
|-----|---------|-------|------|
| 1 | Hỏi thăm kết quả sau khóa học | Không có offer | Zalo / Email |
| 2 | Giới thiệu khóa tiếp theo phù hợp lộ trình | Ưu đãi alumni 10% | Email + Zalo OA |
| 3 | Deadline đăng ký khóa mới | Giảm 15% nếu đăng ký trước [ngày] | Email + Messenger |

---

## Offer Win-back theo Ngành — Bảng tổng hợp

| Ngành | Offer Tier 1 (nhẹ) | Offer Tier 2 (trung) | Offer Tier 3 (mạnh) |
|-------|-------------------|---------------------|---------------------|
| Spa | Tips / nội dung giá trị | Free add-on (mask, massage thêm 10 phút) | Giảm 15–20% buổi tiếp |
| Clinic | Tư vấn online miễn phí | Tái khám miễn phí | Giảm 10–15% liệu trình |
| F&B | Thông báo món mới | Free item / giảm 10% | Combo 2 giá 1 |
| Gym | Check-in kết quả | Trial 1 tuần | Giảm 20% gói tiếp |
| Ecommerce | Gợi ý cá nhân hóa | Free ship | Voucher 10–15% |
| Giáo dục | Recap kiến thức khóa cũ | Alumni discount 10% | 15% + bonus tài liệu |

---

## Những lỗi phổ biến cần tránh

| Lỗi | Hậu quả | Thay bằng |
|-----|---------|----------|
| Broadcast chung cho tất cả khách cũ | Cảm giác spam, bị chặn | Cá nhân hóa tối thiểu: gọi tên, nhắc dịch vụ đã dùng |
| Giảm giá ngay lần đầu | Khách chỉ quay lại khi có deal | Kết nối cảm xúc trước, offer sau |
| Liên hệ quá 3 lần | Mất khách vĩnh viễn | Dừng sau 3 lần, chờ họ tự liên hệ |
| Tone bán hàng quá lộ | Khách cảm thấy bị lợi dụng | Tone quan tâm, hỏi thăm, không ép |
| Offer không rõ hạn | Không tạo được urgency | Luôn có deadline cụ thể |

---

## Checklist chất lượng

- [ ] Đã xác định ngành và nhóm khách cần win-back
- [ ] Phân tích lý do khách bỏ trước khi chọn offer
- [ ] Sequence đủ 3 bước, offer tăng dần
- [ ] Lần 1 không có offer bán hàng — chỉ kết nối
- [ ] Có deadline cụ thể trong offer
- [ ] Tone phù hợp: quan tâm, không ép, không spam
- [ ] Giới hạn 3 lần liên hệ — dừng nếu không phản hồi
- [ ] Script cá nhân hóa: có tên, có nhắc đến dịch vụ/sản phẩm cũ
- [ ] Kênh phù hợp với ngành (Zalo cá nhân cho high-touch, Email cho ecommerce)
