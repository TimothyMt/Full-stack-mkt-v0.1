-- ============================================================
-- CMO AI — Skill Storage Schema
-- Paste toàn bộ file này vào Supabase SQL Editor và chạy
-- ============================================================

-- Bảng 1: Skills (1 row per skill)
CREATE TABLE IF NOT EXISTS skills (
  id              UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  skill_id        TEXT    UNIQUE NOT NULL,   -- "00-ke-hoach-mkt"
  name            TEXT    NOT NULL,          -- "Ke Hoach Fullstack Marketing"
  description     TEXT,                      -- dùng để embed sau này
  agent           TEXT,                      -- "mkt-strategist"
  version         TEXT,                      -- "2.1.0"
  category        TEXT,                      -- "strategy"
  context_requirements JSONB DEFAULT '{}',   -- {required:[], optional:[...]}
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Bảng 2: Skill Sections (nhiều rows per skill)
CREATE TABLE IF NOT EXISTS skill_sections (
  id              UUID    DEFAULT gen_random_uuid() PRIMARY KEY,
  skill_id        TEXT    NOT NULL REFERENCES skills(skill_id) ON DELETE CASCADE,
  section_id      TEXT    NOT NULL,          -- "template_strategy"
  section_type    TEXT    NOT NULL,          -- "template" | "logic" | "reference" | ...
  content         TEXT    NOT NULL,          -- nội dung markdown thực sự
  priority        INTEGER DEFAULT 2,         -- 1=always | 2=standard | 3=conditional
  modes           TEXT[]  DEFAULT ARRAY['all'],      -- ['all'] | ['quick'] | ['full']
  industries      TEXT[]  DEFAULT ARRAY['all'],      -- ['all'] | ['spa','clinic']
  tags            TEXT[]  DEFAULT ARRAY[]::TEXT[],   -- ['budget','allocation']
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(skill_id, section_id)
);

-- Index để query nhanh
CREATE INDEX IF NOT EXISTS idx_skill_sections_skill_id  ON skill_sections(skill_id);
CREATE INDEX IF NOT EXISTS idx_skill_sections_priority  ON skill_sections(priority);
CREATE INDEX IF NOT EXISTS idx_skill_sections_modes     ON skill_sections USING GIN(modes);
CREATE INDEX IF NOT EXISTS idx_skill_sections_industries ON skill_sections USING GIN(industries);

-- Trigger tự update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_skills_updated_at
  BEFORE UPDATE ON skills
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_skill_sections_updated_at
  BEFORE UPDATE ON skill_sections
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
