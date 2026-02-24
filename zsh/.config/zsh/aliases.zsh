#!/bin/sh
# process by port
function port() {
  lsof -i :$1
}

# fabric-ai
function _fabric_ai() {
  fabric-ai "$*"
}


function nc() {
  if [[ -z "$TMUX" ]]; then
    echo "Not inside a tmux session. Run from within tmux."
    return 1
  fi

  # Determine working directory from argument
  local target="${1:-$PWD}"
  local dir
  if [[ -d "$target" ]]; then
    dir="$(realpath "$target")"
  else
    dir="$(realpath "$(dirname "$target")")"
  fi

  # nvim을 실행할 현재 pane ID 저장
  local nvim_pane
  nvim_pane="$(tmux display-message -p '#{pane_id}')"

  # Split right (30% width) for claude — full height
  tmux split-window -h -c "$dir" -l 30% "claude; exec $SHELL"

  # Go back to left pane and split bottom (20% height) for terminal only under neovim
  tmux select-pane -L
  tmux split-window -v -c "$dir" -l 20%

  # nvim pane으로 포커스 이동 후 neovim 실행
  tmux select-pane -t "$nvim_pane"
  nvim "$@"
}


# config
alias src="source ~/.zshrc"
alias zrc="nc ~/.config/zsh/"
alias nvimrc="nc ~/.config/nvim/"
alias krc="nc ~/.config/karabiner/"
alias alc="nc ~/.config/alacritty/"
alias glc="nc ~/.config/ghostty/"
alias hlc="nc ~/.config/hypr/"
alias tlc="nc ~/.tmux.conf"

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
