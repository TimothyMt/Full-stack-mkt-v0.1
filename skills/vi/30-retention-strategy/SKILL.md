---
name: 30-retention-strategy
description: Xây dựng hệ thống giữ chân khách hàng theo ngành và giai đoạn kinh doanh — gợi ý cách làm cụ thể, không cần data CRM
metadata:
  version: 1.0.0
  category: strategy
triggers:
  - "giữ chân khách"
  - "khách không quay lại"
  - "retention"
  - "khách hàng trung thành"
  - "loyalty"
  - "tăng tỉ lệ quay lại"
  - "khách cũ"
  - "chăm sóc khách hàng"
  - "hệ thống khách hàng thân thiết"
output: File .md gồm framework retention theo ngành, gợi ý theo giai đoạn + đối tượng, kênh triển khai, KPI cần đo
related:
  - 31-winback-campaign
  - 09-insight-khach-hang
  - 14-email-marketing
---

# Hệ Thống Retention — Giữ Chân Khách Hàng

> Với spa/clinic: 60–70% doanh thu đến từ khách quay lại. Retention không phải "chăm sóc" — đây là hệ thống doanh thu có thể dự báo được.

---

## Thu thập thông tin

Hỏi tối đa 2 câu:

1. **Ngành hàng?** (Spa / Clinic thẩm mỹ / F&B / Gym-Yoga / Giáo dục / Ecommerce / SaaS / Khác)
2. **Đang ở giai đoạn nào + vấn đề cụ thể?**
   - Mới mở (0–6 tháng) — chưa có hệ thống gì
   - Đang tăng trưởng (6–24 tháng) — có khách nhưng ít quay lại
   - Ổn định (2 năm+) — muốn tối ưu LTV và loyalty

---

## Tại sao khách không quay lại — 5 lý do phổ biến

| Lý do | Dấu hiệu | Ngành hay gặp |
|-------|---------|--------------|
| Không ai nhắc — họ quên mất | Không có follow-up sau lần đầu | Spa, clinic, F&B |
| Không có lý do đủ mạnh để quay lại | Dịch vụ tốt nhưng không có ưu đãi/điều mới | Spa, gym, giáo dục |
| Trải nghiệm lần trước chưa đủ ấn tượng | Không có review, không có follow-up hỏi thăm | Tất cả ngành |
| Đối thủ offer hấp dẫn hơn | Khách bị kéo đi bởi deal mới | Ecommerce, F&B |
| Nhu cầu đã được đáp ứng (churn tự nhiên) | Khóa học xong, dự án xong | Giáo dục, SaaS |

---

## Framework Retention theo Giai đoạn

### Giai đoạn 1 — Mới mở (0–6 tháng)

**Ưu tiên:** Tạo thói quen quay lại ngay từ lần đầu. Chưa cần hệ thống phức tạp.

| Hành động | Cách làm | Kênh |
|-----------|---------|------|
| Follow-up 24–48h sau lần đầu | Hỏi thăm kết quả, cảm nhận | Zalo cá nhân, Messenger |
| Offer lần 2 ngay tại điểm bán | "Đặt lịch hôm nay được giảm X%" | Offline + Zalo |
| Thu SĐT / Zalo 100% khách | Bắt buộc — đây là tài sản số | Form điện tử, sổ tay |
| Gửi tips/giá trị sau dịch vụ | Skincare routine sau trị liệu, bài tập về nhà | Zalo OA, Messenger |

**Mục tiêu giai đoạn:** 30% khách quay lại trong 60 ngày.

---

### Giai đoạn 2 — Tăng trưởng (6–24 tháng)

**Ưu tiên:** Phân tầng khách, tạo chu kỳ liên hệ, bắt đầu loyalty đơn giản.

#### Phân tầng 4 nhóm khách

| Nhóm | Định nghĩa | % Khách TB | Hành động ưu tiên |
|------|-----------|-----------|-------------------|
| **Mới** | Mua lần đầu, chưa quay lại | 40–50% | Onboarding tốt, follow-up nhanh |
| **Đang active** | Mua 2+ lần trong 90 ngày | 20–30% | Nuture, upsell nhẹ, tạo thói quen |
| **Có nguy cơ** | Quá 60 ngày không quay lại | 15–20% | Nhắc nhở + ưu đãi nhẹ |
| **Đã bỏ** | Quá 90 ngày không có tương tác | 10–20% | Win-back campaign → xem Skill 31 |

#### Chu kỳ liên hệ gợi ý theo ngành

| Ngành | Chu kỳ tự nhiên | Liên hệ lần 1 | Liên hệ lần 2 | Liên hệ lần 3 |
|-------|---------------|--------------|--------------|--------------|
| Spa (skincare) | 4–6 tuần | Ngày 3 sau dịch vụ | Ngày 25 (nhắc lịch) | Ngày 35 (ưu đãi) |
| Clinic thẩm mỹ | 3–6 tháng | Ngày 7 (kiểm tra kết quả) | Tháng 2 (nhắc tái khám) | Tháng 5 (offer liệu trình mới) |
| Gym / Yoga | Hàng tuần | Ngày 3 (hỏi thăm) | Tuần 3 (check-in) | Hết tháng (gia hạn) |
| F&B | 1–2 tuần | Ngay sau ăn (cảm ơn) | Tuần 2 (offer) | Tháng 1 (loyalty) |
| Giáo dục | Theo khóa | Tuần 1 (onboarding) | Giữa khóa (engagement) | Cuối khóa (upsell khóa tiếp) |
| Ecommerce | 30–45 ngày | Ngày 3 (unboxing check) | Ngày 20 (review) | Ngày 40 (offer lần 2) |

---

### Giai đoạn 3 — Ổn định (2 năm+)

**Ưu tiên:** Hệ thống loyalty bài bản, tối ưu LTV, biến khách thành advocate.

#### Mô hình Loyalty Tier gợi ý

| Tier | Điều kiện | Quyền lợi | Mục tiêu |
|------|-----------|-----------|---------|
| **Member** | Đã mua 1 lần | Tích điểm cơ bản, sinh nhật | Khuyến khích lần 2 |
| **Silver** | 3–5 lần / 6 tháng | Ưu đãi 5–10%, ưu tiên đặt lịch | Tạo thói quen |
| **Gold** | 6–10 lần / 6 tháng | Ưu đãi 10–15%, quà tặng, preview dịch vụ mới | Giữ khách trung thành |
| **VIP** | Top 10% khách | Ưu đãi 15–20%, dịch vụ exclusive, sự kiện riêng | Biến thành advocate |

#### Upsell / Cross-sell đúng thời điểm

| Thời điểm | Gợi ý | Cách nói |
|-----------|-------|---------|
| Đang dùng dịch vụ | Cross-sell dịch vụ bổ sung | "Chị đang làm da, kết hợp massage mặt sẽ giữ kết quả lâu hơn" |
| Vừa xong dịch vụ | Upsell gói dài hạn | "Nếu làm theo liệu trình 4 buổi tiết kiệm được 20%" |
| Nhắc lịch tái khám | Cross-sell sản phẩm chăm sóc tại nhà | "Để duy trì kết quả, chị có thể dùng thêm sản phẩm này" |
| Sinh nhật | Offer đặc biệt | "Quà sinh nhật của chị: ưu đãi 20% buổi tiếp theo" |

---

## Retention theo Đối tượng Khách

### Khách lần đầu — "First-time to Repeat"

**Mục tiêu:** Biến 30–40% khách lần đầu thành khách lần 2 trong 60 ngày.

| Bước | Hành động | Thời điểm | Kênh |
|------|-----------|----------|------|
| 1 | Cảm ơn + hỏi cảm nhận | 24h sau | Zalo cá nhân |
| 2 | Gửi tips chăm sóc tại nhà | 48–72h sau | Zalo OA / Messenger |
| 3 | Nhắc lịch tái dịch vụ | Ngày 20–25 | Zalo OA |
| 4 | Offer lần 2 nếu chưa đặt | Ngày 30 | Zalo + Messenger |

### Khách đang Active — "Nurture & Upsell"

**Mục tiêu:** Tăng AOV và tần suất, không để họ bị đối thủ kéo đi.

| Hành động | Tần suất | Nội dung |
|-----------|---------|---------|
| Tips/giá trị | 2 lần/tháng | Kiến thức liên quan đến dịch vụ đang dùng |
| Thông báo dịch vụ mới | Khi có | "Chị đang làm X, em vừa có dịch vụ Y bổ sung rất tốt" |
| Ưu đãi exclusive | 1 lần/tháng | Chỉ dành cho khách đang active |
| Check-in kết quả | Theo chu kỳ | "Sau 4 buổi, da chị thay đổi thế nào rồi?" |

### Khách VIP — "Advocacy & Referral"

**Mục tiêu:** Biến họ thành kênh marketing miễn phí.

| Hành động | Cách làm |
|-----------|---------|
| Ghi nhận công khai | Tag/mention khi họ cho phép, highlight story của họ |
| Mời trải nghiệm trước | Preview dịch vụ mới trước khi ra mắt |
| Chương trình referral | "Giới thiệu bạn được X% — bạn được Y%" → Skill 18 |
| Sự kiện VIP | Buổi trị liệu miễn phí, event riêng cho nhóm VIP |
| Feedback loop | Hỏi ý kiến về dịch vụ mới — họ cảm thấy được trân trọng |

---

## Kênh Retention theo Ngành

| Kênh | Phù hợp nhất | Nội dung gợi ý | Chi phí |
|------|-------------|---------------|---------|
| **Zalo OA** | Spa, clinic, F&B, gym | Nhắc lịch, tips, ưu đãi, broadcast | Thấp (~500đ/tin) |
| **Zalo cá nhân** | Dịch vụ high-touch, spa, clinic | Follow-up cá nhân, hỏi thăm | Miễn phí |
| **Email** | Ecommerce, SaaS, giáo dục | Newsletter, lifecycle sequence | Thấp (Brevo free 300/ngày) |
| **SMS** | F&B, retail | Nhắc lịch, flash deal | Trung bình (~700đ/tin) |
| **Facebook Group** | Gym, giáo dục, beauty | Community, tips, Q&A | Miễn phí |
| **Messenger** | F&B, ecommerce, spa | Broadcast, chatbot, ưu đãi | Thấp |

---

## KPI Retention cần đo

| KPI | Công thức | Benchmark VN 2025 | Tốt |
|-----|----------|-------------------|-----|
| **Repeat Purchase Rate** | Khách mua 2+ lần / Tổng khách | Beauty: >35% | >50% |
| **Churn Rate** | Khách bỏ trong 90 ngày / Tổng khách | Beauty: <30% | <20% |
| **LTV (12 tháng)** | AOV × Số lần mua TB / năm | Beauty: 3–5x AOV | >5x AOV |
| **Time to 2nd Purchase** | Ngày trung bình từ lần 1 đến lần 2 | Beauty: 45–60 ngày | <30 ngày |
| **Zalo OA Read Rate** | Tin đọc / Tin gửi | Trung bình: 40–60% | >60% |

---

## Retention theo Ngành — Gợi ý nhanh

### Spa / Beauty Salon
- Chu kỳ tự nhiên: 3–6 tuần
- Retention lever mạnh nhất: Nhắc lịch đúng thời điểm + kết quả trước/sau
- Kênh tốt nhất: Zalo OA + Zalo cá nhân
- Offer giữ chân: Gói liệu trình (ít nhất 4 buổi), tặng 1 buổi nếu đặt 5

### Clinic Thẩm mỹ
- Chu kỳ tự nhiên: 1–6 tháng tùy dịch vụ
- Retention lever: Theo dõi kết quả (before/after), nhắc tái khám
- Kênh: Zalo cá nhân, tư vấn viên phụ trách riêng từng khách
- Offer: Gói bảo hành kết quả, liệu trình combo

### F&B
- Chu kỳ tự nhiên: 1–2 tuần
- Retention lever: Loyalty card (stamp/điểm), món mới, sinh nhật
- Kênh: Zalo OA, Messenger, app (nếu có)
- Offer: Mua 9 tặng 1, ưu đãi ngày thường

### Gym / Yoga / Studio
- Chu kỳ: Theo tháng / khóa
- Retention lever: Kết quả tập luyện, community, challenge
- Kênh: Facebook Group, Zalo Group, Messenger
- Offer: Gia hạn sớm được giảm, data goal tracking

### Giáo dục
- Chu kỳ: Theo khóa học (1–6 tháng)
- Retention lever: Kết quả học viên, khóa tiếp theo liên quan
- Kênh: Email, Zalo OA, Facebook Group alumni
- Offer: Alumni discount, bundle khóa tiếp theo

### Ecommerce
- Chu kỳ: 30–60 ngày
- Retention lever: Review request, reorder reminder, personalized offer
- Kênh: Email, Messenger, SMS
- Offer: Discount lần 2, loyalty points, free shipping threshold

---

## Checklist chất lượng

- [ ] Đã xác định ngành và giai đoạn kinh doanh
- [ ] Phân tầng 4 nhóm khách rõ ràng (Mới / Active / Có nguy cơ / Đã bỏ)
- [ ] Chu kỳ liên hệ phù hợp với chu kỳ tự nhiên của ngành
- [ ] Kênh retention phù hợp với đối tượng khách (không áp Zalo OA cho SaaS)
- [ ] Có ít nhất 1 trigger cụ thể cho từng nhóm khách
- [ ] Offer retention không phá vỡ margin (không giảm giá liên tục)
- [ ] KPI đã xác định và biết cách đo
- [ ] Kết nối với Skill 31 cho nhóm "Đã bỏ"
- [ ] Kết nối với Skill 18 cho nhóm VIP → referral
