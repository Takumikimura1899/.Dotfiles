#!/bin/bash

# SSH設定のセットアップスクリプト

SSH_DIR="$HOME/.ssh"
DOTFILES_SSH_DIR="$HOME/.dotfiles/ssh"

echo "Setting up SSH configuration..."

# .ssh ディレクトリが存在することを確認
if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# 既存のconfigファイルをバックアップ
if [ -f "$SSH_DIR/config" ]; then
    echo "Backing up existing SSH config..."
    cp "$SSH_DIR/config" "$SSH_DIR/config.backup.$(date +%Y%m%d_%H%M%S)"
fi

# シンボリックリンクを作成
echo "Creating symlink for SSH config..."
ln -sf "$DOTFILES_SSH_DIR/config" "$SSH_DIR/config"

# 適切なパーミッションを設定
chmod 600 "$SSH_DIR/config"
chmod 700 "$SSH_DIR"

echo "SSH configuration setup complete!"
echo ""
echo "Note: The SSH config includes security-focused defaults."
echo "Edit ~/.dotfiles/ssh/config to add your specific host configurations."
echo ""
echo "IMPORTANT: Private keys (*.pem, id_rsa, etc.) are NOT managed by dotfiles for security."
echo "Manage them separately and reference them in the config file."
