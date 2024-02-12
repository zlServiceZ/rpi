#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt-get install apparmor jq wget curl udisks2 libglib2.0-bin network-manager dbus systemd-journal-remote -y

curl -fsSL get.docker.com | sh

sudo groupadd docker
sudo usermod -aG docker $USER

systemd.unified_cgroup_hierarchy=false

sudo bash -c 'cat << EOF >> /etc/default/grub
systemd.unified_cgroup_hierarchy=false
EOF'

sudo bash -c 'cat << EOF >> /boot/cmdline.txt
systemd.unified_cgroup_hierarchy=false apparmor=1 security=apparmor
EOF'

# install os agent
wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb
sudo dpkg -i os-agent_1.6.0_linux_aarch64.deb
sudo rm -r os-agent_1.6.0_linux_aarch64.deb
gdbus introspect --system --dest io.hass.os --object-path /io/hass/os

# install home assistant supervised
wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo dpkg -i homeassistant-supervised.deb
sudo rm -r homeassistant-supervised.deb

# fix the errors you will get during the installation
sudo apt --fix-broken install -y

echo "kernel=kernel8.img" | sudo tee -a /boot/firmware/config.txt > /dev/null

echo "Finally reboot and wait several minutes until HA is available at http://[your_IP]:8123"

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"

