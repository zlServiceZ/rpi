#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/install | sudo bash