# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
PROMPT="%F{034}%h%f:%F{020}%~%f"$'\n'"%# "

typeset -U path PATH
path=(
  /opt/homebrew/bin(N-/)
  /opt/homebrew/sbin(N-/)
  /usr/bin
  /usr/sbin
  /bin
  /sbin
  /usr/local/bin(N-/)
  /usr/local/sbin(N-/)
  /Library/Apple/usr/bin
)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit && compinit
fi

source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ":completion:*:commands" rehash 1
# z
. `brew --prefix`/etc/profile.d/z.sh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

git_prompt() {
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
    PROMPT="%F{034}%h%f:%F{020}%~%f $(git_super_status)"$'\n'"%# "
  else
    PROMPT="%F{034}%h%f:%F{020}%~%f "$'\n'"%# "
  fi
}

add_newline() {
  if [[ -z $PS1_NEWLINE_LOGIN ]]; then
    PS1_NEWLINE_LOGIN=true
  else
    printf '\n'
  fi
}


precmd() {
  git_prompt
  add_newline
}

alias python="python3"
alias ys="yarn start"
alias yd="yarn dev"
alias cdd="cd ~/dev"

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH="/Users/t-kimura/go/bin:$PATH"

export PATH=$HOME/development/flutter/bin:$PATH

[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
