#!/bin/bash

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
