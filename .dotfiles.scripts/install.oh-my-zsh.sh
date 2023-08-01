#!/bin/bash

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install Homebrew before running this script."
    exit 1
fi


# Oh my zsh
ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/blimmer/zsh-aws-vault.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-aws-vault
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# To install useful key bindings and fuzzy completion:
brew install fzf
$(brew --prefix)/opt/fzf/install

echo "You might need to reload .zshrc file"
