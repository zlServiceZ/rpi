#!/bin/bash

echo "Disable LEDs"

text_to_append="# Turn off the LEDs
dtparam=pwr_led_trigger=default-on # The default
dtparam=pwr_led_activelow=off
dtparam=act_led_trigger=default-on # The default
dtparam=act_led_activelow=off"

echo "$text_to_append" | sudo tee -a /boot/config.txt > /dev/null

echo "Disabled LEDs"

# reboot is necessary
source "$HOME/rpi/tools/restart.sh"