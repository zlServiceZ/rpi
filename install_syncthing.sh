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
# File name
file="$HOME/.config/syncthing/config.xml"

# Search pattern and replacement
old_address="127.0.0.1:34313"
new_address="0.0.0.0:34313"

# Use sed to replace the search pattern
sed -i "s|<address>$old_address</address>|<address>$new_address</address>|g" "$file"
echo "Created config files successfully"

# reboot necessary
echo "Do you want to reboot the system now? (Y/N)"
read choice

if [[ $choice == "Y" || $choice == "y" ]]; then
    echo "Rebooting the system..."
    sudo reboot
elif [[ $choice == "N" || $choice == "n" ]]; then
    echo "Skipping reboot. Please reboot manually when ready."
else
    echo "Invalid choice. Please enter Y/y or N/n."
fi
