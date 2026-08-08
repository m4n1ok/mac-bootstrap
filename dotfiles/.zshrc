# Enable Powerlevel10k instant prompt. Keep this block at the top of ~/.zshrc.
# Initialization code that may require console input must go above this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Download Znap, if it's not there yet.
[[ -r ~/.zsh-plugins/zsh-znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.zsh-plugins/zsh-znap
source ~/.zsh-plugins/zsh-znap/znap.zsh  # Start Znap

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# SSH via 1Password agent (requires 1Password → Settings → Developer → SSH agent)
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Load prompt first for better performance
znap prompt romkatv/powerlevel10k

# Load lighter oh-my-zsh libraries
znap source ohmyzsh/ohmyzsh lib/{git,theme-and-appearance}
znap source ohmyzsh/ohmyzsh plugins/colored-man-pages

# g-plane/pnpm-shell-completion: workspace filters, deps, npm scripts (needs release binary)
# https://github.com/g-plane/pnpm-shell-completion
() {
  znap clone g-plane/pnpm-shell-completion || return 0
  local repo=~[g-plane/pnpm-shell-completion]
  [[ -d $repo ]] || return 0
  if [[ ! -x $repo/pnpm-shell-completion ]]; then
    (cd $repo && zsh ./zplug.zsh) || return 0
  fi
  [[ -x $repo/pnpm-shell-completion ]] || return 0
  path=($repo $path)
  znap source g-plane/pnpm-shell-completion
}

# Autocomplete configuration (optimized settings)
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' default-context ''
zstyle ':autocomplete:*' delay 0.1  # seconds (reduced for better responsiveness)

# Load heavier plugins last
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting

# Syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )

# User configuration
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# aliases
source ~/.aliases
