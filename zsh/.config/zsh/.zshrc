ZDOTDIR=$HOME/.config/zsh

(( $+commands[brew] )) && eval $(/opt/homebrew/bin/brew shellenv)
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[go] )) && export PATH=$(go env GOPATH)/bin:$PATH # go binaries
(( $+commands[cargo] )) && export PATH=$HOME/.cargo/bin:$PATH # cargo(rust)
(( $+commands[bob] )) && export PATH=$HOME/.local/share/bob/nvim-bin:$PATH # cargo(rust)
(( $+commands[pyenv] )) && eval "$(pyenv init -)" && eval "$(pyenv init --path)" && eval "$(pyenv virtualenv-init -)"
(( $+commands[sdkman] )) && export PATH=$HOME/.sdkman/candidates/java/current/bin:$PATH # sdkman

# --- bash word select ---
autoload -U select-word-style
select-word-style bash

# --- completion ---
zmodload zsh/complist
zstyle ':completion:*' menu select
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# --- history ---
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=$HOME/.cache/.zsh_history
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# --- config for os ---
case "$(uname -s)" in
Darwin) # mac
  export XDG_CONFIG_HOME=$HOME/.config
  alias brew86="arch -x86_64 /usr/local/bin/brew"
  alias pyenv86="arch -x86_64 pyenv"
  alias ls="ls -G"
  alias ll="ls -lGFh"
  alias la="ls -laGFh"
	;;
Linux) # linux
  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -al --color=auto'
	;;
esac

# --- setttings ---
source $ZDOTDIR/aliases.sh
source $ZDOTDIR/prompt.sh
source $ZDOTDIR/plugins.sh

# --- custom ----
export PYTHON_ENV=${PYTHON_ENV}; 
export PYTHONPATH=${REPO_PATH}:$PYTHONPATH;
