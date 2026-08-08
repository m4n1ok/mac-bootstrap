mac-bootstrap
=============

Personal **private** bootstrap for a new Mac (Apple Silicon).

SSH keys live in **1Password** (agent), not as files under `~/.ssh`.

## New Mac (private repo)

### 1. Preflight — CLT, Homebrew, 1Password

```bash
# The Homebrew installer pulls in Command Line Tools and asks for your password.
# Finish the CLT GUI if macOS prompts you.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install --cask 1password 1password-cli
open -a "1Password"
```

Use `eval` as written — do **not** append `shellenv` to `~/.zprofile` the way the installer
suggests. That creates a real `~/.zprofile`, and step 3 will then refuse to link this repo's
(it never clobbers real files), silently costing you mise / Composer / DBngin on PATH.

Or, once this repo exists on another machine, copy `preflight.sh` over and run it.

### 2. SSH via 1Password

1. Sign into 1Password
2. **Settings → Developer → Use the SSH agent** (and CLI integration if you want)
3. Create an SSH key **in 1Password** (New Item → SSH Key) — do **not** `ssh-keygen` to disk for GitHub
4. Copy the public key → GitHub → Settings → SSH keys
5. Point this shell at the 1Password agent — **required before the smoke test**, since
   `.zshrc` (which sets this permanently) isn't linked until step 3:

   ```bash
   export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
   ```

6. Smoke-test: `ssh -T git@github.com` → "successfully authenticated"

### 3. Clone + bootstrap

```bash
mkdir -p ~/Code && cd ~/Code
git clone git@github.com:m4n1ok/mac-bootstrap.git
cd mac-bootstrap
bash bootstrap.sh   # prompts for computer name, then for sudo
# or: COMPUTER_NAME="Antonin MBA" bash bootstrap.sh
```

Not unattended: it prompts for the computer name, then `settings.sh` needs **sudo** to set the
hostname. Keep `~/Code/mac-bootstrap` where it is — your dotfiles are symlinked out of it, so
moving or deleting the directory breaks every one of them.

`brew bundle` will see 1Password already installed and skip/reaffirm it.

**Do not** use `curl | bash` against a private repo — it can’t auth.

## What bootstrap does

1. Ensures Command Line Tools (waits for GUI if needed)
2. Homebrew + `brew bundle` (`Brewfile`)
3. Symlinks `dotfiles/` → `$HOME`
4. Applies `settings.sh` (computer name prompt)

**Not** via brew: PHP / Composer / Valet — PHP Monitor Setup Assistant.

## After bootstrap

See [`SETUP.md`](SETUP.md) (iTerm + Cursor profile import, PHP Monitor, mise, etc.).

## Layout

```
preflight.sh          # CLT + brew + 1Password (before private clone)
Brewfile
bootstrap.sh
settings.sh
symlink-dotfiles.sh
dotfiles/
config/
SETUP.md
```

## Customize

- `Brewfile` — packages
- `COMPUTER_NAME` — skip name prompt
- `dotfiles/` — shell / git
