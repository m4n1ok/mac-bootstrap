#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

ensure_clt() {
  if xcode-select -p &>/dev/null; then
    echo "Command Line Tools already installed."
    return 0
  fi

  echo "Installing Command Line Tools (finish the GUI dialog)..."
  xcode-select --install 2>/dev/null || true

  echo "Waiting for Command Line Tools..."
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  echo "Command Line Tools ready."
}

ensure_homebrew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew already installed."
  else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    echo "brew not found after install" >&2
    exit 1
  fi
}

ensure_clt
ensure_homebrew

echo "Updating Homebrew..."
brew update

echo "Installing from Brewfile..."
brew bundle --file="$ROOT/Brewfile"

echo "Symlinking dotfiles..."
bash "$ROOT/symlink-dotfiles.sh"

mkdir -p "$HOME/Code/A17" "$HOME/Code/DecimalStudios"

touch "$HOME/.hushlogin"

echo "Applying macOS defaults..."
bash "$ROOT/settings.sh"

cat <<'EOF'

Bootstrap done.

Next (see SETUP.md):
  1. PHP Monitor → Setup Assistant (PHP / Composer / Valet)
  2. mise use -g node@lts
  3. bash install-skills.sh
  4. Open Claude Code once (plugins from linked settings.json)
  5. Import config/iterm-profile.json into iTerm2
  6. Import config/antonin.code-profile into Cursor
  7. ssh -T git@github.com  # confirm 1Password agent in a new terminal

EOF
