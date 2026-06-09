# ============================================================================
# PATH Configuration
# ============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

# ============================================================================
# PostgreSQL
# ============================================================================
export LDFLAGS="-L/opt/homebrew/opt/postgresql@16/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@16/include"
# ============================================================================
# Shell Tools
# ============================================================================
eval "$(zoxide init zsh)"      # Smart cd replacement
eval "$(direnv hook zsh)"      # Environment management
source <(fzf --zsh)            # Fuzzy finder

# ============================================================================
# History Configuration
# ============================================================================
# Substring search with arrow keys (filters by what you've already typed)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# ============================================================================
# Starship Prompt
# ============================================================================
eval "$(starship init zsh)"

# ============================================================================
# Aliases
# ============================================================================
# Modern replacements
alias vim=nvim
alias ls="lsd"
alias cat="bat"

# ls shortcuts
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Rust
alias cr="cargo run"
alias cc="cargo check"

# Oh My Zsh git aliases
alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gpl='git pull'
alias gst='git status'
alias gss='git status -s'
alias gpo='git push origin'
alias gpu='git push upstream'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias gcl='git clone'
alias gpsup='git push --set-upstream origin $(git_current_branch)'


eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# add Pulumi to the PATH
export PATH=$PATH:/Users/adi/.pulumi/bin
