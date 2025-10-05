# =============================================================================
# ZSH INTERACTIVE SESSION CONFIGURATION
# =============================================================================
# This file is loaded for interactive Zsh sessions
# Environment variables and PATH are handled in .zprofile

# -----------------------------------------------------------------------------
# EXTERNAL INTEGRATIONS (Pre-setup)
# -----------------------------------------------------------------------------
# Amazon Q pre block - Keep at the top
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# -----------------------------------------------------------------------------
# ZSH COMPLETIONS & ENHANCEMENTS
# -----------------------------------------------------------------------------
# Homebrew-managed Zsh enhancements (PATH already set in .zprofile)
if type brew &>/dev/null; then
  # Completion system
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit && compinit
  
  # Auto-suggestions (fish-like command completion)
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  
  # Syntax highlighting (must be loaded after compinit)
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Completion configuration
zstyle ":completion:*:commands" rehash 1

# -----------------------------------------------------------------------------
# NAVIGATION & PRODUCTIVITY TOOLS  
# -----------------------------------------------------------------------------
# z - Smart directory jumping based on frequency
if [[ -f "`brew --prefix`/etc/profile.d/z.sh" ]]; then
  . `brew --prefix`/etc/profile.d/z.sh
fi

# -----------------------------------------------------------------------------
# SHELL ALIASES & SHORTCUTS
# -----------------------------------------------------------------------------
# Python - Use Python 3 by default (macOS compatibility)
alias python="python3"

# Node.js/Yarn development shortcuts
alias ys="yarn start"      # Quick project start
alias yd="yarn dev"        # Development mode

# Directory navigation shortcuts  
alias cdd="cd ~/dev"        # Jump to development directory
# Note: ls/ll/la aliases are defined in .zprofile (using exa)

# -----------------------------------------------------------------------------
# DOTFILES MANAGEMENT
# -----------------------------------------------------------------------------
# Custom dotfiles management commands
source "$HOME/.dotfiles/aliases/dotfiles.sh"

# -----------------------------------------------------------------------------
# LEGACY/DEPRECATED INTEGRATIONS
# -----------------------------------------------------------------------------
# Fig integration (keeping for backward compatibility)
# TODO: Remove if no longer needed
[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# -----------------------------------------------------------------------------
# EXTERNAL INTEGRATIONS (Post-setup)
# -----------------------------------------------------------------------------
# Amazon Q post block - Keep at the bottom
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
