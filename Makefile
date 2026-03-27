.PHONY: install brew oh-my-zsh brew-packages omz-plugins zshrc uninstall

# デフォルトターゲット: すべてインストール
install: brew oh-my-zsh brew-packages omz-plugins zshrc
	@echo ""
	@echo "=========================================="
	@echo " インストール完了!"
	@echo " ターミナルを再起動するか、以下を実行:"
	@echo "   source ~/.zshrc"
	@echo "=========================================="

# --- Homebrew ---
brew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo ">>> Homebrew をインストール中..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo ">>> Homebrew は既にインストール済み"; \
	fi

# --- Homebrew パッケージ ---
BREW_PACKAGES := zsh starship fzf ripgrep bat ghq peco yazi neovim go

brew-packages: brew
	@echo ">>> Homebrew パッケージをインストール中..."
	@for pkg in $(BREW_PACKAGES); do \
		if brew list $$pkg >/dev/null 2>&1; then \
			echo "  ✓ $$pkg (インストール済み)"; \
		else \
			echo "  → $$pkg をインストール中..."; \
			brew install $$pkg; \
		fi; \
	done

# --- Oh My Zsh ---
oh-my-zsh:
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		echo ">>> Oh My Zsh をインストール中..."; \
		RUNZSH=no KEEP_ZSHRC=yes sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
	else \
		echo ">>> Oh My Zsh は既にインストール済み"; \
	fi

# --- Oh My Zsh サードパーティプラグイン ---
ZSH_CUSTOM_DIR := $(HOME)/.oh-my-zsh/custom/plugins

omz-plugins: oh-my-zsh
	@echo ">>> Oh My Zsh プラグインをインストール中..."
	@if [ ! -d "$(ZSH_CUSTOM_DIR)/you-should-use" ]; then \
		git clone https://github.com/MichaelAquilina/zsh-you-should-use $(ZSH_CUSTOM_DIR)/you-should-use; \
	else \
		echo "  ✓ you-should-use (インストール済み)"; \
	fi
	@if [ ! -d "$(ZSH_CUSTOM_DIR)/zsh-bat" ]; then \
		git clone https://github.com/fdellwing/zsh-bat $(ZSH_CUSTOM_DIR)/zsh-bat; \
	else \
		echo "  ✓ zsh-bat (インストール済み)"; \
	fi
	@if [ ! -d "$(ZSH_CUSTOM_DIR)/zsh-autosuggestions" ]; then \
		git clone https://github.com/zsh-users/zsh-autosuggestions $(ZSH_CUSTOM_DIR)/zsh-autosuggestions; \
	else \
		echo "  ✓ zsh-autosuggestions (インストール済み)"; \
	fi
	@if [ ! -d "$(ZSH_CUSTOM_DIR)/zsh-syntax-highlighting" ]; then \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting $(ZSH_CUSTOM_DIR)/zsh-syntax-highlighting; \
	else \
		echo "  ✓ zsh-syntax-highlighting (インストール済み)"; \
	fi

# --- ~/.zshrc にソース行を追加 ---
ZSHRC_SOURCE := source "$$HOME/.config/zsh/.zshrc"

zshrc:
	@if [ ! -f "$$HOME/.zshrc" ] || ! grep -qF '.config/zsh/.zshrc' "$$HOME/.zshrc"; then \
		echo ">>> ~/.zshrc に設定を追加中..."; \
		echo '' >> "$$HOME/.zshrc"; \
		echo '# zsh 設定を読み込む' >> "$$HOME/.zshrc"; \
		echo 'if [ -f "$$HOME/.config/zsh/.zshrc" ]; then' >> "$$HOME/.zshrc"; \
		echo '  source "$$HOME/.config/zsh/.zshrc"' >> "$$HOME/.zshrc"; \
		echo 'fi' >> "$$HOME/.zshrc"; \
	else \
		echo ">>> ~/.zshrc には既に設定済み"; \
	fi

# --- アンインストール ---
uninstall:
	@echo ">>> ~/.zshrc から設定行を削除するには手動で編集してください"
	@echo ">>> Oh My Zsh のアンインストール: uninstall_oh_my_zsh"
	@echo ">>> Homebrew パッケージの削除: brew uninstall $(BREW_PACKAGES)"
