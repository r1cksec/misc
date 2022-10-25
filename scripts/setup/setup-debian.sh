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
ip=$(curl ifconfig.me)

# ssh
sed -i 's/#Banner none/Banner none/g' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo ""
echo "ssh-keygen -t rsa -b 4096"
echo "ssh-copy-id -i ~/.ssh/<privatKey> ${username}@${ip}"
echo "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
echo "sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config"
echo "sudo systemctl restart ssh"
echo ""

echo "Make sure ssh is listening in port 2222 before you continue or you might lock yourself out ..."
goOn="Y"

echo ""
echo "Is your ssh service listeneing on port 2222? (Y/N)"
read userInput

if [ "${userInput}" == "${goOn}" ]
then
    systemctl enable ssh
    
    # add sudo permission
    /sbin/usermod -a -G sudo ${username}
    timedatectl set-timezone Europe/Berlin
    
    # ufw
    apt-get install ufw tmux screen python3-venv python3-pip
    ufw allow 2222/tcp
    ufw limit 2222/tcp
    ufw default deny
    systemctl enable ufw.service
    systemctl start ufw.service
    ufw enable

    # zsh
    mkdir ${homeDir}/git
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${homeDir}/.oh-my-zsh
    cp ${homeDir}/.oh-my-zsh/templates/zshrc.zsh-template ${homeDir}/.zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions ${homeDir}/git/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${homeDir}/git/zsh-syntax-highlighting
    sed -i 's/plugins=(\*)/plugins=(git colored-man-pages docker)/g' ${homeDir}/.zshrc
    sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dieter"/g' ${homeDir}/.zshrc
    echo "" >> ${homeDir}/.zshrc
    curl https://raw.githubusercontent.com/r1cksec/misc/main/config-files/zshrc >> ${homeDir}/.zshrc
    
    # bash
    echo "" >> ${homeDir}/.bashrc
    curl https://raw.githubusercontent.com/r1cksec/misc/main/config-files/bashrc >> ${homeDir}/.bashrc

    # vim
    wget https://raw.githubusercontent.com/r1cksec/misc/main/config-files/vimrc -O ${homeDir}/.vimrc

    echo ""
    echo "Install Apache2? (Y/N)"
    read userInput

    if [ "${userInput}" == "${goOn}" ]
    then
        apt-get install apache2 php libapache2-mod-php 
        systemctl disable apache2
        ufw allow 80/tcp
        ufw allow 443/tcp

        echo ""
        echo "Setup LesEncrypt? (Y/N)"
        read userInput

        if [ "${userInput}" == "${goOn}" ]
        then
            apt-get install certbot python3-certbot-apache
            hostname -f
            certbot --apache
        fi
    fi

    # python
    python3 -m venv ~/pythonEnvironments
    source ~/pythonEnvironments/bin/activate
    pip3 install --upgrade pip

    #vpn
    mkdir ${homeDir}/scripts
    
    echo ""
    echo "Install Openvpn? (Y/N)"
    read userInput

    if [ "${userInput}" == "${goOn}" ]
    then
        wget https://git.io/vpn -O ${homeDir}/scripts/openvpn-install.sh && bash openvpn-install.sh
        ufw allow 1194/udp
    fi
fi

