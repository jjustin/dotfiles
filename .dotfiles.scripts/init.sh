#!/bin/bash

# First intall git
xcode-select --install

read -p "Press enter after code tools are installed"

# Bootstrap dotfiles
git clone https://github.com/jjustin/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME reset --hard
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --local include.path %HOME/.gitconfig
