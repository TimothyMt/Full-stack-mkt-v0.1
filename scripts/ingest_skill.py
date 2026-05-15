"""
CMO AI — Skill Ingestion Script
Đọc SKILL.md có #SECTION markers → parse → lưu vào Supabase

Cách chạy:
  python scripts/ingest_skill.py skills/vi/00-ke-hoach-mkt/SKILL.md
  python scripts/ingest_skill.py --all          (ingest tất cả skills trong skills/vi/)
"""

import re
import sys
import os
import yaml
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client, Client

# ── Load env ──────────────────────────────────────────────────────────────────
load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_KEY")   # dùng service_role key (không phải anon)

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Thiếu SUPABASE_URL hoặc SUPABASE_SERVICE_KEY trong file .env")
    sys.exit(1)

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


# ── Parser ────────────────────────────────────────────────────────────────────

def parse_skill_file(file_path: str) -> tuple[dict, list[dict]]:
    """
    Đọc SKILL.md → trả về (yaml_data, sections[])

    Section format trong file:
      <!-- #SECTION
      id: context_intake
      type: context_intake
      priority: 1
      modes: [all]
      industries: [all]
      tags: [session_context, mode]
      -->
      ...nội dung...
      <!-- #/SECTION -->
    """
    with open(file_path, "r", encoding="utf-8") as f:
        raw = f.read()

    # ── Parse YAML header ──
    yaml_match = re.match(r"^---\n(.*?)\n---\n", raw, re.DOTALL)
    if not yaml_match:
        raise ValueError(f"Không tìm thấy YAML header trong {file_path}")

    yaml_data = yaml.safe_load(yaml_match.group(1))
    body = raw[yaml_match.end():]

    # ── Parse #SECTION blocks ──
    section_pattern = re.compile(
        r"<!-- #SECTION\n(.*?)-->\n(.*?)<!-- #/SECTION -->",
        re.DOTALL
    )

    sections = []
    for match in section_pattern.finditer(body):
        meta_raw = match.group(1).strip()
        content  = match.group(2).strip()

        # Parse metadata lines "key: value"
        meta = {}
        for line in meta_raw.split("\n"):
            line = line.strip()
            if not line or ":" not in line:
                continue
            key, _, val = line.partition(":")
            key = key.strip()
            val = val.strip()

            # Parse array: [all] hoặc [spa, clinic] hoặc [full]
            if val.startswith("[") and val.endswith("]"):
                inner = val[1:-1]
                val = [v.strip() for v in inner.split(",") if v.strip()]
            else:
                # Parse int
                try:
                    val = int(val)
                except ValueError:
                    pass

            meta[key] = val

        if not meta.get("id"):
            print(f"  ⚠️  Section thiếu id — bỏ qua: {content[:40]}...")
            continue

        sections.append({
            "section_id":   meta["id"],
            "section_type": meta.get("type", "logic"),
            "priority":     meta.get("priority", 2),
            "modes":        meta.get("modes", ["all"]),
            "industries":   meta.get("industries", ["all"]),
            "tags":         meta.get("tags", []),
            "content":      content,
        })

    return yaml_data, sections


# ── Ingest ─────────────────────────────────────────────────────────────────────

def ingest_skill(file_path: str) -> None:
    print(f"\n📄 Đang ingest: {file_path}")

    yaml_data, sections = parse_skill_file(file_path)
    skill_id = yaml_data.get("skill_id")

    if not skill_id:
        print(f"  ❌ YAML thiếu skill_id — bỏ qua file này")
        return

    print(f"  skill_id : {skill_id}")
    print(f"  sections : {len(sections)} tìm thấy")

    # ── Upsert skill row ──
    skill_row = {
        "skill_id":            skill_id,
        "name":                yaml_data.get("name", ""),
        "description":         yaml_data.get("description", ""),
        "agent":               yaml_data.get("agent", ""),
        "version":             (yaml_data.get("metadata") or {}).get("version", ""),
        "category":            (yaml_data.get("metadata") or {}).get("category", ""),
        "context_requirements": yaml_data.get("context_requirements") or {},
    }

    res = supabase.table("skills").upsert(skill_row, on_conflict="skill_id").execute()
    print(f"  ✅ skills table — upserted")

    # ── Upsert từng section ──
    for sec in sections:
        row = {"skill_id": skill_id, **sec}
        supabase.table("skill_sections").upsert(
            row, on_conflict="skill_id,section_id"
        ).execute()
        print(f"  ✅ section [{sec['section_id']}]  "
              f"priority={sec['priority']}  "
              f"modes={sec['modes']}  "
              f"({len(sec['content'])} chars)")

    print(f"\n  🎉 Xong: {skill_id} — {len(sections)} sections ingested")


# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    args = sys.argv[1:]

    if not args:
        print("Cách dùng:")
        print("  python scripts/ingest_skill.py skills/vi/00-ke-hoach-mkt/SKILL.md")
        print("  python scripts/ingest_skill.py --all")
        sys.exit(0)

    if args[0] == "--all":
        # Ingest tất cả SKILL.md trong skills/vi/
        root = Path("skills/vi")
        skill_files = list(root.glob("*/SKILL.md"))
        print(f"Tìm thấy {len(skill_files)} skill files")
        for sf in sorted(skill_files):
            try:
                ingest_skill(str(sf))
            except Exception as e:
                print(f"  ❌ Lỗi: {e}")
    else:
        ingest_skill(args[0])


if __name__ == "__main__":
    main()
