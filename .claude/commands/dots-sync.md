# Dotfiles 同期

dotfilesの差分確認から更新・コミットまでの一連のワークフローを実行します。

## ワークフロー

### Step 1: 差分確認
`~/.dotfiles/scripts/dotfiles-sync.sh status` を実行し、差分を確認・報告します。

### Step 2: 更新確認
差分がある場合、ユーザーに以下を確認:
- どのファイルを更新するか
- 全て更新 / 選択的に更新 / スキップ

### Step 3: ファイル更新
承認されたファイルを dotfiles リポジトリにコピー:
- システム設定 → dotfiles へ反映

### Step 4: コミット
変更内容から適切なコミットメッセージを自動生成し、ユーザーに確認後コミット。

## 対象ファイルのマッピング

| システム | dotfiles |
|---------|----------|
| `~/.zprofile` | `.zprofile` |
| `~/.zshrc` | `.zshrc` |
| `~/.gitconfig` | `.gitconfig` |
| `~/Library/Application Support/Code/User/settings.json` | `vscode/settings.json` |
| `~/Library/Application Support/Code/User/keybindings.json` | `vscode/keybindings.json` |
| `~/.ssh/config` | `ssh/config` |
| `~/.config/starship.toml` | `config/starship.toml` |

## 注意事項

- 秘密情報（APIキー等）が含まれていないか確認
- コミット前に差分を必ずユーザーに提示
- プッシュはユーザーの明示的な承認後のみ実行
