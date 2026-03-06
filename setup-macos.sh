#!/bin/zsh
# macOS 패키지 설치
# setup.sh에서 호출됨
set -e

DOTFILES="$HOME/.dotfiles"

title "Xcode Command Line Tools"
if ! xcode-select -p &>/dev/null; then
	info "설치 중..."
	xcode-select --install
	until xcode-select -p &>/dev/null; do sleep 5; done
else
	ok "이미 설치됨"
fi

title "Homebrew"
if ! command -v brew &>/dev/null; then
	info "설치 중..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	ok "이미 설치됨"
fi

title "Brew 패키지 (Brewfile)"
brew bundle --file="$DOTFILES/Brewfile"
ok "완료"
