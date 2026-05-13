#!/bin/bash
# AI Business Skills — Installer for Claude Code
# Usage: ./install.sh [--global | --project]
# Version: 2.5.1-fix

set -e

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${HOME}/.claude"
TARGET=""
CHECKPOINT_FILE=""

# ─── Màu sắc ───────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

log_ok()   { echo -e "${GREEN}✓${NC} $1"; }
log_info() { echo -e "${CYAN}→${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
log_err()  { echo -e "${RED}✗${NC} $1"; }

# ─── Parse args ────────────────────────────────────────────
case "${1:-}" in
  --global)
    TARGET="${CLAUDE_HOME}/skills/marketing"
    ;;
  --project)
    TARGET=".claude/skills/marketing"
    ;;
  *)
    echo -e "${BOLD}AI Business Skills — Installer${NC}"
    echo ""
    echo "Usage:"
    echo "  ./install.sh --global    # Cài cho tất cả projects (~/.claude/skills/marketing)"
    echo "  ./install.sh --project   # Cài cho project hiện tại (./.claude/skills/marketing)"
    echo ""
    echo "Chọn kiểu cài đặt:"
    echo "  1) Global  — dùng cho tất cả projects"
    echo "  2) Project — chỉ dùng cho project này"
    read -rp "Nhập [1/2]: " choice
    case "$choice" in
      1) TARGET="${CLAUDE_HOME}/skills/marketing" ;;
      2) TARGET=".claude/skills/marketing" ;;
      *) log_err "Lựa chọn không hợp lệ." && exit 1 ;;
    esac
    ;;
esac

CHECKPOINT_FILE="${TARGET}/.install_checkpoint"

echo ""
log_info "Sẽ cài vào: ${TARGET}"
echo ""

# ─── Checkpoint system ─────────────────────────────────────
# Mỗi bước được đánh số. Nếu script bị dừng giữa chừng,
# lần chạy tiếp theo sẽ bỏ qua các bước đã hoàn thành.

get_checkpoint() {
  if [ -f "$CHECKPOINT_FILE" ]; then
    cat "$CHECKPOINT_FILE"
  else
    echo "0"
  fi
}

save_checkpoint() {
  echo "$1" > "$CHECKPOINT_FILE"
}

LAST_STEP=$(get_checkpoint)

if [ "$LAST_STEP" -gt "0" ]; then
  echo -e "${YELLOW}⚠ Phát hiện cài đặt chưa hoàn thành (dừng ở bước $LAST_STEP).${NC}"
  echo -e "${YELLOW}  Tiếp tục từ bước $((LAST_STEP + 1))...${NC}"
  echo ""
fi

# ─── STEP 1: Tạo cấu trúc thư mục ─────────────────────────
if [ "$LAST_STEP" -lt "1" ]; then
  log_info "[1/7] Tạo cấu trúc thư mục..."
  mkdir -p "${TARGET}"
  mkdir -p "${TARGET}/skills/vi"
  mkdir -p "${TARGET}/skills/en"
  mkdir -p "${TARGET}/modules/personal-branding/vi"
  mkdir -p "${TARGET}/modules/personal-branding/en"
  mkdir -p "${TARGET}/modules/dropshipping/en"
  mkdir -p "${TARGET}/references/vi"
  mkdir -p "${TARGET}/references/en"
  mkdir -p "${TARGET}/workflows/vi"
  mkdir -p "${TARGET}/workflows/en"
  mkdir -p "${TARGET}/agents"
  # FIX BUG #4: Tạo .agents template folder
  mkdir -p "${TARGET}/.agents-template"
  save_checkpoint 1
  log_ok "Tạo thư mục xong"
fi

# ─── STEP 2: Copy skills tiếng Việt ────────────────────────
if [ "$LAST_STEP" -lt "2" ]; then
  log_info "[2/7] Copy skills tiếng Việt (skills/vi/)..."
  if [ -d "${SKILL_DIR}/skills/vi" ]; then
    cp -r "${SKILL_DIR}/skills/vi/." "${TARGET}/skills/vi/"
    VI_COUNT=$(find "${TARGET}/skills/vi" -name "SKILL.md" | wc -l | tr -d ' ')
    save_checkpoint 2
    log_ok "Skills VI: ${VI_COUNT} skills"
  else
    log_err "Không tìm thấy ${SKILL_DIR}/skills/vi"
    exit 1
  fi
fi

# ─── STEP 3: Copy skills tiếng Anh ─────────────────────────
if [ "$LAST_STEP" -lt "3" ]; then
  log_info "[3/7] Copy skills tiếng Anh (skills/en/)..."
  if [ -d "${SKILL_DIR}/skills/en" ]; then
    cp -r "${SKILL_DIR}/skills/en/." "${TARGET}/skills/en/"
    EN_COUNT=$(find "${TARGET}/skills/en" -name "SKILL.md" | wc -l | tr -d ' ')
    save_checkpoint 3
    log_ok "Skills EN: ${EN_COUNT} skills"
  else
    log_err "Không tìm thấy ${SKILL_DIR}/skills/en"
    exit 1
  fi
fi

# ─── STEP 4: Copy modules (FIX BUG #1) ─────────────────────
if [ "$LAST_STEP" -lt "4" ]; then
  log_info "[4/7] Copy modules/ (personal-branding + dropshipping)..."
  MODULES_OK=0

  # Personal Branding — Tiếng Việt
  if [ -d "${SKILL_DIR}/modules/personal-branding/vi" ]; then
    cp -r "${SKILL_DIR}/modules/personal-branding/vi/." "${TARGET}/modules/personal-branding/vi/"
    PB_VI=$(find "${TARGET}/modules/personal-branding/vi" -name "SKILL.md" | wc -l | tr -d ' ')
    log_ok "  Personal Brand VI: ${PB_VI} skills (22–28)"
    MODULES_OK=$((MODULES_OK + PB_VI))
  else
    log_warn "  modules/personal-branding/vi/ không tìm thấy"
  fi

  # Personal Branding — Tiếng Anh
  if [ -d "${SKILL_DIR}/modules/personal-branding/en" ]; then
    cp -r "${SKILL_DIR}/modules/personal-branding/en/." "${TARGET}/modules/personal-branding/en/"
    PB_EN=$(find "${TARGET}/modules/personal-branding/en" -name "SKILL.md" | wc -l | tr -d ' ')
    log_ok "  Personal Brand EN: ${PB_EN} skills (22–28 global)"
    MODULES_OK=$((MODULES_OK + PB_EN))
  else
    log_warn "  modules/personal-branding/en/ không tìm thấy"
  fi

  # Dropshipping Global
  if [ -d "${SKILL_DIR}/modules/dropshipping/en" ]; then
    cp -r "${SKILL_DIR}/modules/dropshipping/en/." "${TARGET}/modules/dropshipping/en/"
    DS_EN=$(find "${TARGET}/modules/dropshipping/en" -name "SKILL.md" | wc -l | tr -d ' ')
    log_ok "  Dropshipping EN: ${DS_EN} skills"
    MODULES_OK=$((MODULES_OK + DS_EN))
  else
    log_warn "  modules/dropshipping/en/ không tìm thấy"
  fi

  save_checkpoint 4
  log_ok "Modules: ${MODULES_OK} skills"
fi

# ─── STEP 5: Copy references (FIX BUG #2) ──────────────────
if [ "$LAST_STEP" -lt "5" ]; then
  log_info "[5/7] Copy references..."
  REF_OK=0

  # FIX: References nằm trong skills/vi/references và skills/en/references
  if [ -d "${SKILL_DIR}/skills/vi/references" ]; then
    cp -r "${SKILL_DIR}/skills/vi/references/." "${TARGET}/references/vi/"
    REF_VI=$(ls "${TARGET}/references/vi/" | wc -l | tr -d ' ')
    log_ok "  References VI: ${REF_VI} files"
    REF_OK=$((REF_OK + REF_VI))
  else
    log_warn "  skills/vi/references/ không tìm thấy"
  fi

  if [ -d "${SKILL_DIR}/skills/en/references" ]; then
    cp -r "${SKILL_DIR}/skills/en/references/." "${TARGET}/references/en/"
    REF_EN=$(ls "${TARGET}/references/en/" | wc -l | tr -d ' ')
    log_ok "  References EN: ${REF_EN} files"
    REF_OK=$((REF_OK + REF_EN))
  else
    log_warn "  skills/en/references/ không tìm thấy"
  fi

  save_checkpoint 5
  log_ok "References: ${REF_OK} files"
fi

# ─── STEP 6: Copy workflows + agents ───────────────────────
if [ "$LAST_STEP" -lt "6" ]; then
  log_info "[6/7] Copy workflows & agents..."

  if [ -d "${SKILL_DIR}/workflows/vi" ]; then
    cp -r "${SKILL_DIR}/workflows/vi/." "${TARGET}/workflows/vi/"
    WF_VI=$(ls "${TARGET}/workflows/vi/"*.md 2>/dev/null | wc -l | tr -d ' ')
    log_ok "  Workflows VI: ${WF_VI} files"
  fi

  if [ -d "${SKILL_DIR}/workflows/en" ]; then
    cp -r "${SKILL_DIR}/workflows/en/." "${TARGET}/workflows/en/"
    WF_EN=$(ls "${TARGET}/workflows/en/"*.md 2>/dev/null | wc -l | tr -d ' ')
    log_ok "  Workflows EN: ${WF_EN} files"
  fi

  if [ -d "${SKILL_DIR}/agents" ]; then
    cp -r "${SKILL_DIR}/agents/." "${TARGET}/agents/"
    AG_COUNT=$(ls "${TARGET}/agents/"*.md 2>/dev/null | wc -l | tr -d ' ')
    log_ok "  Agents: ${AG_COUNT} files"
  fi

  save_checkpoint 6
  log_ok "Workflows & agents xong"
fi

# ─── STEP 7: Copy CLAUDE.md + tạo .agents template ─────────
if [ "$LAST_STEP" -lt "7" ]; then
  log_info "[7/7] Copy CLAUDE.md + tạo .agents template..."

  # Copy CLAUDE.md
  if [ -f "${SKILL_DIR}/CLAUDE.md" ]; then
    cp "${SKILL_DIR}/CLAUDE.md" "${TARGET}/CLAUDE.md"
    log_ok "  CLAUDE.md copied"
  fi

  # FIX BUG #4 & #5: Tạo template .agents context files
  cat > "${TARGET}/.agents-template/product-marketing-context.md" << 'TEMPLATE'
# Product Marketing Context

## Thương hiệu / Brand
- Tên: [Điền tên thương hiệu]
- Ngành: [Spa / F&B / Thời trang / v.v.]
- Website: [URL]

## Sản phẩm / Dịch vụ chính
- [Mô tả ngắn sản phẩm/dịch vụ]

## Khách hàng mục tiêu
- Độ tuổi: [VD: 25-35]
- Giới tính: [Nam / Nữ / Cả hai]
- Vùng địa lý: [Hà Nội / HCM / Toàn quốc]
- Thu nhập: [VD: 15-30 triệu/tháng]

## Mục tiêu marketing hiện tại
- [VD: Tăng leads từ Meta Ads]
- [VD: Giảm CPMess xuống dưới 20K]

## Ngân sách marketing/tháng
- Ads: [VD: 30 triệu/tháng]
- Content: [VD: 10 triệu/tháng]

## Kênh đang dùng
- [ ] Facebook / Meta Ads
- [ ] TikTok / TikTok Ads
- [ ] Google Ads
- [ ] Zalo OA
- [ ] Email Marketing
- [ ] Khác: [...]

## Ghi chú thêm
- [Thông tin quan trọng khác]
TEMPLATE

  cat > "${TARGET}/.agents-template/personal-brand-context.md" << 'TEMPLATE'
# Personal Brand Context

## Thông tin cá nhân
- Tên: [Họ tên]
- Lĩnh vực chuyên môn: [VD: Marketing / Tài chính / Sức khỏe]
- Vị trí hiện tại: [VD: CMO tại Công ty X]

## Định vị thương hiệu cá nhân
- Expertise chính: [VD: Growth Marketing cho SMEs]
- Đối tượng theo dõi mục tiêu: [VD: Chủ doanh nghiệp 30-45 tuổi]
- Tông giọng: [VD: Chuyên nghiệp nhưng gần gũi]

## Kênh đang xây dựng
- [ ] LinkedIn
- [ ] Facebook cá nhân
- [ ] TikTok
- [ ] YouTube
- [ ] Podcast
- [ ] Newsletter

## Mục tiêu 6 tháng
- [VD: Đạt 10K followers LinkedIn]
- [VD: Ra mắt khóa học online]

## Ghi chú thêm
- [Thông tin quan trọng khác]
TEMPLATE

  save_checkpoint 7
  log_ok "CLAUDE.md + .agents template xong"
fi

# ─── Xóa checkpoint khi hoàn thành ─────────────────────────
rm -f "$CHECKPOINT_FILE"

# ─── Summary ────────────────────────────────────────────────
TOTAL_SKILLS=$(find "${TARGET}" -name "SKILL.md" | wc -l | tr -d ' ')
TOTAL_MD=$(find "${TARGET}" -name "*.md" | wc -l | tr -d ' ')

echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  ✓ Cài đặt hoàn thành!${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════${NC}"
echo ""
echo -e "  📁 Vị trí:     ${CYAN}${TARGET}${NC}"
echo -e "  🎯 Skills:     ${BOLD}${TOTAL_SKILLS} SKILL.md files${NC}"
echo -e "  📄 Tổng files: ${BOLD}${TOTAL_MD} .md files${NC}"
echo ""
echo -e "${BOLD}Bước tiếp theo — Tạo context file cho project của bạn:${NC}"
echo ""
echo -e "  ${CYAN}1. Copy template vào project root:${NC}"
echo -e "     mkdir -p .agents"
echo -e "     cp \"${TARGET}/.agents-template/product-marketing-context.md\" .agents/"
echo ""
echo -e "  ${CYAN}2. Chỉnh sửa file context với thông tin thực tế${NC}"
echo ""
echo -e "  ${CYAN}3. Dùng trong Claude Code:${NC}"
echo -e "     > Lập kế hoạch marketing cho [sản phẩm]"
echo -e "     > Viết script TikTok cho [sản phẩm]"
echo -e "     > /skill 05-copy-quang-cao"
echo ""
echo -e "  📖 Hướng dẫn đầy đủ: ${CYAN}docs/getting-started.md${NC}"
echo ""