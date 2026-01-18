# Dotfiles 差分確認

dotfilesリポジトリと現在のシステム設定の差分を確認し、わかりやすく報告します。

## 手順

1. `~/.dotfiles/scripts/dotfiles-sync.sh status` を実行して差分を確認
2. 差分がある場合は、各ファイルについて以下を報告:
   - どのファイルに差分があるか
   - 差分の概要（追加・削除・変更の内容）
   - 推奨アクション
3. 差分がない場合は「全て同期済み」と報告

## 確認対象

- シェル設定: `.zprofile`, `.zshrc`
- Git設定: `.gitconfig`
- VS Code設定: `settings.json`, `keybindings.json`
- SSH設定: `ssh/config`
- Starship設定: `starship.toml`
- Homebrewパッケージ: `Brewfile`

## 出力形式

差分を表形式でまとめ、次のアクション（`/dots-sync` の実行など）を提案してください。
