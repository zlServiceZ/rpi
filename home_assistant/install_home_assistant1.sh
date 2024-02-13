#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install \
apparmor \
cifs-utils \
curl \
dbus \
jq \
libglib2.0-bin \
lsb-release \
network-manager \
nfs-common \
systemd-journal-remote \
systemd-resolved \
udisks2 \
wget -y

curl -fsSL get.docker.com | sh

sudo groupadd docker
sudo usermod -aG docker $USER

sudo bash -c 'cat << EOF >> /etc/default/grub
systemd.unified_cgroup_hierarchy=false
EOF'

sudo bash -c 'cat << EOF >> /boot/firmware/cmdline.txt
 apparmor=1 security=apparmor
EOF'

echo "kernel=kernel8.img" | sudo tee -a /boot/firmware/config.txt > /dev/null

source "$HOME/rpi/tools/restart.sh"