#!/bin/bash

curl -fsSL get.docker.com | sh

sudo groupadd docker
sudo usermod -aG docker $USER

# install os agent
wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_aarch64.deb
sudo dpkg -i os-agent_1.6.0_linux_aarch64.deb
sudo rm -r os-agent_1.6.0_linux_aarch64.deb
gdbus introspect --system --dest io.hass.os --object-path /io/hass/os

sudo systemctl start systemd-journal-gatewayd.service
sudo systemctl start systemd-journal-gatewayd.socket

# install home assistant supervised
wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
sudo apt install ./homeassistant-supervised.deb
sudo rm -r homeassistant-supervised.deb

# fix the errors you will get during the installation
sudo apt --fix-broken install -y

echo "Finally reboot and wait several minutes until HA is available at http://[your_IP]:8123"

