#!/bin/bash
##installing the needed packeges
if command -v apt >/dev/null 2>&1; then
	sudo apt update
	sudo apt install -y zsh git
elif command -v yay >/dev/null 2>&1; then
	yay -Sy --noconfirm zsh git
elif command -v dnf >/dev/null 2>&1; then
	sudo dnf install -y zsh git
else
	echo "None of the required package managers (apt, yay, dnf) are available."
	exit 1
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ./zsh/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./zsh/.zsh/zsh-syntax-highlighting
#copy the config file
cp -rf ./zsh ~/.config/
cp -f ./.zshenv ~
