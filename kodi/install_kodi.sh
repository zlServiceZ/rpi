#!/bin/bash

sudo apt update
sudo apt upgrade -y

# install kodi
sudo apt install kodi

# enable web interface
sudo bash -c "cat << EOF > $HOME/.kodi/userdata/guisettings.xml
<advancedsettings>
    <services>
        <esallinterfaces>true</esallinterfaces>
        <webserver>true</webserver>
        <zeroconf>true</zeroconf>
    </services>
</advancedsettings>
EOF"

echo "Installed Kodi."
echo "You can reach the web interface at localhost:8080"

# enable autostart
sudo bash -c "cat << EOF > /etc/systemd/system/kodi.service
[Unit]
Description = Kodi Media Center
After = remote-fs.target network-online.target
Wants = network-online.target
[Service]
User = administrator
Group = administrator
Type = simple
ExecStart = /usr/bin/kodi-standalone
Restart = on-abort
RestartSec = 5
[Install]
WantedBy = multi-user.target
EOF"

sudo systemctl enable kodi

sudo bash -c "cat << EOF > $HOME/.kodi/userdata/advancedsettings.xml
<advancedsettings version="1.0">
    <memorysize>536870912</memorysize>
</advancedsettings>
EOF"

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"