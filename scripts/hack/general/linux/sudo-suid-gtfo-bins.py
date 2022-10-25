#!/usr/bin/env python3

import os
import sys
import html

allSuids = ["ar","arp","ash","atobm","awk","base32","base64","basenc","bash","bridge","busybox","capsh","cat","chmod","chown","chroot","column","comm","cp","csh","csplit","cupsfilter","curl","cut","dash","date","dd","dialog","diff","dig","dmsetup","docker","ed","emacs","env","eqn","expand","expect","file","find","flock","fmt","fold","gawk","gdb","gimp","grep","gtester","hd","head","hexdump","highlight","hping3","iconv","install","ionice","ip","jjs","join","jq","jrunscript","ksh","ksshell","ld.so","less","logsave","look","lua","lwp-download","make","mawk","more","mv","nawk","nice","nl","nmap","node","nohup","od","openssl","paste","perl","pg","php","pr","python","readelf","restic","rev","rlwrap","rsync","run-parts","rview","rvim","sed","setarch","shuf","soelim","sort","sqlite3","ss","ssh-keyscan","start-stop-daemon","stdbuf","strace","strings","sysctl","systemctl","tac","tail","taskset","tbl","tclsh","tee","tftp","time","timeout","troff","ul","unexpand","uniq","unshare","update-alternatives","uudecode","uuencode","view","vigr","vim","vimdiff","vipw","watch","wget","xargs","xmodmap","xxd","xz","zsh","zsoelim"]

allSudos = ["apt-get","apt","ar","aria2c","arp","ash","at","atobm","awk","base32","base64","basenc","bash","bpftrace","bridge","bundler","busctl","busybox","byebug","capsh","cat","check_by_ssh","check_cups","check_log","check_memory","check_raid","check_ssl_cert","check_statusfile","chmod","chown","chroot","cobc","column","comm","composer","cowsay","cowthink","cp","cpan","cpulimit","crash","crontab","csh","csplit","cupsfilter","curl","cut","dash","date","dd","dialog","diff","dig","dmesg","dmsetup","dnf","docker","dpkg","easy_install","eb","ed","emacs","env","eqn","ex","exiftool","expand","expect","facter","file","find","flock","fmt","fold","ftp","gawk","gcc","gdb","gem","genisoimage","ghc","ghci","gimp","git","grep","gtester","hd","head","hexdump","highlight","hping3","iconv","iftop","install","ionice","ip","irb","jjs","join","journalctl","jq","jrunscript","ksh","ksshell","ld.so","ldconfig","less","logsave","look","ltrace","lua","lwp-download","lwp-request","mail","make","man","mawk","more","mount","mtr","mv","mysql","nano","nawk","nc","nice","nl","nmap","node","nohup","npm","nroff","nsenter","od","openssl","openvt","paste","pdb","perl","pg","php","pic","pico","pip","pkexec","pr","pry","psql","puppet","python","rake","readelf","red","redcarpet","restic","rev","rlwrap","rpm","rpmquery","rsync","ruby","run-mailcap","run-parts","rview","rvim","scp","screen","script","sed","service","setarch","sftp","shuf","slsh","smbclient","socat","soelim","sort","split","sqlite3","ss","ssh-keyscan","ssh","start-stop-daemon","stdbuf","strace","strings","su","sysctl","systemctl","tac","tail","tar","taskset","tbl","tclsh","tcpdump","tee","telnet","tftp","time","timeout","tmux","top","troff","ul","unexpand","uniq","unshare","update-alternatives","uudecode","uuencode","valgrind","vi","view","vigr","vim","vimdiff","vipw","watch","wget","wish","xargs","xmodmap","xxd","xz","yum","zip","zsh","zsoelim","zypper"]


# check amount of passed arguments
if (len(sys.argv) != 2):
    print("usage: {} pathToBinaries ".format(sys.argv[0]))
    sys.exit(1)

allUsableSuid = []
allUsableSudo = []

with open(sys.argv[1]) as binFile:
    for line in binFile:
        # get basename
        binary = os.path.basename(line).replace("\n","")

        if (binary in allSuids):
            allUsableSuid.append(binary)

        if (binary in allSudos):
            allUsableSudo.append(binary)

print("### SUID ###")

for i in allUsableSuid:
    print("https://gtfobins.github.io/gtfobins/" + i)

print("### SUDO ###")

for i in allUsableSudo:
    print("https://gtfobins.github.io/gtfobins/" + i)


