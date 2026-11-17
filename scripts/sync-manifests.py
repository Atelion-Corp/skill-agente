#!/usr/bin/env python3
"""Keep Claude and Codex plugin manifests aligned with skills/*/SKILL.md."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SKILLS = sorted(
    f"./skills/{path.parent.name}"
    for path in (ROOT / "skills").glob("*/SKILL.md")
)


def update(path: Path) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    data["skills"] = SKILLS
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


for manifest in (
    ROOT / ".claude-plugin" / "plugin.json",
    ROOT / ".codex-plugin" / "plugin.json",
):
    update(manifest)

print(f"Synced {len(SKILLS)} skills in Claude and Codex manifests.")
