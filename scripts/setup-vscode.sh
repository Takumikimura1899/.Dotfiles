#!/bin/bash

# VS Code設定のシンボリックリンク設定スクリプト

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
DOTFILES_VSCODE_DIR="$HOME/.dotfiles/vscode"

echo "Setting up VS Code configuration symlinks..."

# バックアップディレクトリを作成
mkdir -p "$VSCODE_USER_DIR.backup"

# 既存の設定をバックアップ
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
    mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR.backup/"
fi

if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
    mv "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR.backup/"
fi

if [ -d "$VSCODE_USER_DIR/snippets" ]; then
    mv "$VSCODE_USER_DIR/snippets" "$VSCODE_USER_DIR.backup/"
fi

# シンボリックリンクを作成
ln -s "$DOTFILES_VSCODE_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -s "$DOTFILES_VSCODE_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
ln -s "$DOTFILES_VSCODE_DIR/snippets" "$VSCODE_USER_DIR/snippets"

echo "VS Code configuration setup complete!"
echo ""
echo "Note: For mcp.json, copy the template and set your FIGMA_API_KEY:"
echo "cp $DOTFILES_VSCODE_DIR/mcp.json.template $VSCODE_USER_DIR/mcp.json"
echo "Then edit mcp.json and replace \${FIGMA_API_KEY} with your actual API key"
