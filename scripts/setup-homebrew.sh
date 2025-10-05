#!/bin/bash

# Homebrew and packages setup script

set -e

DOTFILES_DIR="$HOME/.dotfiles"
BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

echo "🍺 Homebrew Setup Script"
echo "========================="

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "📦 Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew is already installed"
fi

# Update Homebrew
echo "🔄 Updating Homebrew..."
brew update

# Check if Brewfile exists
if [[ ! -f "$BREWFILE_PATH" ]]; then
    echo "❌ Brewfile not found at $BREWFILE_PATH"
    echo "Please run 'brew bundle dump' to create one first."
    exit 1
fi

echo "📋 Found Brewfile with the following categories:"
echo "   - $(grep -c '^brew ' "$BREWFILE_PATH") formulae"
echo "   - $(grep -c '^cask ' "$BREWFILE_PATH") casks"  
echo "   - $(grep -c '^vscode ' "$BREWFILE_PATH") VS Code extensions"
echo "   - $(grep -c '^tap ' "$BREWFILE_PATH") taps"

# Confirm installation
echo ""
read -p "🤔 Do you want to install all packages from Brewfile? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Installing packages from Brewfile..."
    echo "This may take a while..."
    
    cd "$DOTFILES_DIR"
    brew bundle --verbose
    
    echo ""
    echo "✅ Package installation complete!"
    echo ""
    echo "📝 Summary:"
    echo "   - All formulae, casks, and VS Code extensions installed"
    echo "   - Run 'brew bundle cleanup' to remove packages not in Brewfile"
    echo "   - Run 'brew bundle check' to verify installation"
else
    echo "❌ Installation cancelled"
    echo ""
    echo "💡 You can install packages manually:"
    echo "   cd $DOTFILES_DIR && brew bundle"
fi

echo ""
echo "🔗 Useful commands:"
echo "   brew bundle check          # Check if all packages are installed"
echo "   brew bundle cleanup --force # Remove packages not in Brewfile"  
echo "   brew bundle dump --force   # Update Brewfile with current packages"
