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
sudo apt-get update
echo "Installing Syncthing..."
sudo apt-get install syncthing
echo "Syncthing installed successfully."

# Activate autostart
echo "Enabling Syncthing autostart..."
sudo systemctl enable syncthing@myuser.service
sudo systemctl start syncthing@myuser.service
echo "Syncthing autostart enabled and started for 'myuser'."
