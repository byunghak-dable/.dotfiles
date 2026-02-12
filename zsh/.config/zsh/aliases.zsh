#!/bin/sh
# process by port
function port() {
  lsof -i :$1
}

# fabric-ai
function _fabric_ai() {
  fabric-ai "$*"
}

# config
alias src="source ~/.zshrc"
alias zrc="nvim ~/.config/zsh/"
alias nvimrc="nvim ~/.config/nvim/"
alias krc="nvim ~/.config/karabiner/"
alias alc="nvim ~/.config/alacritty/"
alias glc="nvim ~/.config/ghostty/"
alias hlc="nvim ~/.config/hypr/"
alias tlc="nvim ~/.tmux.conf"

# util
alias f="fd --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"
alias nv="nvim"
alias cl="clear"
alias tl="tmux clear-history"
alias g="lazygit"

# confirm before overwriting something
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# docker
alias decr='aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | podman login -u AWS --password-stdin '
alias dbuild='podman build -f ${DOCKERFILE_PATH} -t local-build-app --build-arg NODE_ENV=${NODE_ENV} --build-arg AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} --build-arg AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} --build-arg AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION} --platform linux/x86_64 .'

# env
alias setenv='export $(xargs < .env)'

# ai
alias '??'='noglob _fabric_ai'
alias '?'="w3m"
