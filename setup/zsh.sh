#!/bin/bash
# Run with: sudo ./zsh.sh &
set -e                

# Install from apt-get
sudo apt-get -y update
sudo apt-get -y dist-upgrades
sudo apt-get -y install zsh

chsh -s $(which zsh)
echo "Check with 'echo SHELL'"
