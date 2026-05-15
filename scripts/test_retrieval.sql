-- ============================================================
-- CMO AI — Test Retrieval Queries
-- Paste từng query vào Supabase SQL Editor để kiểm tra
-- ============================================================


-- ── Test 1: Xem tất cả skills đã ingest ──────────────────────
SELECT skill_id, name, agent, version, category
FROM skills
ORDER BY skill_id;


-- ── Test 2: Xem tất cả sections của skill 00 ─────────────────
SELECT
  section_id,
  section_type,
  priority,
  modes,
  industries,
  tags,
  length(content) AS content_chars
FROM skill_sections
WHERE skill_id = '00-ke-hoach-mkt'
ORDER BY priority, section_id;


-- ── Test 3: QUICK MODE — spa industry ────────────────────────
-- Mô phỏng: n8n query khi user gửi request, mode=quick, industry=spa
-- Kỳ vọng: chỉ trả về sections priority 1 + 2 (không có template_content_plan, channel_budget, risk, timeline)

SELECT
  section_id,
  section_type,
  priority,
  modes,
  content
FROM skill_sections
WHERE skill_id = '00-ke-hoach-mkt'
  AND (
    priority <= 2                                                -- always + standard
    OR (
      priority = 3
      AND ('all' = ANY(modes) OR 'quick' = ANY(modes))          -- mode match
      AND ('all' = ANY(industries) OR 'spa' = ANY(industries))  -- industry match
    )
  )
ORDER BY priority, section_id;


-- ── Test 4: FULL MODE — spa industry ─────────────────────────
-- Kỳ vọng: trả về TẤT CẢ sections (kể cả priority 3)

SELECT
  section_id,
  section_type,
  priority,
  modes,
  length(content) AS content_chars
FROM skill_sections
WHERE skill_id = '00-ke-hoach-mkt'
  AND (
    priority <= 2
    OR (
      priority = 3
      AND ('all' = ANY(modes) OR 'full' = ANY(modes))
      AND ('all' = ANY(industries) OR 'spa' = ANY(industries))
    )
  )
ORDER BY priority, section_id;


-- ── Test 5: So sánh token usage ──────────────────────────────
-- Quick vs Full: tiết kiệm bao nhiêu chars (≈ tokens)?

WITH
  quick_load AS (
    SELECT SUM(length(content)) AS total_chars, COUNT(*) AS section_count
    FROM skill_sections
    WHERE skill_id = '00-ke-hoach-mkt'
      AND (
        priority <= 2
        OR (priority = 3 AND 'quick' = ANY(modes) AND 'all' = ANY(industries))
      )
  ),
  full_load AS (
    SELECT SUM(length(content)) AS total_chars, COUNT(*) AS section_count
    FROM skill_sections
    WHERE skill_id = '00-ke-hoach-mkt'
  )
SELECT
  quick_load.section_count   AS quick_sections,
  full_load.section_count    AS full_sections,
  quick_load.total_chars     AS quick_chars,
  full_load.total_chars      AS full_chars,
  full_load.total_chars - quick_load.total_chars AS saved_chars,
  ROUND(
    (full_load.total_chars - quick_load.total_chars)::numeric
    / full_load.total_chars * 100, 1
  ) AS saved_pct
FROM quick_load, full_load;
