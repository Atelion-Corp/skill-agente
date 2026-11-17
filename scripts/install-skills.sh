#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [--dest DIRECTORY] [--force] [skill ...]" >&2
  exit 2
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CODEX_HOME:-$HOME/.codex}/skills"
force=0
skills=()

while (($#)); do
  case "$1" in
    --dest) (($# >= 2)) || usage; dest="$2"; shift 2 ;;
    --force) force=1; shift ;;
    -h|--help) usage ;;
    --*) usage ;;
    *) skills+=("$1"); shift ;;
  esac
done

if ((${#skills[@]} == 0)); then
  while IFS= read -r path; do skills+=("$(basename "$path")"); done \
    < <(find "$repo_root/skills" -mindepth 1 -maxdepth 1 -type d | sort)
fi

mkdir -p "$dest"
installed=0
for skill in "${skills[@]}"; do
  [[ "$skill" =~ ^[a-z0-9-]+$ ]] || { echo "Invalid skill name: $skill" >&2; exit 1; }
  source_dir="$repo_root/skills/$skill"
  target_dir="$dest/$skill"
  [[ -f "$source_dir/SKILL.md" ]] || { echo "Unknown skill: $skill" >&2; exit 1; }
  if [[ -e "$target_dir" && $force -ne 1 ]]; then
    echo "Already exists (use --force): $target_dir" >&2
    exit 1
  fi
  if [[ -e "$target_dir" ]]; then
    backup="$target_dir.backup.$(date -u +%Y%m%dT%H%M%SZ)"
    mv -- "$target_dir" "$backup"
    echo "Backup: $backup"
  fi
  cp -R -- "$source_dir" "$target_dir"
  installed=$((installed + 1))
done

echo "Installed $installed skill(s) in $dest"
