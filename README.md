# My Dotfiles

端末間で開発環境を効率的に管理・共有するためのDotfiles設定です。

## 🚀 クイックスタート

新しい環境での環境構築：

```bash
# 1. dotfilesをクローン
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. 基本設定をセットアップ
./scripts/setup-homebrew.sh  # Homebrewとパッケージをインストール
./scripts/setup-vscode.sh    # VS Code設定をセットアップ  
./scripts/setup-ssh.sh       # SSH設定をセットアップ

# 3. 新しいターミナルセッションを開始
# シェル設定とStarshipプロンプトが適用されます
```

## 📁 構成

```
~/.dotfiles/
├── Brewfile                 # Homebrew packages & VS Code extensions
├── .gitconfig              # Git configuration
├── .zprofile               # Zsh login configuration
├── .zshrc                  # Zsh interactive configuration
├── config/
│   └── starship.toml       # Starship prompt configuration
├── vscode/
│   ├── settings.json       # VS Code settings
│   ├── keybindings.json    # VS Code key bindings
│   ├── snippets/           # Code snippets
│   └── mcp.json.template   # MCP configuration template
├── ssh/
│   └── config              # SSH configuration (secure defaults)
└── scripts/
    ├── setup-homebrew.sh  # Homebrew setup script
    ├── setup-vscode.sh    # VS Code setup script
    └── setup-ssh.sh       # SSH setup script
```

## 🛠 管理対象の設定

### シェル設定
- **Zsh設定** (`.zshrc`, `.zprofile`)
  - Starshipプロンプト
  - 補完・シンタックスハイライト
  - 便利なエイリアス
  - 開発環境のPATH設定

### 開発ツール
- **Git設定** (`.gitconfig`)
  - ユーザー情報
  - 便利なエイリアス
  - Git LFS設定

- **VS Code設定**
  - エディタ設定とテーマ
  - キーバインド
  - コードスニペット
  - 100+ 拡張機能

- **SSH設定** (`ssh/config`)
  - セキュリティ強化されたデフォルト設定
  - macOS Keychain統合

### パッケージ管理
- **Brewfile** - 全Homebrewパッケージを管理
  - 開発ツール (Git, Node.js, Python, Go, PHP等)
  - ターミナル強化ツール
  - アプリケーション (iTerm2, VS Code, Postman等)
  - VS Code拡張機能

## 📝 よく使うコマンド

### 📊 Dotfiles管理（推奨運用）
```bash
# 設定の差分確認
dots-status                    # 現在の設定とdotfilesの差分をチェック
dots status --detailed         # 詳細な差分を表示

# 選択的な設定更新
dots-update                    # 対話的に変更を反映
dots update                    # 全ての変更を自動反映

# 変更をコミット
dots-commit                    # Git コミット支援

# ワンステップ同期
dots-quick                     # 確認→更新→コミットを一括実行
```

### 🔄 日常の運用ワークフロー
1. **設定変更後**: `dots-status` で差分確認
2. **同期したい場合**: `dots-update` で選択的反映
3. **他端末に共有**: `dots-commit` でコミット・プッシュ

```bash
# 例：VS Code設定を変更した後
dots-status              # 変更を確認
dots-update             # VS Code設定のみ反映を選択
dots-commit             # "Update VS Code settings" でコミット
```

### 🍺 Homebrewパッケージ管理
```bash
# 現在のパッケージでBrewfileを更新
cd ~/.dotfiles && brew bundle dump --force

# Brewfileから全パッケージをインストール
cd ~/.dotfiles && brew bundle

# インストール状況を確認
brew bundle check

# Brewfileにないパッケージを削除
brew bundle cleanup --force
```

## 🔒 セキュリティ

- **SSH秘密鍵**: dotfilesに含まれません（安全のため）
- **API キー**: テンプレート化され、実際のキーは除外
- **適切なファイル権限**: SSHファイルは600、ディレクトリは700

## 🎯 管理のベストプラクティス

### **選択的同期の哲学**
このdotfiles管理システムは**手動制御による選択的同期**を採用しています：

- ✅ **意図的な更新**: 必要な時だけ、意図した設定のみ同期
- ✅ **差分の可視化**: 変更内容を事前に確認してから反映
- ✅ **柔軟性**: 端末固有の設定は除外、共通設定のみ管理
- ❌ 自動同期によるトラブルを回避

### **推奨運用フロー**
```
設定変更 → dots-status → 差分確認 → dots-update → コミット → 他端末で取得
```

### **いつ同期すべきか**
- 🔧 **新しいツール設定**: エディタやツールの有用な設定を追加
- 🎨 **テーマ・外観**: 気に入ったカラーテーマやプロンプト設定  
- 🚀 **効率化設定**: 生産性向上につながるショートカットやエイリアス
- 📦 **パッケージ追加**: 新しい開発ツールのインストール

### **同期を避けるべき設定**
- 🔒 API キーや認証情報
- 📍 端末固有のパス設定
- 🖥️ ディスプレイサイズ依存の設定
- 📝 個人的な一時的設定

## ✨ 特徴

- **選択的同期**: 必要な設定のみ手動制御で同期
- **シンボリックリンク管理**: 元の場所から設定ファイルを参照
- **クロスプラットフォーム**: macOS向けに最適化
- **バックアップ機能**: セットアップ時に既存設定をバックアップ
- **モジュール化**: 個別コンポーネントを独立してセットアップ可能
- **自動化スクリプト**: ワンクリックでセットアップ完了

---

新しい端末での開発環境構築が数分で完了します！🎉
