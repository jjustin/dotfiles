#!/bin/bash

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

if [ "$(uname)" = "Darwin" ]; then
    brew install fzf
    # To install useful key bindings and fuzzy completion:
    $(brew --prefix)/opt/fzf/install
elif [ "$(uname)" = "Linux" ];then
    which fzf || sudo apt install fzf
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

if [ "$(uname)" = "Linux" ];then
    FONT_PATH=~/.local/share/fonts
    fonts=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
    
    for font in "${fonts[@]}"
    do
        if [ ! -f "$FONT_PATH/$font" ]; then
            echo $font
            url_encoded_font=$(echo $font | sed -e 's/ /%20/g') 
            wget https://github.com/romkatv/powerlevel10k-media/raw/master/$url_encoded_font -P $FONT_PATH
        fi
    done
    fc-cache -f -v $FONT_PATH
fi

echo "SET 'MesloLGS NF' as your terminal's font"