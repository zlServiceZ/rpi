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
file_path="/etc/systemd/system/syncthing@.service"
text_to_write="[Unit]
Description=Syncthing - Open Source Continuous File Synchronization for %I
After=network.target

[Service]
User=%I
ExecStart=/usr/bin/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=multi-user.target
"

# Check if the file exists, if not, create it
if [ ! -f "$file_path" ]; then
    touch "$file_path"
fi

# Write text to the file
echo "$text_to_write" > "$file_path"

sudo systemctl daemon-reload

sudo systemctl enable syncthing@administrator.service
sudo systemctl start syncthing@administrator.service
echo "Syncthing autostart enabled and started for 'myuser'."
