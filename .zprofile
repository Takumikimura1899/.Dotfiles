# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

# Homebrew environment setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# Volta (Node.js version manager) setup
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Development tools PATH
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/development/flutter/bin:$PATH"

# Starship prompt initialization
eval "$(starship init zsh)"

# Useful aliases
alias ls='eza --time-style=long-iso -g'
alias ll='ls --git --time-style=long-iso -gl'
alias la='ls --git --time-style=long-iso -agl'
alias l1='eza -1'

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh"
