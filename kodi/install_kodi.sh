#!/bin/bash

sudo apt update
sudo apt upgrade -y

# install kodi
sudo apt install software-properties-common
sudo add-apt-repository -y ppa:team-xbmc/ppa
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

# autostart
sudo sed -i "1i @kodi" /etc/xdg/lxsession/LXDE-pi/autostart
