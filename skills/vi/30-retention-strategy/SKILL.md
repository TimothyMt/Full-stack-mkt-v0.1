---
name: 30-retention-strategy
description: Xay dung he thong giu chan khach hang theo nganh va giai doan kinh doanh — phan tang 4 nhom, chu ky lien he, loyalty tier, upsell, kenh va KPI cu the.
skill_id: "30-retention-strategy"
agent: "mkt-strategist"
metadata:
  version: 2.0.0
  category: strategy
triggers:
  - "giu chan khach"
  - "khach khong quay lai"
  - "retention"
  - "khach hang trung thanh"
  - "loyalty"
  - "tang ti le quay lai"
  - "khach cu"
  - "cham soc khach hang"
  - "he thong khach hang than thiet"
output: File .md / Google Sheet gom framework retention theo nganh, phan tang 4 nhom, chu ky lien he, kenh trien khai, KPI can do
context_requirements:
  required: []
  optional:
    - industry
    - business_stage
    - active_channels
    - business_name
related:
  - 31-winback-campaign
  - 09-insight-khach-hang
  - 14-email-marketing
---

# He Thong Retention — Giu Chan Khach Hang

> Voi spa/clinic: 60–70% doanh thu den tu khach quay lai. Retention khong phai "cham soc" — day la he thong doanh thu co the du bao duoc.

---

## Thu thap thong tin

Neu session_context da co industry va business_stage → bo qua, lay tu context.

Neu chua co, hoi 2 cau:

1. **Nganh hang?** (Spa / Clinic tham my / F&B / Gym-Yoga / Giao duc / Ecommerce / SaaS / Khac)
2. **Dang o giai doan nao + van de cu the?**
   - Moi mo (0–6 thang) — chua co he thong gi
   - Dang tang truong (6–24 thang) — co khach nhung it quay lai
   - On dinh (2 nam+) — muon toi uu LTV va loyalty

---

## Tai sao Khach Khong Quay Lai — 5 Ly Do Pho Bien

| Ly do | Dau hieu | Nganh hay gap |
|-------|---------|--------------|
| Khong ai nhac — ho quen mat | Khong co follow-up sau lan dau | Spa, clinic, F&B |
| Khong co ly do du manh de quay lai | Dich vu tot nhung khong co uu dai/dieu moi | Spa, gym, giao duc |
| Trai nghiem lan truoc chua du an tuong | Khong co review, khong co follow-up hoi tham | Tat ca nganh |
| Doi thu offer hap dan hon | Khach bi keo di boi deal moi | Ecommerce, F&B |
| Nhu cau da duoc dap ung (churn tu nhien) | Khoa hoc xong, du an xong | Giao duc, SaaS |

---

## Framework Retention theo Giai Doan Kinh Doanh

### Giai doan 1 — Moi mo (0–6 thang)

**Uu tien:** Tao thoi quen quay lai ngay tu lan dau. Chua can he thong phuc tap.

| Hanh dong | Cach lam | Kenh |
|-----------|---------|------|
| Follow-up 24–48h sau lan dau | Hoi tham ket qua, cam nhan | Zalo ca nhan, Messenger |
| Offer lan 2 ngay tai diem ban | "Dat lich hom nay duoc giam X%" | Offline + Zalo |
| Thu SDT / Zalo 100% khach | Bat buoc — day la tai san so | Form dien tu, so tay |
| Gui tips/gia tri sau dich vu | Skincare routine sau tri lieu, bai tap ve nha | Zalo OA, Messenger |

**Muc tieu giai doan:** 30% khach quay lai trong 60 ngay.

---

### Giai doan 2 — Tang truong (6–24 thang)

**Uu tien:** Phan tang khach, tao chu ky lien he, bat dau loyalty don gian.

#### Phan tang 4 nhom khach

| Nhom | Dinh nghia | % Khach TB | Content phu hop | Kenh | Uu dai | Hanh dong uu tien |
|------|-----------|-----------|----------------|------|--------|-------------------|
| **Moi** | Mua lan dau, chua quay lai | 40–50% | TOFU: giao duc, social proof, ket qua thuc te | TikTok, Facebook, Zalo ca nhan | Trial, lan 2 giam nhe | Onboarding tot, follow-up nhanh trong 48h |
| **Dang active** | Mua 2+ lan trong 90 ngay | 20–30% | MOFU: gia tri them, dich vu moi, ket qua | Zalo OA, Email, Messenger | Loyalty tier, upsell nhe | Nurture, cham soc deu dang, khong de churn |
| **Co nguy co** | Qua 60 ngay khong quay lai | 15–20% | Nhac nho, uu dai co thoi han, case study | Zalo OA, Email, SMS | Uu dai nhe kem han dung | Nhan tin ca nhan — hoi ly do, gui offer |
| **Da bo** | Qua 90 ngay khong tuong tac | 10–20% | Win-back: hoi ly do, offer dac biet | Email, Zalo, SMS | Comeback offer manh hon | Chuyen sang Skill 31 — win-back campaign |

#### Chu ky lien he goi y theo nganh

| Nganh | Chu ky tu nhien | Lien he lan 1 | Lien he lan 2 | Lien he lan 3 |
|-------|---------------|--------------|--------------|--------------|
| Spa (skincare) | 4–6 tuan | Ngay 3 sau dich vu | Ngay 25 (nhac lich) | Ngay 35 (uu dai) |
| Clinic tham my | 3–6 thang | Ngay 7 (kiem tra ket qua) | Thang 2 (nhac tai kham) | Thang 5 (offer lieu trinh moi) |
| Gym / Yoga | Hang tuan | Ngay 3 (hoi tham) | Tuan 3 (check-in) | Het thang (gia han) |
| F&B | 1–2 tuan | Ngay sau an (cam on) | Tuan 2 (offer) | Thang 1 (loyalty) |
| Giao duc | Theo khoa | Tuan 1 (onboarding) | Giua khoa (engagement) | Cuoi khoa (upsell khoa tiep) |
| Ecommerce | 30–45 ngay | Ngay 3 (unboxing check) | Ngay 20 (review) | Ngay 40 (offer lan 2) |

---

### Giai doan 3 — On dinh (2 nam+)

**Uu tien:** He thong loyalty bai ban, toi uu LTV, bien khach thanh advocate.

#### Mo hinh Loyalty Tier goi y

| Tier | Dieu kien | Quyen loi | Muc tieu |
|------|-----------|-----------|---------|
| **Member** | Da mua 1 lan | Tich diem co ban, sinh nhat | Khuyen khich lan 2 |
| **Silver** | 3–5 lan / 6 thang | Uu dai 5–10%, uu tien dat lich | Tao thoi quen |
| **Gold** | 6–10 lan / 6 thang | Uu dai 10–15%, qua tang, preview dich vu moi | Giu khach trung thanh |
| **VIP** | Top 10% khach | Uu dai 15–20%, dich vu exclusive, su kien rieng | Bien thanh advocate |

#### Upsell / Cross-sell dung thoi diem

| Thoi diem | Goi y | Cach noi |
|-----------|-------|---------|
| Dang dung dich vu | Cross-sell dich vu bo sung | "Chi dang lam da, ket hop massage mat se giu ket qua lau hon" |
| Vua xong dich vu | Upsell goi dai han | "Neu lam theo lieu trinh 4 buoi tiet kiem duoc 20%" |
| Nhac lich tai kham | Cross-sell san pham cham soc tai nha | "De duy tri ket qua, chi co the dung them san pham nay" |
| Sinh nhat | Offer dac biet | "Qua sinh nhat cua chi: uu dai 20% buoi tiep theo" |

#### Khach VIP — Bien thanh Advocate

| Hanh dong | Cach lam |
|-----------|---------|
| Ghi nhan cong khai | Tag/mention khi ho cho phep, highlight story cua ho |
| Moi trai nghiem truoc | Preview dich vu moi truoc khi ra mat |
| Chuong trinh referral | "Gioi thieu ban duoc X% — ban duoc Y%" → Skill 18 |
| Su kien VIP | Buoi tri lieu mien phi, event rieng cho nhom VIP |
| Feedback loop | Hoi y kien ve dich vu moi — ho cam thay duoc tran trong |

---

## Kenh Retention theo Nganh

| Kenh | Phu hop nhat | Noi dung goi y | Chi phi |
|------|-------------|---------------|---------|
| **Zalo OA** | Spa, clinic, F&B, gym | Nhac lich, tips, uu dai, broadcast | Thap (~500d/tin) |
| **Zalo ca nhan** | Dich vu high-touch, spa, clinic | Follow-up ca nhan, hoi tham | Mien phi |
| **Email** | Ecommerce, SaaS, giao duc | Newsletter, lifecycle sequence | Thap (Brevo free 300/ngay) |
| **SMS** | F&B, retail | Nhac lich, flash deal | Trung binh (~700d/tin) |
| **Facebook Group** | Gym, giao duc, beauty | Community, tips, Q&A | Mien phi |
| **Messenger** | F&B, ecommerce, spa | Broadcast, chatbot, uu dai | Thap |

---

## KPI Retention can Do

| KPI | Cong thuc | Benchmark VN 2025 | Tot |
|-----|----------|-------------------|-----|
| **Repeat Purchase Rate** | Khach mua 2+ lan / Tong khach | Beauty: >35% | >50% |
| **Churn Rate** | Khach bo trong 90 ngay / Tong khach | Beauty: <30% | <20% |
| **LTV (12 thang)** | AOV × So lan mua TB / nam | Beauty: 3–5x AOV | >5x AOV |
| **Time to 2nd Purchase** | Ngay trung binh tu lan 1 den lan 2 | Beauty: 45–60 ngay | <30 ngay |
| **Zalo OA Read Rate** | Tin doc / Tin gui | Trung binh: 40–60% | >60% |

---

## Retention theo Nganh — Goi y Nhanh

### Spa / Beauty Salon
- Chu ky tu nhien: 3–6 tuan
- Retention lever manh nhat: Nhac lich dung thoi diem + ket qua truoc/sau
- Kenh tot nhat: Zalo OA + Zalo ca nhan
- Offer giu chan: Goi lieu trinh (it nhat 4 buoi), tang 1 buoi neu dat 5

### Clinic Tham my
- Chu ky tu nhien: 1–6 thang tuy dich vu
- Retention lever: Theo doi ket qua (before/after), nhac tai kham
- Kenh: Zalo ca nhan, tu van vien phu trach rieng tung khach
- Offer: Goi bao hanh ket qua, lieu trinh combo

### F&B
- Chu ky tu nhien: 1–2 tuan
- Retention lever: Loyalty card (stamp/diem), mon moi, sinh nhat
- Kenh: Zalo OA, Messenger, app (neu co)
- Offer: Mua 9 tang 1, uu dai ngay thuong

### Gym / Yoga / Studio
- Chu ky: Theo thang / khoa
- Retention lever: Ket qua tap luyen, community, challenge
- Kenh: Facebook Group, Zalo Group, Messenger
- Offer: Gia han som duoc giam, goal tracking

### Giao duc
- Chu ky: Theo khoa hoc (1–6 thang)
- Retention lever: Ket qua hoc vien, khoa tiep theo lien quan
- Kenh: Email, Zalo OA, Facebook Group alumni
- Offer: Alumni discount, bundle khoa tiep theo

### Ecommerce
- Chu ky: 30–60 ngay
- Retention lever: Review request, reorder reminder, personalized offer
- Kenh: Email, Messenger, SMS
- Offer: Discount lan 2, loyalty points, free shipping threshold

---

## Checklist Chat Luong

- [ ] Da xac dinh nganh va giai doan kinh doanh
- [ ] Phan tang du 4 nhom khach (Moi / Active / Co nguy co / Da bo) voi hanh dong cu the cho tung nhom
- [ ] Chu ky lien he phu hop voi chu ky tu nhien cua nganh
- [ ] Kenh retention phu hop voi doi tuong khach (khong ap Zalo OA cho SaaS)
- [ ] Co it nhat 1 trigger cu the cho tung nhom khach
- [ ] Offer retention khong pha vo margin (khong giam gia lien tuc)
- [ ] KPI da xac dinh va biet cach do
- [ ] Ket noi voi Skill 31 cho nhom "Da bo"
- [ ] Ket noi voi Skill 18 cho nhom VIP → referral
