#!/bin/bash

echo "Edit EEPROM settings"

sudo rpi-eeprom-config --edit

sed -i 's/POWER_OFF_ON_HALT=0/POWER_OFF_ON_HALT=1/'

echo "Edited EEPROM settings"

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"