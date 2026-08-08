#!/usr/bin/env bash
# Preflight for a private mac-bootstrap on a blank Mac.
# Installs CLT + Homebrew + 1Password so you can use the 1Password SSH agent
# to clone this private repo. Then: create SSH key in 1Password → GitHub → clone → bootstrap.sh
set -euo pipefail

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

echo "Installing 1Password..."
brew install --cask 1password 1password-cli

open -a "1Password" 2>/dev/null || true

cat <<'EOF'

Preflight done.

Next:
  1. Sign into 1Password
  2. Settings → Developer → enable SSH agent
  3. Create an SSH key in 1Password (do not ssh-keygen to disk)
  4. Add the public key to GitHub
  5. ssh -T git@github.com
  6. mkdir -p ~/Code && git clone git@github.com:m4n1ok/mac-bootstrap.git ~/Code/mac-bootstrap
  7. cd ~/Code/mac-bootstrap && bash bootstrap.sh

Tip: until dotfiles are linked, export in this shell:
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

EOF
