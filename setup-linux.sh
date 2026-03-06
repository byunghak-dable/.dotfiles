#!/bin/bash
# Linux 패키지 설치
# setup.sh에서 호출됨
set -e

# ─── apt/pacman 패키지 ────────────────────────────────────
title "시스템 패키지"
APT_PACKAGES=(git zsh tmux stow fzf ripgrep fd-find curl wget unzip software-properties-common)

if command -v apt &>/dev/null; then
	MISSING=()
	for pkg in "${APT_PACKAGES[@]}"; do
		dpkg -s "$pkg" &>/dev/null 2>&1 || MISSING+=("$pkg")
	done
	if [[ ${#MISSING[@]} -gt 0 ]]; then
		sudo apt update && sudo apt install -y "${MISSING[@]}"
	else
		ok "이미 모두 설치됨"
	fi
elif command -v pacman &>/dev/null; then
	sudo pacman -Sy --needed --noconfirm git zsh tmux stow fzf ripgrep fd curl wget unzip
fi
ok "완료"

# ─── neovim (stable PPA) ─────────────────────────────────
title "Neovim"
if ! command -v nvim &>/dev/null; then
	sudo add-apt-repository -y ppa:neovim-ppa/stable
	sudo apt update && sudo apt install -y neovim
fi
ok "$(nvim --version | head -1)"

# ─── fd symlink (Ubuntu는 fd-find으로 설치) ───────────────
if [[ -f /usr/bin/fdfind && ! -f /usr/local/bin/fd ]]; then
	sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
	ok "fd symlink 생성"
fi

# ─── GitHub CLI ───────────────────────────────────────────
title "GitHub CLI"
if ! command -v gh &>/dev/null; then
	curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
	sudo apt update && sudo apt install -y gh
fi
ok "$(gh --version | head -1)"

# ─── zoxide ───────────────────────────────────────────────
title "zoxide"
if ! command -v zoxide &>/dev/null; then
	curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi
ok "$(zoxide --version)"

# ─── lazygit ──────────────────────────────────────────────
title "lazygit"
if ! command -v lazygit &>/dev/null; then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
	rm /tmp/lazygit.tar.gz
fi
ok "$(lazygit --version | head -1)"

# ─── git-delta ────────────────────────────────────────────
title "git-delta"
if ! command -v delta &>/dev/null; then
	DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
	curl -Lo /tmp/delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
	sudo dpkg -i /tmp/delta.deb
	rm /tmp/delta.deb
fi
ok "$(delta --version)"

# ─── Node.js LTS ─────────────────────────────────────────
title "Node.js"
if ! command -v node &>/dev/null; then
	curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
	sudo apt install -y nodejs
fi
ok "$(node --version)"
