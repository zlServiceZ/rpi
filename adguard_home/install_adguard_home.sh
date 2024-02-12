#!/bin/bash

sudo apt update
sudo apt upgrade -y

curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v