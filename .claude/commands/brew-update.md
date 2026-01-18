# Homebrew パッケージ同期

Homebrewパッケージの状態を確認し、Brewfileを更新します。

## 機能

### 1. 現在の状態確認
```bash
cd ~/.dotfiles && brew bundle check
```
- インストール済みパッケージとBrewfileの差分を確認

### 2. Brewfile更新（システム → dotfiles）
```bash
cd ~/.dotfiles && brew bundle dump --force --describe
```
- 現在インストールされているパッケージでBrewfileを更新
- `--describe` で各パッケージの説明を追加

### 3. パッケージインストール（dotfiles → システム）
```bash
cd ~/.dotfiles && brew bundle
```
- Brewfileに記載されたパッケージをインストール

### 4. クリーンアップ
```bash
brew bundle cleanup --force
```
- Brewfileに記載されていないパッケージを削除

## ワークフロー

1. `brew bundle check` で差分確認
2. 差分をユーザーにわかりやすく報告:
   - 新しくインストールされたパッケージ
   - 削除されたパッケージ
   - Brewfileにないがインストール済みのパッケージ
3. ユーザーの選択に応じて:
   - Brewfileを更新（dump）
   - パッケージをインストール（bundle）
   - 不要パッケージを削除（cleanup）
4. 変更があればコミットを提案

## 出力形式

パッケージの変更を以下のカテゴリで報告:
- Formula（CLIツール）
- Cask（GUIアプリ）
- Tap（追加リポジトリ）
- VS Code拡張機能
