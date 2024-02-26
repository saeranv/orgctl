#!/bin/bash
# Run with: sudo ./aptget.sh & 

# TRASH
sudo apt install trash-cli

# Install smaller packages
# Install ntp and sync time
sudo apt-get -y install ntp ntpdate
sudo ntpdate ntp.ubuntu.com

# wslu: WSL utils
sudo apt-get -y install wslu wl-clipboard
