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
username=$(basename ${homeDir})

apt update && sudo apt upgrade
apt install htop flameshot jmtpfs python3-venv p7zip-full vim whois virtualbox virtualbox-qt virtualbox-dkms ssh ufw john zsh xclip git pass vim-gtk curl vlc feh inkscape arandr vim-gtk3 grip wl-clipboard texlive-latex-extra texlive-fonts-extra texlive-lang-german
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

# ultisnips
git clone https://github.com/SirVer/ultisnips.git {homeDir}/git/ultisnips
mkdir -p ${homeDir}/.vim/{UltiSnips,dictionaries}
mkdir -p ${homeDir}/.vim/ftdetect
ln -s ${homeDir}/git/ultisnips/ftdetect/* ${homeDir}/.vim/ftdetect

# vim
wget https://raw.githubusercontent.com/r1cksec/misc/main/config-files/vimrc -O ${homeDir}/.vimrc

# ufw
ufw default deny
ufw allow 22/tcp
ufw allow 80/tcp
ufw enable

# signal
wget https://updates.signal.org/desktop/apt/keys.asc -O /tmp/signal.asc
cat /tmp/signal.asc | sudo apt-key add
echo "deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main" >> /etc/apt/sources.list.d/signal-xenial.list
sudo apt update && sudo apt install signal-desktop

chsh -s /usr/bin/zsh
cd ${homeDir}
chown -R ${username}:${username} *
chown -R ${username}:${username} .*

Start default profile
https://addons.mozilla.org/en-US/firefox/addon/redandblacktheme
https://addons.mozilla.org/en-US/firefox/addon/canvasblocker
https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17
https://addons.mozilla.org/en-US/firefox/addon/darkreader
https://addons.mozilla.org/en-US/firefox/addon/ublock-origin
https://addons.mozilla.org/en-US/firefox/addon/umatrix

Start news profile
https://addons.mozilla.org/en-GB/firefox/addon/simply-black-and-light-blue
https://addons.mozilla.org/en-US/firefox/addon/ublock-origin
https://addons.mozilla.org/en-US/firefox/addon/umatrix
https://blog.badsectorlabs.com
https://thehackernews.com
https://latesthackingnews.com
https://portswigger.net/daily-swig
https://www.golem.de/specials/security
https://www.heise.de/security
https://twitter.com/search?q=CVE%20poc%20min_faves%3A10&src=typed_query&f=live
https://twitter.com/search?q=linux%20exploit%20min_faves%3A10&src=typed_query&f=live
https://twitter.com/search?q=vulnerability%20infosec%20min_faves%3A10&src=typed_query
https://twitter.com/search?q=windows%20exploit%20min_faves%3A10&src=typed_query&f=live

