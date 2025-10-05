# Dotfiles management aliases
# Source this file in your shell configuration

# メインコマンドのエイリアス
alias dots="$HOME/.dotfiles/scripts/dotfiles-sync.sh"
alias dots-status="$HOME/.dotfiles/scripts/dotfiles-sync.sh status"
alias dots-update="$HOME/.dotfiles/scripts/dotfiles-sync.sh update --interactive"
alias dots-commit="$HOME/.dotfiles/scripts/dotfiles-sync.sh commit"

# 頻繁に使用するコマンド
alias dots-check="dots-status"
alias dots-sync="dots-update"

# 便利な組み合わせコマンド
dots-quick() {
    echo "🔄 Quick dotfiles sync workflow"
    $HOME/.dotfiles/scripts/dotfiles-sync.sh status
    echo ""
    read -p "🤔 変更をdotfilesに反映しますか？ (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $HOME/.dotfiles/scripts/dotfiles-sync.sh update --interactive
        $HOME/.dotfiles/scripts/dotfiles-sync.sh commit
    fi
}

# ヘルプ表示
alias dots-help="dots help && echo '' && echo '便利なエイリアス:' && echo '  dots-status   設定の差分確認' && echo '  dots-update   対話的更新' && echo '  dots-commit   変更をコミット' && echo '  dots-quick    ワンステップ同期'"
