# =============================================================================
# ZSH INTERACTIVE SESSION CONFIGURATION
# =============================================================================
# This file is loaded for interactive Zsh sessions
# Environment variables and PATH are handled in .zprofile

# -----------------------------------------------------------------------------
# EXTERNAL INTEGRATIONS (Pre-setup)
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
# zoxide
eval "$(zoxide init zsh)"
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

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
# STARSHIP PROMPT
# -----------------------------------------------------------------------------
# Set Starship config file location
export STARSHIP_CONFIG="$HOME/.dotfiles/config/starship.toml"

# Initialize Starship prompt
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# DOTFILES MANAGEMENT
# -----------------------------------------------------------------------------
# Custom dotfiles management commands
source "$HOME/.dotfiles/aliases/dotfiles.sh"

# -----------------------------------------------------------------------------
# EXTERNAL INTEGRATIONS (Post-setup)
# -----------------------------------------------------------------------------
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Added by Antigravity
export PATH="/Users/t-kimura/.antigravity/antigravity/bin:$PATH"
