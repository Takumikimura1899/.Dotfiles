#!/bin/bash

# =============================================================================
# NEW TERMINAL SETUP SCRIPT
# =============================================================================
# 新しい端末での開発環境一括セットアップスクリプト
# 
# Usage: ./setup-new-terminal.sh
# 
# このスクリプトは以下を自動実行します:
# 1. Homebrewのインストール
# 2. Brewfileからのパッケージインストール
# 3. シンボリックリンクの作成
# 4. 基本設定の適用

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

DOTFILES_DIR="$HOME/.dotfiles"
LOG_FILE="$DOTFILES_DIR/setup.log"

# ログ関数
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${CYAN}=============================================================================${NC}"
    echo -e "${CYAN}  🚀 NEW TERMINAL SETUP${NC}"
    echo -e "${CYAN}=============================================================================${NC}"
    echo -e "${YELLOW}新しい端末での開発環境を自動構築します${NC}"
    echo ""
}

print_step() {
    echo ""
    echo -e "${PURPLE}📋 STEP $1: $2${NC}"
    echo -e "${PURPLE}-----------------------------------------------------------------------------${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# エラーハンドリング
handle_error() {
    print_error "セットアップ中にエラーが発生しました"
    echo "詳細なログは以下で確認できます: $LOG_FILE"
    exit 1
}

trap 'handle_error' ERR

# 事前チェック
check_prerequisites() {
    print_step "0" "事前チェック"
    
    # macOSチェック
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "このスクリプトはmacOS専用です"
        exit 1
    fi
    
    # dotfilesディレクトリの存在チェック
    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_error ".dotfilesディレクトリが見つかりません: $DOTFILES_DIR"
        echo "まず以下を実行してください:"
        echo "git clone <your-dotfiles-repo> ~/.dotfiles"
        exit 1
    fi
    
    # インターネット接続チェック
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "インターネット接続が必要です"
        exit 1
    fi
    
    print_success "事前チェック完了"
    log "Prerequisites check passed"
}

# Homebrewインストール
install_homebrew() {
    print_step "1" "Homebrewインストール"
    
    if command -v brew &> /dev/null; then
        print_success "Homebrewは既にインストール済みです"
        log "Homebrew already installed"
    else
        echo "Homebrewをインストールしています..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Apple Silicon Mac用のPATH設定
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrewインストール完了"
        log "Homebrew installed successfully"
    fi
}

# Brewfileからのパッケージインストール
install_brew_packages() {
    print_step "2" "Homebrewパッケージインストール"
    
    if [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
        print_warning "Brewfileが見つかりません。スキップします。"
        return
    fi
    
    echo "Brewfileからパッケージをインストールしています..."
    echo "これには時間がかかる場合があります..."
    
    cd "$DOTFILES_DIR"
    
    # パッケージ数を表示
    local formula_count=$(grep -c '^brew ' Brewfile || echo 0)
    local cask_count=$(grep -c '^cask ' Brewfile || echo 0)  
    local vscode_count=$(grep -c '^vscode ' Brewfile || echo 0)
    
    echo "インストール予定:"
    echo "  - Formula: $formula_count個"
    echo "  - Cask: $cask_count個"
    echo "  - VS Code拡張: $vscode_count個"
    echo ""
    
    # 確認
    read -p "インストールを続行しますか？ (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "パッケージインストールをスキップしました"
        return
    fi
    
    # インストール実行
    brew bundle --verbose 2>&1 | tee -a "$LOG_FILE"
    
    print_success "Homebrewパッケージインストール完了"
    log "Homebrew packages installed successfully"
}

# シンボリックリンク作成
create_symlinks() {
    print_step "3" "設定ファイルのシンボリックリンク作成"
    
    # 基本設定ファイル
    local files=(
        ".zprofile"
        ".zshrc" 
        ".gitconfig"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$DOTFILES_DIR/$file" ]]; then
            # バックアップ作成
            if [[ -f "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
                mv "$HOME/$file" "$HOME/${file}.backup.$(date +%Y%m%d_%H%M%S)"
                echo "既存の $file をバックアップしました"
            fi
            
            # シンボリックリンク作成
            ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
            echo "✓ $file"
        fi
    done
    
    # .config設定（dotfiles内のパス = リンク先のパス）
    local config_files=(
        "starship.toml"
        "ghostty/config"
        "herdr/config.toml"
    )

    for file in "${config_files[@]}"; do
        if [[ -f "$DOTFILES_DIR/config/$file" ]]; then
            mkdir -p "$(dirname "$HOME/.config/$file")"
            # 既存の実ファイルはバックアップ
            if [[ -f "$HOME/.config/$file" ]] && [[ ! -L "$HOME/.config/$file" ]]; then
                mv "$HOME/.config/$file" "$HOME/.config/${file}.backup.$(date +%Y%m%d_%H%M%S)"
            fi
            ln -sf "$DOTFILES_DIR/config/$file" "$HOME/.config/$file"
            echo "✓ $file"
        fi
    done
    
    print_success "シンボリックリンク作成完了"
    log "Symlinks created successfully"
}

# 個別セットアップスクリプト実行
run_individual_setups() {
    print_step "4" "個別セットアップスクリプト実行"
    
    local scripts=(
        "setup-ssh.sh:SSH設定"
        "setup-vscode.sh:VS Code設定"
    )
    
    for script_info in "${scripts[@]}"; do
        IFS=':' read -r script_name description <<< "$script_info"
        script_path="$DOTFILES_DIR/scripts/$script_name"
        
        if [[ -f "$script_path" ]]; then
            echo ""
            echo "🔧 $description セットアップ"
            read -p "$description をセットアップしますか？ (y/N): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                "$script_path" 2>&1 | tee -a "$LOG_FILE"
                print_success "$description セットアップ完了"
            else
                print_warning "$description セットアップをスキップしました"
            fi
        else
            print_warning "$script_path が見つかりません"
        fi
    done
    
    log "Individual setups completed"
}

# 最終確認・推奨事項
final_recommendations() {
    print_step "5" "セットアップ完了・推奨事項"
    
    print_success "基本的なセットアップが完了しました！"
    
    echo ""
    echo -e "${YELLOW}📝 次にやるべきこと:${NC}"
    echo "1. 新しいターミナルセッションを開始してください"
    echo "2. Starshipプロンプトとシェル設定が適用されます"
    echo "3. 以下のファイルで手動インストールが必要なアプリを確認:"
    echo "   📄 ~/.dotfiles/apps/manual-apps.md"
    echo ""
    echo -e "${YELLOW}🔧 追加の設定:${NC}"
    echo "• SSH鍵の設定（必要な場合）"
    echo "• クラウドサービスのログイン（1Password、Adobe等）"
    echo "• ブラウザの設定とブックマーク同期"
    echo "• VS Codeのログイン・設定同期"
    echo ""
    echo -e "${YELLOW}🔄 dotfiles管理コマンド:${NC}"
    echo "• dots-status  : 設定の差分確認"
    echo "• dots-update  : 変更を反映"  
    echo "• dots-commit  : 変更をコミット"
    echo ""
    echo -e "${GREEN}🎉 セットアップログ: $LOG_FILE${NC}"
    
    log "Setup completed successfully"
}

# エラー復旧情報
show_recovery_info() {
    echo ""
    echo -e "${YELLOW}💡 トラブルシューティング:${NC}"
    echo "• エラーが発生した場合: $LOG_FILE を確認"
    echo "• 手動でのやり直し: 各スクリプトを個別実行"
    echo "  - ~/.dotfiles/scripts/setup-homebrew.sh"
    echo "  - ~/.dotfiles/scripts/setup-vscode.sh" 
    echo "  - ~/.dotfiles/scripts/setup-ssh.sh"
    echo "• 設定の確認: dots-status"
    echo ""
}

# メイン実行
main() {
    # ログファイル初期化
    echo "Setup started at $(date)" > "$LOG_FILE"
    
    print_header
    
    echo "セットアップを開始する前に、以下を確認してください:"
    echo "• 安定したインターネット接続"
    echo "• 管理者権限（パスワード入力が必要になる場合があります）"
    echo "• 時間の余裕（初回は30分〜1時間程度かかります）"
    echo ""
    
    read -p "セットアップを開始しますか？ (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "セットアップをキャンセルしました"
        exit 0
    fi
    
    # 実行
    check_prerequisites
    install_homebrew
    install_brew_packages
    create_symlinks
    run_individual_setups
    final_recommendations
    show_recovery_info
    
    echo ""
    print_success "🎊 新しい端末のセットアップが完了しました！"
    echo -e "${CYAN}新しいターミナルセッションを開いて、設定を確認してください。${NC}"
}

# スクリプトが直接実行された場合のみmainを実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
