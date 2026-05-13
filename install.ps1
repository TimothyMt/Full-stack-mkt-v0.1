# AI Business Skills — Installer for Claude Code (Windows)
# Usage: .\install.ps1 [-Global] [-Project]
# Version: 2.5.1-fix

param(
    [switch]$Global,
    [switch]$Project
)

$ErrorActionPreference = "Stop"
$SkillDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ─── Màu sắc ───────────────────────────────────────────────
function Write-Ok($msg)   { Write-Host "✓ $msg" -ForegroundColor Green }
function Write-Info($msg) { Write-Host "→ $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "⚠ $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "✗ $msg" -ForegroundColor Red }

# ─── Xác định Target ───────────────────────────────────────
if ($Global) {
    $Target = Join-Path $env:USERPROFILE ".claude\skills\marketing"
} elseif ($Project) {
    $Target = ".claude\skills\marketing"
} else {
    Write-Host "AI Business Skills — Installer" -ForegroundColor White
    Write-Host ""
    Write-Host "Chọn kiểu cài đặt:"
    Write-Host "  1) Global  — dùng cho tất cả projects (~/.claude/skills/marketing)"
    Write-Host "  2) Project — chỉ dùng cho project này (./.claude/skills/marketing)"
    $choice = Read-Host "Nhập [1/2]"
    switch ($choice) {
        "1" { $Target = Join-Path $env:USERPROFILE ".claude\skills\marketing" }
        "2" { $Target = ".claude\skills\marketing" }
        default { Write-Err "Lựa chọn không hợp lệ."; exit 1 }
    }
}

$CheckpointFile = Join-Path $Target ".install_checkpoint"

Write-Host ""
Write-Info "Sẽ cài vào: $Target"
Write-Host ""

# ─── Checkpoint system ─────────────────────────────────────
function Get-Checkpoint {
    if (Test-Path $CheckpointFile) {
        return [int](Get-Content $CheckpointFile)
    }
    return 0
}

function Save-Checkpoint($step) {
    $step | Set-Content $CheckpointFile
}

$LastStep = Get-Checkpoint

if ($LastStep -gt 0) {
    Write-Warn "Phát hiện cài đặt chưa hoàn thành (dừng ở bước $LastStep)."
    Write-Warn "Tiếp tục từ bước $($LastStep + 1)..."
    Write-Host ""
}

# ─── STEP 1: Tạo cấu trúc thư mục ─────────────────────────
if ($LastStep -lt 1) {
    Write-Info "[1/7] Tạo cấu trúc thư mục..."

    $dirs = @(
        $Target,
        "$Target\skills\vi",
        "$Target\skills\en",
        "$Target\modules\personal-branding\vi",
        "$Target\modules\personal-branding\en",
        "$Target\modules\dropshipping\en",
        "$Target\references\vi",
        "$Target\references\en",
        "$Target\workflows\vi",
        "$Target\workflows\en",
        "$Target\agents",
        "$Target\.agents-template"
    )

    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }

    Save-Checkpoint 1
    Write-Ok "Tạo thư mục xong"
}

# ─── STEP 2: Copy skills tiếng Việt ────────────────────────
if ($LastStep -lt 2) {
    Write-Info "[2/7] Copy skills tiếng Việt (skills/vi/)..."
    $src = Join-Path $SkillDir "skills\vi"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\skills\vi\" -Recurse -Force
        $count = (Get-ChildItem "$Target\skills\vi" -Recurse -Filter "SKILL.md").Count
        Save-Checkpoint 2
        Write-Ok "Skills VI: $count skills"
    } else {
        Write-Err "Không tìm thấy $src"; exit 1
    }
}

# ─── STEP 3: Copy skills tiếng Anh ─────────────────────────
if ($LastStep -lt 3) {
    Write-Info "[3/7] Copy skills tiếng Anh (skills/en/)..."
    $src = Join-Path $SkillDir "skills\en"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\skills\en\" -Recurse -Force
        $count = (Get-ChildItem "$Target\skills\en" -Recurse -Filter "SKILL.md").Count
        Save-Checkpoint 3
        Write-Ok "Skills EN: $count skills"
    } else {
        Write-Err "Không tìm thấy $src"; exit 1
    }
}

# ─── STEP 4: Copy modules (FIX BUG #1) ─────────────────────
if ($LastStep -lt 4) {
    Write-Info "[4/7] Copy modules/ (personal-branding + dropshipping)..."
    $modulesOk = 0

    # Personal Branding VI
    $src = Join-Path $SkillDir "modules\personal-branding\vi"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\modules\personal-branding\vi\" -Recurse -Force
        $count = (Get-ChildItem "$Target\modules\personal-branding\vi" -Recurse -Filter "SKILL.md").Count
        Write-Ok "  Personal Brand VI: $count skills (22-28)"
        $modulesOk += $count
    } else { Write-Warn "  modules\personal-branding\vi\ không tìm thấy" }

    # Personal Branding EN
    $src = Join-Path $SkillDir "modules\personal-branding\en"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\modules\personal-branding\en\" -Recurse -Force
        $count = (Get-ChildItem "$Target\modules\personal-branding\en" -Recurse -Filter "SKILL.md").Count
        Write-Ok "  Personal Brand EN: $count skills (22-28 global)"
        $modulesOk += $count
    } else { Write-Warn "  modules\personal-branding\en\ không tìm thấy" }

    # Dropshipping EN
    $src = Join-Path $SkillDir "modules\dropshipping\en"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\modules\dropshipping\en\" -Recurse -Force
        $count = (Get-ChildItem "$Target\modules\dropshipping\en" -Recurse -Filter "SKILL.md").Count
        Write-Ok "  Dropshipping EN: $count skills"
        $modulesOk += $count
    } else { Write-Warn "  modules\dropshipping\en\ không tìm thấy" }

    Save-Checkpoint 4
    Write-Ok "Modules: $modulesOk skills"
}

# ─── STEP 5: Copy references (FIX BUG #2) ──────────────────
if ($LastStep -lt 5) {
    Write-Info "[5/7] Copy references..."
    $refOk = 0

    # FIX: References nằm trong skills/vi/references
    $src = Join-Path $SkillDir "skills\vi\references"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\references\vi\" -Recurse -Force
        $count = (Get-ChildItem "$Target\references\vi\").Count
        Write-Ok "  References VI: $count files"
        $refOk += $count
    } else { Write-Warn "  skills\vi\references\ không tìm thấy" }

    $src = Join-Path $SkillDir "skills\en\references"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\references\en\" -Recurse -Force
        $count = (Get-ChildItem "$Target\references\en\").Count
        Write-Ok "  References EN: $count files"
        $refOk += $count
    } else { Write-Warn "  skills\en\references\ không tìm thấy" }

    Save-Checkpoint 5
    Write-Ok "References: $refOk files"
}

# ─── STEP 6: Copy workflows + agents ───────────────────────
if ($LastStep -lt 6) {
    Write-Info "[6/7] Copy workflows & agents..."

    $src = Join-Path $SkillDir "workflows\vi"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\workflows\vi\" -Recurse -Force
        $count = (Get-ChildItem "$Target\workflows\vi\" -Filter "*.md").Count
        Write-Ok "  Workflows VI: $count files"
    }

    $src = Join-Path $SkillDir "workflows\en"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\workflows\en\" -Recurse -Force
        $count = (Get-ChildItem "$Target\workflows\en\" -Filter "*.md").Count
        Write-Ok "  Workflows EN: $count files"
    }

    $src = Join-Path $SkillDir "agents"
    if (Test-Path $src) {
        Copy-Item -Path "$src\*" -Destination "$Target\agents\" -Recurse -Force
        $count = (Get-ChildItem "$Target\agents\" -Filter "*.md").Count
        Write-Ok "  Agents: $count files"
    }

    Save-Checkpoint 6
    Write-Ok "Workflows & agents xong"
}

# ─── STEP 7: Copy CLAUDE.md + tạo .agents template ─────────
if ($LastStep -lt 7) {
    Write-Info "[7/7] Copy CLAUDE.md + tạo .agents template..."

    $src = Join-Path $SkillDir "CLAUDE.md"
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination "$Target\CLAUDE.md" -Force
        Write-Ok "  CLAUDE.md copied"
    }

    # FIX BUG #4 & #5: Tạo .agents template
    $pmcTemplate = @"
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

## Mục tiêu marketing hiện tại
- [VD: Tăng leads từ Meta Ads]

## Ngân sách marketing/tháng
- Ads: [VD: 30 triệu/tháng]

## Kênh đang dùng
- [ ] Facebook / Meta Ads
- [ ] TikTok / TikTok Ads
- [ ] Google Ads
- [ ] Zalo OA
- [ ] Khác: [...]
"@

    $pmcTemplate | Set-Content "$Target\.agents-template\product-marketing-context.md" -Encoding UTF8

    Save-Checkpoint 7
    Write-Ok "CLAUDE.md + .agents template xong"
}

# ─── Xóa checkpoint khi hoàn thành ─────────────────────────
if (Test-Path $CheckpointFile) { Remove-Item $CheckpointFile -Force }

# ─── Summary ────────────────────────────────────────────────
$totalSkills = (Get-ChildItem $Target -Recurse -Filter "SKILL.md").Count
$totalMd = (Get-ChildItem $Target -Recurse -Filter "*.md").Count

Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ Cài đặt hoàn thành!" -ForegroundColor Green
Write-Host "════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  📁 Vị trí:     $Target" -ForegroundColor Cyan
Write-Host "  🎯 Skills:     $totalSkills SKILL.md files"
Write-Host "  📄 Tổng files: $totalMd .md files"
Write-Host ""
Write-Host "Bước tiếp theo — Tạo context file cho project của bạn:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Copy template vào project root:" -ForegroundColor Cyan
Write-Host "     mkdir .agents"
Write-Host "     copy `"$Target\.agents-template\product-marketing-context.md`" .agents\"
Write-Host ""
Write-Host "  2. Chỉnh sửa file context với thông tin thực tế" -ForegroundColor Cyan
Write-Host ""
Write-Host "  3. Dùng trong Claude Code:" -ForegroundColor Cyan
Write-Host "     > Lập kế hoạch marketing cho [sản phẩm]"
Write-Host "     > /skill 05-copy-quang-cao"
Write-Host ""
Write-Host "  📖 Hướng dẫn đầy đủ: docs/getting-started.md" -ForegroundColor Cyan
Write-Host ""