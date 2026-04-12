# ==============================================================================
# 1. 環境変数 / パス設定 (Environment Variables & Paths)
# ==============================================================================
export LANG=en_US.UTF-8
export EDITOR=nvim
export PATH="$HOME/.local/bin:$(go env GOPATH)/bin:$PATH"

# Oh My Zsh のパス
export ZSH="$HOME/.oh-my-zsh"

# ==============================================================================
# 2. Oh My Zsh 設定 (Plugins & Core)
# ==============================================================================
# Starshipを使うため、OMZのテーマは無効化（干渉を防ぐ）
ZSH_THEME=""

# プラグイン一括管理
# ※ zsh-syntax-highlighting と autosuggestions は最後に記述するのが定石
plugins=(
  git
  you-should-use
  zsh-bat
  copypath
  copyfile
  aliases
  docker
  docker-compose
  aws
  terraform
  golang
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Oh My Zsh 起動
source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 3. 外部ツールの初期化 (External Tool Inits)
# ==============================================================================
# Starship プロンプト
eval "$(starship init zsh)"

# fzf (zsh統合モード)
source <(fzf --zsh)

# ==============================================================================
# 4. 操作感のカスタマイズ (Behaviors & Keybindings)
# ==============================================================================
# 履歴検索: 入力中の文字で検索 (上/下矢印)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# 単語削除 (Ctrl+w) でパスセパレータ等で止まるようにする
WORDCHARS=''

# Autosuggestions の設定
bindkey '^F' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#ffb6c1' # ピンク系のハイライト

# ==============================================================================
# 5. 便利関数 & エイリアス (Custom Functions)
# ==============================================================================
alias grep='rg'

# --- yazi: 終了時にそのディレクトリに移動 ---
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# --- fif: ripgrep + fzf + bat + vim の最強検索 ---
fif() {
  rm -f /tmp/rg-fzf-{r,f}
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --query "$INITIAL_QUERY" \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'bat --color=always --highlight-line {2} {1}' \
      --preview-window 'right,60%,border-left,+{2}+3/3' \
      --bind 'enter:become(vim {1} +{2})'
}

# --- ghq + fzf: リポジトリ移動 (Ctrl+g) ---
cd_git_repo() {
  local selected="$(ghq list | fzf)"
  if [[ -n "$selected" ]]; then
    cd "$(ghq root)/$selected"
  fi
}
zle -N cd_git_repo
bindkey '^g' cd_git_repo

# --- peco-src: リポジトリ移動 (Ctrl+]) ※peco派の場合 ---
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# ==============================================================================
# 6. 隠し設定の読み込み (Secrets & Machine-specific)
# ==============================================================================
HIDDEN_ALIASES_DIR="$HOME/.config/zsh/hidden"
if [ -d "$HIDDEN_ALIASES_DIR" ]; then
  for f in "$HIDDEN_ALIASES_DIR"/*.zsh(N); do
    if [ -r "$f" ] && [ -f "$f" ]; then
      source "$f"
    fi
  done
fi
