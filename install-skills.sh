#!/usr/bin/env bash
# Install agent skills globally from config/skills.txt (needs node/npx).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
list="$ROOT/config/skills.txt"

if ! command -v npx &>/dev/null; then
  echo "npx not found — run: mise use -g node@lts" >&2
  exit 1
fi

if [[ ! -f "$list" ]]; then
  echo "$list missing" >&2
  exit 1
fi

echo "Installing skills from $list"
while IFS= read -r pkg || [[ -n "$pkg" ]]; do
  pkg="${pkg%%#*}"
  pkg="$(printf '%s' "$pkg" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [[ -z "$pkg" ]] && continue
  echo "→ npx skills add $pkg -g --all"
  npx --yes skills add "$pkg" -g --all
done < "$list"

echo "Skills installed. Check with: npx skills list -g"
