# Setup checklist

## Before clone (private repo)

1. Xcode Command Line Tools installed
2. Homebrew installed + `brew shellenv` on PATH
3. `brew install --cask 1password 1password-cli` (or run `preflight.sh`)
4. Sign into 1Password → **Settings → Developer → Use the SSH agent**
5. Create GitHub SSH key **in 1Password** (not `ssh-keygen` on disk)
6. Add public key to GitHub. Export the agent socket in this shell **first** — `.zshrc` isn't
   linked yet — then `ssh -T git@github.com` succeeds:
   `export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock`
7. `git clone git@github.com:m4n1ok/mac-bootstrap.git ~/Code/mac-bootstrap`
8. `cd ~/Code/mac-bootstrap && bash bootstrap.sh`

## After bootstrap

1. PHP Monitor → Setup Assistant (PHP / Composer / Valet)
2. `mise use -g node@lts` (pnpm via corepack or mise)
3. `bash install-skills.sh` — agent skills from `config/skills.txt` (`npx skills add … -g --all`)
4. Open Claude Code once so plugins/marketplaces from `~/.claude/settings.json` install
5. Import `config/iterm-profile.json` into iTerm2
6. Import `config/antonin.code-profile` into Cursor (and VS Code if you use it): **Profiles → Import Profile…**
7. Sign into Slack / etc. (1Password already done pre-clone)
8. Confirm agent in a new terminal: `echo $SSH_AUTH_SOCK` and `ssh -T git@github.com`
9. NTFS (only if needed): https://gist.github.com/bjorgvino/f24e5c079b92f921b765
