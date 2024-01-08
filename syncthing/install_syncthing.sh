#!/bin/bash

# Add the release PGP keys:
sudo mkdir -p /etc/apt/keyrings
echo "Adding Syncthing release PGP keys..."
sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "Syncthing release PGP keys added successfully."

# Add the "stable" channel to your APT sources:
echo "Adding Syncthing 'stable' channel to APT sources..."
echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
echo "Syncthing 'stable' channel added to APT sources."

# Update and install Syncthing:
echo "Updating APT repositories..."
sudo apt update
echo "Installing Syncthing..."
sudo apt install syncthing
echo "Syncthing installed successfully."

echo "Creating config files."

# Running Syncthing in the background
syncthing --home "$HOME/.config/syncthing" &

# Wait for 10 seconds
sleep 10

# Stopping Syncthing
pkill syncthing

sleep 2

# Make GUI available
# Use sed to replace the search pattern
sed -i 's#<address>127.0.0.1:[0-9]\{3,5\}</address>#<address>0.0.0.0:8384</address>#' "$HOME/.config/syncthing/config.xml"
echo "Created config files successfully"
echo "Syncthing is running on localhost:8384"

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"
