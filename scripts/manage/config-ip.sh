sudo nmcli device set eth1 managed no
sudo ip a add 192.168.56.111/24 dev eth1
sudo ip l set eth1 up
sudo dhclient eth0

