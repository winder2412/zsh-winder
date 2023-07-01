#!/bin/bash

os=$(uname -a)

if [[ $os == *"arch"* ]]; then
  # Install zsh using pacman package manager
  sudo pacman -Sy zsh git
elif [[ $os == *"debian"* ]]; then
  # Install zsh using apt package manager
  sudo apt-get install zsh git
elif [[ $os == *"fedora"* ]]; then
  # Install zsh using dnf package manager
  sudo dnf install zsh git
else
  echo "Unsupported operating system"
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ./zsh/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./zsh/.zsh/zsh-syntax-highlighting
#copy the config file
cp -rf ./zsh ~/.config/
cp -f ./.zshenv ~
