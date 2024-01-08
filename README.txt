git clone https://github.com/zlServiceZ/rpi.git

# Execute script
chmod +x rpi/install_syncthing.sh
rpi/install_syncthing.sh

sudo rm -r ~/.config/syncthing
sudo rm -r rpi
sudo rm -r Sync
sudo apt remove syncthing