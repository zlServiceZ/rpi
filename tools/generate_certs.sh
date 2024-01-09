#!/bin/bash

sudo apt update
sudo apt upgrade -y

sudo apt install certbot
sudo certbot certonly --standalone -d rpi.local