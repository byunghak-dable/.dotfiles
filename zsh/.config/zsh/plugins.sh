#!/bin/sh
function add_plug() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$ZDOTDIR/.plugins/$PLUGIN_NAME" ]; then 
        git clone "https://github.com/$1.git" "$ZDOTDIR/.plugins/$PLUGIN_NAME"
    fi
    source "$ZDOTDIR/.plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
    source "$ZDOTDIR/.plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
}
# nvm plugin
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=("nvim")
add_plug lukechilds/zsh-nvm
add_plug zsh-users/zsh-autosuggestions
add_plug zsh-users/zsh-syntax-highlighting
