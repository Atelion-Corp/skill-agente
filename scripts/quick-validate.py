#!/usr/bin/env python3
"""Validate the portable SKILL.md contract used by Claude and Codex."""

from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml


ALLOWED = {"name", "description", "license", "allowed-tools", "metadata"}
NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


if len(sys.argv) != 2:
    fail("usage: quick-validate.py PATH_TO_SKILL")

folder = Path(sys.argv[1])
path = folder / "SKILL.md"
if not path.is_file():
    fail(f"missing {path}")

text = path.read_text(encoding="utf-8")
match = re.match(r"^---\n(.*?)\n---(?:\n|$)", text, re.DOTALL)
if not match:
    fail(f"{path}: missing YAML frontmatter")

data = yaml.safe_load(match.group(1))
if not isinstance(data, dict):
    fail(f"{path}: frontmatter must be a mapping")
unknown = sorted(set(data) - ALLOWED)
if unknown:
    fail(f"{path}: unsupported frontmatter keys: {', '.join(unknown)}")
name = data.get("name")
description = data.get("description")
if not isinstance(name, str) or not NAME.fullmatch(name):
    fail(f"{path}: invalid skill name")
if name != folder.name:
    fail(f"{path}: name must match folder {folder.name}")
if not isinstance(description, str) or not description.strip():
    fail(f"{path}: description is required")
if len(description) > 1024 or "<" in description or ">" in description:
    fail(f"{path}: description is invalid")
if "PLACEHOLDER_TEXT" in text or "REPLACE_ME" in text:
    fail(f"{path}: unfinished scaffold marker")

print(f"OK: {name}")
