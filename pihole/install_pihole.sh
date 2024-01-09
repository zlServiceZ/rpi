#!/bin/bash

sudo apt update
sudo apt upgrade -y

curl -sSL https://install.pi-hole.net | bash

# change password
pihole -a -p