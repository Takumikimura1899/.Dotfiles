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

### Homebrewパッケージ管理
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

### 設定の更新
```bash
# 変更をコミット
cd ~/.dotfiles
git add .
git commit -m "Update configuration"
git push
```

## 🔒 セキュリティ

- **SSH秘密鍵**: dotfilesに含まれません（安全のため）
- **API キー**: テンプレート化され、実際のキーは除外
- **適切なファイル権限**: SSHファイルは600、ディレクトリは700

## ✨ 特徴

- **シンボリックリンク管理**: 元の場所から設定ファイルを参照
- **クロスプラットフォーム**: macOS向けに最適化
- **バックアップ機能**: セットアップ時に既存設定をバックアップ
- **モジュール化**: 個別コンポーネントを独立してセットアップ可能
- **自動化スクリプト**: ワンクリックでセットアップ完了

---

新しい端末での開発環境構築が数分で完了します！🎉
