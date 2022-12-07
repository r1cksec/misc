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

# wine
dpkg --add-architecture i386
apt-get update && apt-get upgrade

# apt-get hacker tools
apt-get install metagoofil openssh-server gobuster python3-pip crackmapexec hcxtools hcxdumptool hostapd-wpe mingw-w64 dsniff vim-gtk3 rusers parsero python3-venv fcrackzip smtp-user-enum gcc-multilib linux-exploit-suggester davtest sshuttle remmina flameshot virtualenv freerdp2-x11 freerdp2-shadow-x11 htop xclip wine:i386 git python2-setuptools-whl python3.10-venv htop zsh ufw

# bloodhound
apt-get install bloodhound
mkdir -p /usr/share/neo4j/{run,logs}
neo4j start

# git tools
mkdir ${homeDir}/git
cd ${homeDir}/git

git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/nidem/kerberoast.git
git clone https://github.com/AdrianVollmer/PowerSploit.git
git clone https://github.com/dirkjanm/ldapdomaindump.git
git clone https://github.com/bitsadmin/wesng.git
git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
git clone https://github.com/r1cksec/Get-LAPSPasswords.git
git clone https://github.com/FluxionNetwork/fluxion.git
git clone https://github.com/secretsquirrel/SigThief.git
git clone https://github.com/WindowsExploits/Exploits.git
git clone https://github.com/rezasp/joomscan.git
git clone https://github.com/tennc/webshell.git
git clone https://github.com/SECFORCE/Tunna.git
git clone https://github.com/3v4Si0N/HTTP-revshell.git
git clone https://github.com/yarrick/iodine.git
git clone https://github.com/cribdragg3r/Alaris.git
git clone https://github.com/freshness79/HTA-Shell.git
git clone https://github.com/JohnWoodman/VBA-Macro-Reverse-Shell.git
git clone https://github.com/cym13/vbs-reverse-shell.git
git clone https://github.com/frohoff/ysoserial.git
git clone https://github.com/lobuhi/byp4xx.git
git clone https://github.com/maurosoria/dirsearch.git
git clone https://github.com/r1cksec/cheatsheets.git
git clone https://github.com/r1cksec/misc.git
git clone https://github.com/SirVer/ultisnips.git

# python virtual environment
mkdir ${homeDir}/pythonEnvironments

# python 2 virtual environment -> currently diabled because: apt install python2-pip-whl -> does not exist
# virtualenv -p /usr/bin/python2.7 ${homeDir}/pythonEnvironments/python2Env

# python 3 virtual environment
python3 -m venv ${homeDir}/pythonEnvironments/pentest
source ${homeDir}/pythonEnvironments/pentest/bin/activate
pip3 install mmh3

# hacking tools using virtual environment
git clone https://github.com/pwnfoo/NTLMRecon
cd ${homeDir}/git/NTLMRecon
python3 setup.py install
cd ${homeDir}/git

git clone https://github.com/fox-it/BloodHound.py.git
cd ${homeDir}/git/BloodHound.py 
python3 setup.py install
cd ${homeDir}/git

git clone https://github.com/r1cksec/autorec.git
cd ${homeDir}/git/autorec 
bash setup.sh 
cd ${homeDir}/git

git clone https://github.com/AdrianVollmer/PowerHub.git
pip3 install -r ${homeDir}/git/PowerHub/requirements.txt

git clone https://github.com/skelsec/pypykatz.git
cd ${homeDir}/git/pypykatz 
python3 setup.py install 
cd ${homeDir}/git
pip3 install asn1crypto --upgrade

pip3 install truffleHog
cp ${homeDir}/pythonEnvironments/pentest/bin/trufflehog /usr/local/bin

git clone https://github.com/sherlock-project/sherlock.git
python3 -m pip install -r ${homeDir}/git/sherlock/requirements.txt

python3 -m pip install lsassy

git clone https://github.com/blechschmidt/massdns.git
cd ${homeDir}/git/massdns 
make 
cd ${homeDir}/git
chmod +x ${homeDir}/git/massdns/bin/massdns
cp ${homeDir}/git/massdns/bin/massdns /usr/local/bin

git clone https://github.com/Dionach/CMSmap
cd ${homeDir}/git/CMSmap 
pip3 install . 
cd ${homeDir}/git

git clone https://github.com/GerbenJavado/LinkFinder.git
cd ${homeDir}/git/LinkFinder 
#python setup.py install 
pip3 install -r requirements.txt 
cd ${homeDir}/git

git clone https://github.com/hashcat/hashcat-utils.git
cd ${homeDir}/git/hashcat-utils/src
make
cd ${homeDir}/git

git clone https://github.com/devanshbatham/FavFreak.git
cd ${homeDir}/git/FavFreak
cp ${homeDir}/git/FavFreak/favfreak.py /usr/local/bin/favfreak
chmod +x /usr/local/bin/favfreak

deactivate

# gem
gem install evil-winrm
gem install wpscan

# install chromium
bash -c "echo 'deb http://ftp.debian.org/debian stable main contrib non-free' >> /etc/apt/sources.list"
apt-get update
apt-get install chromium

# golang
cd ${homeDir}
wget https://golang.google.cn/dl/go1.18.5.linux-amd64.tar.gz
tar -C /usr/local -xzf ${homeDir}/go1.18.5.linux-amd64.tar.gz
rm ${homeDir}/go1.18.5.linux-amd64.tar.gz

# linux binaries
mkdir ${homeDir}/linux-tools

/usr/local/go/bin/go install github.com/hakluke/hakrawler@latest
cp /root/go/bin/hakrawler /usr/local/bin
rm -rf /root/go

/usr/local/go/bin/go install github.com/edoardottt/csprecon/cmd/csprecon@latest
cp /root/go/bin/csprecon /usr/local/bin
rm -rf /root/go

/usr/local/go/bin/go install github.com/dhn/spk@latest
cp /root/go/bin/spk /usr/local/bin
rm -rf /root/go

mkdir ${homeDir}/linux-tools/geckodriver
cd ${homeDir}/linux-tools/geckodriver
wget https://github.com/projectdiscovery/katana/releases/download/v0.0.2/katana_0.0.2_linux_386.zip
gunzip geckodriver-*.tar.gz
tar -xf geckodriver-*.tar
sudo cp geckodriver /usr/local/bin

mkdir ${homeDir}/linux-tools/namemash
cd ${homeDir}/linux-tools/namemash
wget https://gist.githubusercontent.com/superkojiman/11076951/raw/053152dba6c5cc3107ff0374ce7246306958d72c/namemash.py

mkdir ${homeDir}/linux-tools/chisel
cd ${homeDir}/linux-tools/chisel
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_linux_amd64.gz
gunzip *
chmod +x *

mkdir ${homeDir}/linux-tools/kerbrute
cd ${homeDir}/linux-tools/kerbrute
wget https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64
chmod +x *
cp ${homeDir}/linux-tools/kerbrute/kerbrute_linux_amd64 /usr/local/bin

mkdir ${homeDir}/linux-tools/aquatone
cd ${homeDir}/linux-tools/aquatone
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/aquatone/aquatone /usr/local/bin

mkdir ${homeDir}/linux-tools/postman
cd ${homeDir}/linux-tools/postman
wget https://dl.pstmn.io/download/latest/linux64

mkdir ${homeDir}/linux-tools/subfinder
cd ${homeDir}/linux-tools/subfinder
wget https://github.com/projectdiscovery/subfinder/releases/download/v2.5.4/subfinder_2.5.4_linux_amd64.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/subfinder/subfinder /usr/local/bin

mkdir ${homeDir}/linux-tools/scanrepo
cd ${homeDir}/linux-tools/scanrepo
wget https://github.com/UKHomeOffice/repo-security-scanner/releases/download/0.4.0/scanrepo-0.4.0-linux-amd64.tar.gz
tar -xf *
chmod +x *
cp ${homeDir}/linux-tools/scanrepo/scanrepo /usr/local/bin

mkdir ${homeDir}/linux-tools/gitleaks
cd ${homeDir}/linux-tools/gitleaks
wget https://github.com/zricethezav/gitleaks/releases/download/v7.6.1/gitleaks-linux-amd64
chmod +x *
cp ${homeDir}/linux-tools/gitleaks/gitleaks-linux-amd64 /usr/local/bin

mkdir ${homeDir}/linux-tools/waybackurls
cd ${homeDir}/linux-tools/waybackurls
wget https://github.com/tomnomnom/waybackurls/releases/download/v0.1.0/waybackurls-linux-amd64-0.1.0.tgz
tar -xf *
chmod +x *
cp ${homeDir}/linux-tools/waybackurls/waybackurls /usr/local/bin

mkdir ${homeDir}/linux-tools/bettercap
cd ${homeDir}/linux-tools/bettercap
wget https://github.com/bettercap/bettercap/releases/download/v2.31.1/bettercap_linux_amd64_v2.31.1.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/bettercap/bettercap /usr/local/bin

mkdir ${homeDir}/linux-tools/amass
cd ${homeDir}/linux-tools/amass
wget https://github.com/OWASP/Amass/releases/download/v3.19.2/amass_linux_amd64.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/amass/amass_linux_amd64/amass /usr/local/bin

mkdir ${homeDir}/linux-tools/ffuf
cd ${homeDir}/linux-tools/ffuf
wget https://github.com/ffuf/ffuf/releases/download/v1.3.1/ffuf_1.3.1_linux_amd64.tar.gz
tar -xf *
chmod +x *
cp ${homeDir}/linux-tools/ffuf/ffuf /usr/local/bin

mkdir ${homeDir}/linux-tools/sigurlfind3r
cd ${homeDir}/linux-tools/sigurlfind3r
wget https://github.com/signedsecurity/sigurlfind3r/releases/download/v1.5.0/sigurlfind3r_1.5.0_linux_386.tar.gz
gunzip *
tar -xf *
chmod +x *
cp ${homeDir}/linux-tools/sigurlfind3r/sigurlfind3r /usr/local/bin

mkdir ${homeDir}/linux-tools/nuclei
cd ${homeDir}/linux-tools/nuclei
wget https://github.com/projectdiscovery/nuclei/releases/download/v2.5.3/nuclei_2.5.3_linux_386.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/nuclei/nuclei /usr/local/bin

mkdir ${homeDir}/linux-tools/chromeDriver
cd ${homeDir}/linux-tools/chromeDriver
wget https://chromedriver.storage.googleapis.com/103.0.5060.134/chromedriver_linux64.zip
unzip *
chmod +x *
cp ${homeDir}/linux-tools/chromeDriver/chromedriver /usr/local/bin

# oh my zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ${homeDir}/.oh-my-zsh
cp ${homeDir}/.oh-my-zsh/templates/zshrc.zsh-template ${homeDir}/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${homeDir}/git/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${homeDir}/git/zsh-syntax-highlighting
sed -i 's/plugins=(\*)/plugins=(git colored-man-pages docker)/g' ${homeDir}/.zshrc
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="dogenpunk"/g' ${homeDir}/.zshrc
echo "" >> ${homeDir}/.zshrc
cat ${homeDir}/git/misc/config-files/zshrc >> ${homeDir}/.zshrc
sed 's/#export PATH=$PATH:\/usr\/local\/go\/bin/export PATH=$PATH:\/usr\/local\/go\/bin/g' ${homeDir}/.zshrc
echo "" >> ${homeDir}/.zshrc
cat ${homeDir}/git/misc/config-files/zshrc-kali >> ${homeDir}/.zshrc
chsh -s /usr/bin/zsh

# bashrc
echo "" >> ${homeDir}/.bashrc
cat ${homeDir}/git/misc/config-files/bashrc >> ${homeDir}/.bashrc

# create aliase
bash ${homeDir}/git/misc/scripts/manage/create-aliase.sh

# firewall
ufw default deny
ufw allow 22/tcp
ufw allow 80/tcp
ufw enable

# allow normal user to open ports > 1024
sysctl net.ipv4.ip_unprivileged_port_start=0

# close rpc port
systemctl disable rpcbind.service

# systemd low battery notification
cat > /etc/systemd/system/battery.service <<EOL
[Unit]
Description=send notification when battery level is low

[Service]
User=${username}
Type=forking
Environment=DISPLAY=:0
ExecStart=/bin/bash ${homeDir}/git/misc/scripts/manage/notifyLowBattery.sh
EOL

cat > /etc/systemd/system/battery.timer <<EOL
[Unit]
Description=send notification when battery level is low

[Timer]
OnUnitActiveSec=3m
OnBootSec=3m

[Install]
WantedBy=timers.target
EOL

systemctl enable battery.timer

# ip configuration
cat > /etc/systemd/system/ipconfig.service <<EOL
[Unit]
Description=configure ip addresses

[Service]
ser=root
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/sudo /bin/bash ${homeDir}/config/scripts/config-ip.sh
EOL

cat > /etc/systemd/system/ipconfig.timer <<EOL
[Unit]
Description=configure ip addresses

[Timer]
OnUnitActiveSec=2m
OnBootSec=0m

[Install]
WantedBy=timers.target
EOL

systemctl enable ipconfig.timer
systemctl daemon-reload

# history 
cat ${homeDir}/git/cheatsheets/linux/* | grep -A 2 "###" | grep "\`" -A 1 | grep -v "\`\|--\|,\|+\|:\|ä\|ö\|ü\|msf\| = \|%" | awk 'length($0) > 5 { print $0 }' >> ${homeDir}/.zsh_history

# vim
cp ${homeDir}/git/misc/scripts/config-files/vimrc -O ${homeDir}/.vimrc
sed -i 's/"set runtimepath/set runtimepath/g' ${homeDir}/.vimrc
# ultisnips
mkdir -p ${homeDir}/.vim/{UltiSnips,dictionaries}
mkdir -p ${homeDir}/.vim/ftdetect
ln -s ${homeDir}/git/ultisnips/ftdetect/* ${homeDir}/.vim/ftdetect

# used for burp extensions
mkdir ${homeDir}/config
wget https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.3/jython-standalone-2.7.3.jar -O ${homeDir}/config/jython-standalone-2.7.3.jar

# reset ownership
cd ${homeDir}
chown -R ${username}:${username} *
chown -R ${username}:${username} .*

# ssh
systemctl start ssh
systemctl enable ssh

# manual
echo "##### What you still need to do #####"

# ultisnips
echo ""
echo "bash ${homeDir}/git/misc/scripts/manage/generate-vim-ulti-snippets.sh"
echo ""

# neo4j
echo ""
echo "Go to: http://localhost:7474"
echo "sudo neo4j start"
echo "Change Creds: neo4j - neo4j"
echo "You may need the databse URL: bolt://127.0.0.1:7687"
echo "If window stays white: CTRL + R"
echo ""

# ssh
echo "ssh-keygen -t rsa -b 4096"
echo "ssh-copy-id -i ~/.ssh/<privatKey> ${username}@yourIp"
echo "sed -i 's/#Banner none/Banner none/g' /etc/ssh/sshd_config"
echo "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
echo "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config"
echo "sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config"
echo "systemctl restart ssh"
echo ""

# burp
echo "# Burp "
echo "Add jython standalone: Extender > Options > Python Environment > Select file"
echo "# Add Extensions"
echo "Active Scanner++"
echo "Authorize"
echo "AWS Security Checks"
echo "Backslash Powered Scanner"
echo "Error Message Checks"
echo "HTTP Requeset Smuggler"
echo "Image Size Issues"
echo "J2EEScan"
echo "JSON Web Token Attacker"
echo "Json Web Tokens"
echo "Logger++"
echo "Retire.js"
echo "Software Version Reporter"
echo "Turbo Intruder"
echo "xssValidator"
echo "# put Logger++ on the bottom: Extender > Burp Extensions"
echo ""
echo "# Firefox"
echo "Create new Profile pentest"
echo "Create new Profile news"
echo ""
echo "Start default profile"
echo "https://addons.mozilla.org/en-US/firefox/addon/redandblacktheme"
echo "https://addons.mozilla.org/en-US/firefox/addon/canvasblocker"
echo "https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17"
echo "https://addons.mozilla.org/en-US/firefox/addon/darkreader"
echo "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin"
echo "https://addons.mozilla.org/en-US/firefox/addon/umatrix"
echo ""
echo "Start pentest profile"
echo "https://addons.mozilla.org/de/firefox/addon/foxyproxy-standard"
echo "https://addons.mozilla.org/de/firefox/addon/wappalyzer"
echo "https://addons.mozilla.org/de/firefox/addon/single-file"
echo "https://addons.mozilla.org/de/firefox/addon/colorzilla"
echo "https://addons.mozilla.org/en-US/firefox/addon/hacker-mode"
echo "Weballyzer -> set send anonymous feedback to null"
echo "Add Proxy 127.0.0.1:8080 inside foxyproxy"
echo "http://burp"
echo "about:preferences > Privacy & Security > Certficates > View Certificates > Authorities > Import"
echo ""
echo "Start news profile"
echo "https://addons.mozilla.org/en-GB/firefox/addon/simply-black-and-light-blue"
echo "https://addons.mozilla.org/en-US/firefox/addon/ublock-origin"
echo "https://addons.mozilla.org/en-US/firefox/addon/umatrix"
echo "https://blog.badsectorlabs.com"
echo "https://thehackernews.com"
echo "https://latesthackingnews.com"
echo "https://portswigger.net/daily-swig"
echo "https://www.golem.de/specials/security"
echo "https://www.heise.de/security"
echo "https://twitter.com/search?q=CVE%20poc%20min_faves%3A10&src=typed_query&f=live"
echo "https://twitter.com/search?q=linux%20exploit%20min_faves%3A10&src=typed_query&f=live"
echo "https://twitter.com/search?q=vulnerability%20infosec%20min_faves%3A10&src=typed_query"
echo "https://twitter.com/search?q=windows%20exploit%20min_faves%3A10&src=typed_query&f=live"
echo ""
echo "# Host only Adapter"
echo "Add Host only network interface to vm"
echo "File > Host-only Network-Manager > Create"
echo "Configure adapter manually"
echo "IPv4-Adress: 192.168.111.1"
echo "IPv4-Mask: 255.255.255.0"

