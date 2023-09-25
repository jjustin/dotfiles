#!/bin/bash

# First intall git
xcode-select --install

read -p "Press enter after code tools are installed"

# Bootstrap dotfiles
git clone https://github.com/jjustin/dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
dot checkout
dot config --local status.showUntrackedFiles no
dot config --local include.path %HOME/.gitconfig

cat << EOF > .zshrc.private
# Configure private zshrc in this file
echo "Private zshrc file exsit but is not configured. Edit ~/.zshrc to remove this message."
EOF

# Prepare private gitconfig
cat << EOF > .gitconfig.private
# Set private git configuration here

[user]
	email = ...

[includeIf "gitdir:~/<...>/"]
    path = ~/<...>/.gitconfig

...
EOF

echo "Opening private gitconfig. Edit and save it. Then continue with the rest of the scripts"
open .gitconfig.private
