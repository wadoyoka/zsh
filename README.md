# .zshrc

macOS / Linux 向けの個人的な zsh 設定です。Oh My Zsh をベースに、Starship プロンプト・fzf 連携・ripgrep 検索など開発に便利な機能をまとめています。

## 使用ツール

- [zsh](https://www.zsh.org/) - 対話型シェル
- [Oh My Zsh](https://ohmyz.sh/) - zsh のプラグインフレームワーク
- [Homebrew](https://brew.sh/) - macOS / Linux 用パッケージマネージャー
- [Starship](https://starship.rs/) - 高速でカスタマイズ性の高いシェルプロンプト
- [fzf](https://github.com/junegunn/fzf) - ファジーファインダー
- [ripgrep](https://github.com/BurntSushi/ripgrep) - 高速 grep
- [bat](https://github.com/sharkdp/bat) - シンタックスハイライト付き cat
- [ghq](https://github.com/x-motemen/ghq) - リポジトリ管理
- [peco](https://github.com/peco/peco) - インタラクティブフィルタリング
- [yazi](https://github.com/sxyazi/yazi) - ターミナルファイルマネージャー
- [Neovim](https://neovim.io/) - テキストエディタ (デフォルトエディタとして設定)
- [Go](https://go.dev/) - Go 言語 (GOPATH を PATH に追加)

## 機能

### Oh My Zsh プラグイン

`git`, `you-should-use`, `zsh-bat`, `copypath`, `copyfile`, `aliases`, `docker`, `docker-compose`, `aws`, `terraform`, `golang`, `zsh-autosuggestions`, `zsh-syntax-highlighting`

### キーバインディング

| キー | 動作 |
|------|------|
| `↑` / `↓` | 現在の入力に一致するコマンドを履歴から検索 |
| `Ctrl+F` | autosuggestion を確定 |
| `Ctrl+G` | ghq + fzf でリポジトリに移動 |
| `Ctrl+]` | ghq + peco でリポジトリに移動 |

### 便利関数

| コマンド | 説明 |
|----------|------|
| `y` | yazi を起動し、終了時にそのディレクトリへ移動 |
| `fif` | ripgrep + fzf + bat でインタラクティブ検索し、vim で開く |

### その他

- **WORDCHARS**: 空文字列に設定。`Ctrl+W` でパス区切り (`/`) やドットで削除が止まる
- **LANG**: `en_US.UTF-8`
- **EDITOR**: `nvim`

### hidden/ ディレクトリの自動読み込み

`~/.config/zsh/hidden/` 内のすべての `.zsh` ファイルが自動的に読み込まれます。マシン固有の設定やシークレットを置くのに便利です。`.gitignore` に含まれているため誤コミットを防ぎます。

## インストール

### Makefile を使う (推奨)

```bash
git clone https://github.com/<your-username>/zsh ~/.config/zsh
cd ~/.config/zsh
make install
```

これで Homebrew、Oh My Zsh、全依存パッケージのインストールと `~/.zshrc` への設定追加が一括で行われます。

### 手動インストール

1. このリポジトリをクローン

```bash
git clone https://github.com/<your-username>/zsh ~/.config/zsh
```

2. `~/.zshrc` に以下を追加

```zsh
# このリポジトリから zsh 設定を読み込む
if [ -f "$HOME/.config/zsh/.zshrc" ]; then
  source "$HOME/.config/zsh/.zshrc"
fi
```

3. 依存ツールをインストール

```bash
brew install zsh starship fzf ripgrep bat ghq peco yazi neovim go
```

4. Oh My Zsh をインストール

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

5. Oh My Zsh のサードパーティプラグインをインストール

```bash
git clone https://github.com/MichaelAquilina/zsh-you-should-use ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-bat
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

6. ターミナルを再起動するか `source ~/.zshrc` を実行

## Starship 設定 (プロンプトのカスタマイズ)

Starship のプリセットを適用するには:

```bash
starship preset gruvbox-rainbow -o ~/.config/starship.toml
```

詳細なカスタマイズは [Starship 設定ドキュメント](https://starship.rs/config/) を参照してください。
