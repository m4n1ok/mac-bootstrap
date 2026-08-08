# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Composer
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(mise activate zsh --shims)"

#Yarn
export PATH="$HOME/.yarn/bin:$PATH"

#Dbngin
#export PATH="/Users/Shared/DBngin/postgresql/17.0/bin:$PATH"

# Add all DBngin database bin directories to PATH (cached)
_dbngin_root=/Users/Shared/DBngin
_dbngin_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dbngin-path"
if [[ -d $_dbngin_root ]]; then
  if [[ ! -f $_dbngin_cache || $_dbngin_root -nt $_dbngin_cache ]]; then
    mkdir -p "${_dbngin_cache:h}"
    find "$_dbngin_root" -name bin -type d 2>/dev/null >| "$_dbngin_cache"
  fi
  while read -r db_bin; do
    [[ -n $db_bin ]] && PATH="$db_bin:$PATH"
  done < "$_dbngin_cache"
fi
unset _dbngin_root _dbngin_cache

#Phpmon
export PATH="$HOME/.config/phpmon/bin:$PATH"

# Added by OrbStack: command-line tools and integration
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
