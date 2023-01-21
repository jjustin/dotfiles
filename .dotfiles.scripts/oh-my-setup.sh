#!/bin/bash

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

if [ "$(uname)" = "Darwin" ]; then
    brew install fzf
    # To install useful key bindings and fuzzy completion:
    $(brew --prefix)/opt/fzf/install
elif [ "$(uname)" = "Linux" ];then
    sudo apt install fzf
fi