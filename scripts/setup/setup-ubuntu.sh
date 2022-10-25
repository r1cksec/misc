#!/bin/bash

# stop on error
set -e
# stop on undefined
set -u

if [ "$EUID" -ne 0 ]
then
    echo "Please run script as root"
    exit
fi

echo "Enter full path to your home directory:"
read homeDir

apt update && sudo apt upgrade
apt install i3lock htop flameshot jmtpfs python3-venv p7zip-full vim-ultisnips whois vim virtualbox virtualbox-qt virtualbox-dkms ssh ufw john zsh xclip git pass vim-gtk virtualbox-ext-pack curl vlc feh inkscape arandr vim-gtk3 virtualbox-ext-pack grip
snap install chromium spotify

rego="R"
i3="I"
echo ""
echo "Regolith or I3? (R/I/Anything else for none)"
read userInput

if [ "${userInput}" == "${rego}" ]
then
    add-apt-repository ppa:regolith-linux/release
    apt install regolith-desktop-standard
    echo "" >> /etc/regolith/i3/config
    echo "focus_follows_mouse yes" >> /etc/regolith/i3/config
elif [ "${userInput}" == "${i3}" ]
then
    sudo apt install i3-wm i3lock i3status dunst pavucontrol 
fi

# git
mkdir ${homeDir}/git
git clone https://github.com/r1cksec/cheatsheets ${homeDir}/git/cheatsheets
git clone https://github.com/r1cksec/misc ${homeDir}/git/misc

# zsh
chsh -s /bin/zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ${homeDir}/.oh-my-zsh
cp ${homeDir}/.oh-my-zsh/templates/zshrc.zsh-template ${homeDir}/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${homeDir}/git/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${homeDir}/git/zsh-syntax-highlighting
sed -i 's/plugins=(\*)/plugins=(git colored-man-pages docker)/g' ${homeDir}/.zshrc
echo "" >> ${homeDir}/.zshrc
curl https://raw.githubusercontent.com/r1cksec/misc/main/config-files/zshrc >> ${homeDir}/.zshrc

# bash
echo "" >> ${homeDir}/.bashrc
curl https://raw.githubusercontent.com/r1cksec/misc/main/config-files/bashrc >> ${homeDir}/.bashrc

# vim
wget https://raw.githubusercontent.com/r1cksec/misc/main/config-files/vimrc -O ${homeDir}/.vimrc

# signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg gnome-tweak-tool
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

