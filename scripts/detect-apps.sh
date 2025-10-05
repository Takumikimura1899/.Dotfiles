#!/bin/bash

# Non-Homebrew Application Detection Script
# 端末にインストールされているHomebrew以外のアプリケーションを検出・分類

set -e

DOTFILES_DIR="$HOME/.dotfiles"
OUTPUT_FILE="$DOTFILES_DIR/apps/manual-apps.md"
TEMP_FILE="/tmp/all_apps.txt"

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 非Homebrewアプリケーション検出中...${NC}"

# 出力ディレクトリを作成
mkdir -p "$DOTFILES_DIR/apps"

# 全アプリケーション一覧を取得
ls -1 /Applications | grep -E "\.app$" > "$TEMP_FILE" 2>/dev/null || true

# Homebrew caskアプリ一覧を取得
BREW_CASKS=($(brew list --cask 2>/dev/null | tr '\t' '\n'))

# 非Homebrewアプリを特定
NON_HOMEBREW_APPS=()

while IFS= read -r app; do
    app_name="${app%.app}"
    app_name_lower=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
    
    # Homebrew caskに含まれるかチェック
    is_homebrew=false
    for brew_app in "${BREW_CASKS[@]}"; do
        if [[ "$app_name_lower" == "$brew_app" ]] || [[ "$app_name" == *"$brew_app"* ]]; then
            is_homebrew=true
            break
        fi
    done
    
    if [[ "$is_homebrew" == false ]]; then
        NON_HOMEBREW_APPS+=("$app")
    fi
done < "$TEMP_FILE"

echo -e "${GREEN}✅ 検出完了${NC}"
echo "  - 総アプリ数: $(wc -l < "$TEMP_FILE")"
echo "  - Homebrew管理: ${#BREW_CASKS[@]}"
echo "  - 非Homebrew: ${#NON_HOMEBREW_APPS[@]}"

# アプリ情報を詳しく取得する関数
get_app_info() {
    local app_path="/Applications/$1"
    local app_name="${1%.app}"
    
    # 基本情報
    local bundle_id=""
    local version=""
    
    if [[ -f "$app_path/Contents/Info.plist" ]]; then
        bundle_id=$(defaults read "$app_path/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || echo "Unknown")
        version=$(defaults read "$app_path/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "Unknown")
    fi
    
    echo "- **$app_name** (v$version)"
    echo "  - Bundle ID: \`$bundle_id\`"
    echo "  - インストール方法: 要確認"
    echo "  - 備考: "
    echo ""
}

# Markdownファイルを生成
cat > "$OUTPUT_FILE" << 'EOF'
# Manual Applications List

端末移行時に手動でインストールが必要なアプリケーション一覧です。

## 概要

このリストは自動生成されたHomebrew以外の方法でインストールされたアプリケーションです。
新しい端末への移行時に参照してください。

## 📱 アプリケーション一覧

### システム・ユーティリティ

### 開発ツール

### ブラウザ・通信

### メディア・エンタメ

### 生産性・ビジネス

### その他

EOF

# 検出したアプリケーション情報を追加
echo "" >> "$OUTPUT_FILE"
echo "## 🔍 検出されたアプリケーション" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "最終更新: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for app in "${NON_HOMEBREW_APPS[@]}"; do
    get_app_info "$app" >> "$OUTPUT_FILE"
done

# クリーンアップ
rm -f "$TEMP_FILE"

echo -e "${GREEN}📄 アプリケーションリストを生成しました:${NC}"
echo "   $OUTPUT_FILE"
echo ""
echo -e "${YELLOW}📝 次の手順:${NC}"
echo "1. 生成されたファイルを編集して各アプリのインストール方法を記録"
echo "2. 不要なアプリや重複を整理"
echo "3. カテゴリ別に分類"
echo "4. dotfilesにコミット"
