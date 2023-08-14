#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'

command_exists () {
    command -v $1 >/dev/null 2>&1;
}

checkEnv() {
    ## Check for requirements.
    REQUIREMENTS='curl groups sudo'
    if ! command_exists ${REQUIREMENTS}; then
        echo -e "${RED}To run me, you need: ${REQUIREMENTS}${RC}"
        exit 1
    fi

    ## Check Package Handeler
    PACKAGEMANAGER='apt dnf pacman'
    for pgm in ${PACKAGEMANAGER}; do
        if command_exists ${pgm}; then
            PACKAGER=${pgm}
            echo -e "Using ${pgm}"
        fi
    done

    if [ -z "${PACKAGER}" ]; then
        echo -e "${RED}Can't find a supported package manager"
        exit 1
    fi


    ## Check if the current directory is writable.
    GITPATH="$(dirname "$(realpath "$0")")"
    if [[ ! -w ${GITPATH} ]]; then
        echo -e "${RED}Can't write to ${GITPATH}${RC}"
        exit 1
    fi

    ## Check SuperUser Group
    SUPERUSERGROUP='wheel sudo'
    for sug in ${SUPERUSERGROUP}; do
        if groups | grep ${sug}; then
            SUGROUP=${sug}
            echo -e "Super user group ${SUGROUP}"
        fi
    done

    ## Check if member of the sudo group.
    if ! groups | grep ${SUGROUP} >/dev/null; then
        echo -e "${RED}You need to be a member of the sudo group to run me!"
        exit 1
    fi
    
}

installDepend() {
    ## Check for dependencies.
    DEPENDENCIES='autojump zsh tar bat'
    echo -e "${YELLOW}Installing dependencies...${RC}"
    if [[ $PACKAGER == "pacman" ]]; then
        if ! command_exists yay; then
            echo "Installing yay..."
            sudo ${PACKAGER} --noconfirm -S base-devel
            $(cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git && sudo chown -R ${USER}:${USER} ./yay-git && cd yay-git && makepkg --noconfirm -si)
        else
            echo "Command yay already installed"
        fi
    	yay --noconfirm -S ${DEPENDENCIES}
    else 
    	sudo ${PACKAGER} install -yq ${DEPENDENCIES}
    fi
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.config/zsh/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ./zsh/.zsh/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./zsh/.zsh/zsh-syntax-highlighting

}

linkConfig() {
    echo -e "${YELLOW}Linking new zsh config file...${RC}"
    ## Make symbolic link.
    file_path="/etc/zsh/zshenv"
    line_to_add="ZDOTDIR=~/.config/zsh"

    if [ -e "$file_path" ]; then
        # File exists, add the line if it's not already present
        if ! grep -qF "$line_to_add" "$file_path"; then
            sudo bash -c "echo '$line_to_add' >> '$file_path'"
            echo "Line added to existing file."
        else
            echo "Line already present in the file."
        fi
    else
        touch "$file_path"
        sudo bash -c "echo "$line_to_add" >> "$file_path""
        echo "File created and line added."
    fi


    cp -r ${GITPATH}/zsh ${HOME}/.config
}

checkEnv
installDepend
installStarship
if linkConfig; then
    echo -e "${GREEN}Done!\nrestart your shell to see the changes.${RC}"
else
    echo -e "${RED}Something went wrong!${RC}"
fi
