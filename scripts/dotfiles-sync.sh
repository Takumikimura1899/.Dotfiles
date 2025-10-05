#!/bin/bash

# Dotfiles Sync Management Script
# 選択的な設定同期・更新管理

set -e

DOTFILES_DIR="$HOME/.dotfiles"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ヘルプ表示
show_help() {
    echo "🔧 Dotfiles Sync Management"
    echo "=========================="
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  status     現在の設定とdotfilesの差分を確認"
    echo "  update     変更された設定をdotfilesに反映"
    echo "  sync       dotfilesから現在の設定に反映"
    echo "  backup     現在の設定をバックアップ"
    echo "  commit     変更をGitにコミット"
    echo "  help       このヘルプを表示"
    echo ""
    echo "Examples:"
    echo "  $0 status                    # 差分確認"
    echo "  $0 update --interactive      # 対話的更新"
    echo "  $0 sync vscode              # VS Code設定のみ同期"
}

# 差分確認
check_status() {
    echo -e "${BLUE}📊 設定差分確認中...${NC}"
    echo ""
    
    local has_changes=false
    
    # Zsh設定の差分
    echo -e "${YELLOW}🐚 シェル設定:${NC}"
    if ! diff -q "$HOME/.zprofile" "$DOTFILES_DIR/.zprofile" >/dev/null 2>&1; then
        echo "  ⚠️  .zprofile に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} .zprofile 同期済み"
    fi
    
    if ! diff -q "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc" >/dev/null 2>&1; then
        echo "  ⚠️  .zshrc に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} .zshrc 同期済み"
    fi
    
    # Git設定の差分
    echo -e "${YELLOW}📋 Git設定:${NC}"
    if ! diff -q "$HOME/.gitconfig" "$DOTFILES_DIR/.gitconfig" >/dev/null 2>&1; then
        echo "  ⚠️  .gitconfig に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} .gitconfig 同期済み"
    fi
    
    # VS Code設定の差分
    echo -e "${YELLOW}💻 VS Code設定:${NC}"
    if ! diff -q "$HOME/Library/Application Support/Code/User/settings.json" "$DOTFILES_DIR/vscode/settings.json" >/dev/null 2>&1; then
        echo "  ⚠️  settings.json に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} settings.json 同期済み"
    fi
    
    if ! diff -q "$HOME/Library/Application Support/Code/User/keybindings.json" "$DOTFILES_DIR/vscode/keybindings.json" >/dev/null 2>&1; then
        echo "  ⚠️  keybindings.json に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} keybindings.json 同期済み"
    fi
    
    # SSH設定の差分
    echo -e "${YELLOW}🔐 SSH設定:${NC}"
    if ! diff -q "$HOME/.ssh/config" "$DOTFILES_DIR/ssh/config" >/dev/null 2>&1; then
        echo "  ⚠️  ssh/config に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} ssh/config 同期済み"
    fi
    
    # Starship設定の差分
    echo -e "${YELLOW}🚀 Starship設定:${NC}"
    if ! diff -q "$HOME/.config/starship.toml" "$DOTFILES_DIR/config/starship.toml" >/dev/null 2>&1; then
        echo "  ⚠️  starship.toml に差分あり"
        has_changes=true
    else
        echo -e "  ${GREEN}✓${NC} starship.toml 同期済み"
    fi
    
    # Homebrewパッケージの差分
    echo -e "${YELLOW}🍺 Homebrew パッケージ:${NC}"
    cd "$DOTFILES_DIR"
    if brew bundle check >/dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} 全パッケージインストール済み"
    else
        echo "  ⚠️  未インストールのパッケージあり"
        has_changes=true
    fi
    
    echo ""
    if [ "$has_changes" = true ]; then
        echo -e "${YELLOW}📝 変更が検出されました。${NC}"
        echo "  詳細確認: $0 status --detailed"
        echo "  更新実行: $0 update"
    else
        echo -e "${GREEN}🎉 全ての設定が同期されています！${NC}"
    fi
}

# 詳細な差分表示
show_detailed_diff() {
    echo -e "${BLUE}📊 詳細な差分表示${NC}"
    echo ""
    
    local files=(
        "シェル:.zprofile:$HOME/.zprofile:$DOTFILES_DIR/.zprofile"
        "シェル:.zshrc:$HOME/.zshrc:$DOTFILES_DIR/.zshrc"
        "Git:.gitconfig:$HOME/.gitconfig:$DOTFILES_DIR/.gitconfig"
        "VS Code:settings.json:$HOME/Library/Application Support/Code/User/settings.json:$DOTFILES_DIR/vscode/settings.json"
        "SSH:config:$HOME/.ssh/config:$DOTFILES_DIR/ssh/config"
        "Starship:starship.toml:$HOME/.config/starship.toml:$DOTFILES_DIR/config/starship.toml"
    )
    
    for file_info in "${files[@]}"; do
        IFS=':' read -r category name current_file dotfiles_file <<< "$file_info"
        
        if ! diff -q "$current_file" "$dotfiles_file" >/dev/null 2>&1; then
            echo -e "${YELLOW}📄 $category - $name${NC}"
            echo "----------------------------------------"
            diff -u "$dotfiles_file" "$current_file" | head -20
            echo ""
        fi
    done
}

# 設定更新（dotfilesに反映）
update_dotfiles() {
    local interactive=${1:-false}
    
    echo -e "${BLUE}🔄 Dotfiles更新中...${NC}"
    echo ""
    
    local updated_files=()
    
    # 各設定ファイルをチェックして更新
    if ! diff -q "$HOME/.zprofile" "$DOTFILES_DIR/.zprofile" >/dev/null 2>&1; then
        if [ "$interactive" = true ]; then
            echo -e "${YELLOW}📄 .zprofile に変更があります${NC}"
            read -p "dotfilesに反映しますか？ (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$HOME/.zprofile" "$DOTFILES_DIR/.zprofile"
                updated_files+=(".zprofile")
            fi
        else
            cp "$HOME/.zprofile" "$DOTFILES_DIR/.zprofile"
            updated_files+=(".zprofile")
        fi
    fi
    
    if ! diff -q "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc" >/dev/null 2>&1; then
        if [ "$interactive" = true ]; then
            echo -e "${YELLOW}📄 .zshrc に変更があります${NC}"
            read -p "dotfilesに反映しますか？ (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
                updated_files+=(".zshrc")
            fi
        else
            cp "$HOME/.zshrc" "$DOTFILES_DIR/.zshrc"
            updated_files+=(".zshrc")
        fi
    fi
    
    # VS Code設定の更新
    if ! diff -q "$HOME/Library/Application Support/Code/User/settings.json" "$DOTFILES_DIR/vscode/settings.json" >/dev/null 2>&1; then
        if [ "$interactive" = true ]; then
            echo -e "${YELLOW}📄 VS Code settings.json に変更があります${NC}"
            read -p "dotfilesに反映しますか？ (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$HOME/Library/Application Support/Code/User/settings.json" "$DOTFILES_DIR/vscode/settings.json"
                updated_files+=("vscode/settings.json")
            fi
        else
            cp "$HOME/Library/Application Support/Code/User/settings.json" "$DOTFILES_DIR/vscode/settings.json"
            updated_files+=("vscode/settings.json")
        fi
    fi
    
    # Brewfileの更新
    echo -e "${YELLOW}🍺 Homebrewパッケージリスト更新確認${NC}"
    if [ "$interactive" = true ]; then
        read -p "Brewfileを現在のパッケージで更新しますか？ (y/n): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cd "$DOTFILES_DIR"
            brew bundle dump --force --describe
            updated_files+=("Brewfile")
        fi
    else
        cd "$DOTFILES_DIR"
        brew bundle dump --force --describe
        updated_files+=("Brewfile")
    fi
    
    echo ""
    if [ ${#updated_files[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ 以下のファイルを更新しました:${NC}"
        printf '%s\n' "${updated_files[@]}" | sed 's/^/  - /'
        echo ""
        echo "次のステップ:"
        echo "  git add . && git commit -m \"Update configurations\""
        echo "または: $0 commit"
    else
        echo -e "${GREEN}📝 更新が必要なファイルはありません${NC}"
    fi
}

# Git コミット支援
commit_changes() {
    cd "$DOTFILES_DIR"
    
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "${GREEN}📝 コミットするファイルがありません${NC}"
        return
    fi
    
    echo -e "${BLUE}📋 変更されたファイル:${NC}"
    git status --short
    echo ""
    
    read -p "🤔 これらの変更をコミットしますか？ (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "コミットメッセージを入力してください:"
        echo "例: Update VS Code settings with new extensions"
        read -p "> " commit_message
        
        if [ -n "$commit_message" ]; then
            git add .
            git commit -m "$commit_message"
            echo -e "${GREEN}✅ コミット完了！${NC}"
            
            read -p "🚀 リモートにプッシュしますか？ (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git push
                echo -e "${GREEN}🌍 プッシュ完了！${NC}"
            fi
        else
            echo -e "${RED}❌ コミットメッセージが空のためキャンセル${NC}"
        fi
    fi
}

# メイン処理
case "${1:-help}" in
    "status")
        if [ "$2" = "--detailed" ]; then
            show_detailed_diff
        else
            check_status
        fi
        ;;
    "update")
        if [ "$2" = "--interactive" ]; then
            update_dotfiles true
        else
            update_dotfiles false
        fi
        ;;
    "commit")
        commit_changes
        ;;
    "help"|*)
        show_help
        ;;
esac
