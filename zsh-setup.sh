#!/bin/bash
##installing the needed packeges
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then 
    echo -e "yay was located, moving on.\n"
    yay -Suy
else 
    git clone https://aur.archlinux.org/yay-bin
    cd yay-bin
    makepkg -si
    yay --version
    cd ..
fi
yay -S --noconfirm zsh zsh-syntax-highlighting autojump zsh-autosuggestions git 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
##copy the config file
cp -rf ./zsh ~/.config/zsh
cp -f ./.zshenv ~
