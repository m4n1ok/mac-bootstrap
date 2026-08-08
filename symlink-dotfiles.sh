#!/usr/bin/env bash
# Symlink this repo's dotfiles/ into $HOME.
# Safe: only replaces matching/outdated symlinks; never clobbers real files.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
dotfiles="$ROOT/dotfiles"

if [[ ! -d "$dotfiles" ]]; then
  echo "$dotfiles does not exist" >&2
  exit 1
fi

echo "Symlinking dotfiles from $dotfiles"

link() {
  local from="$1" to="$2"
  if [[ -L "$to" ]]; then
    local current
    current="$(readlink "$to")"
    if [[ "$current" == "$from" ]]; then
      echo "OK  $to"
      return 0
    fi
    echo "Updating symlink $to ($current → $from)"
    rm -f "$to"
  elif [[ -e "$to" ]]; then
    echo "SKIP $to (exists and is not a symlink to our dotfiles — move it aside manually)" >&2
    return 1
  fi
  echo "Linking '$from' → '$to'"
  ln -s "$from" "$to"
}

# Only top-level files in dotfiles/
shopt -s nullglob
for location in "$dotfiles"/.*; do
  base="$(basename "$location")"
  [[ "$base" == "." || "$base" == ".." ]] && continue
  [[ -f "$location" ]] || continue
  link "$location" "$HOME/$base" || true
done
