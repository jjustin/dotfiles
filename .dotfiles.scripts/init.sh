#!/bin/bash

# First intall git
xcode-select --install

read -p "Press enter after code tools are installed"

read -p "Enter email to be used for git config and ssh key: " email

ssh-keygen -t ed25519 -C $email
cat << EOF > ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
pbcopy < ~/.ssh/id_ed25519.pub

read -p "Public ssh key copied to clipboard. Add it to github and press enter to continue"

# Bootstrap dotfiles
git clone https://github.com/jjustin/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME reset --hard
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME config --local include.path %HOME/.gitconfig

# Prepare private zshrc
cat << EOF > .zshrc.private
# Configure private zshrc in this file
echo "Private zshrc file exsit but is not configured. Edit ~/.zshrc.private to remove this message."
EOF

# Prepare private gitconfig
cat << EOF > .gitconfig.private
# Set private git configuration here

[user]
	email = $email

[includeIf "gitdir:~/<...>/"]
    path = ~/<...>/.gitconfig

...
EOF

echo "Opening private gitconfig. Edit and save it. Then continue with the rest of the scripts"
vi ~/.gitconfig.private

echo "Reload zsh and then run ~/.dotfiles.scripts/install.sh. Or install only the components you want."
