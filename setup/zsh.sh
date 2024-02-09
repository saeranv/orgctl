#!/bin/bash
# Run with: sudo ./zsh.sh &
set -e                

# Install from apt-get
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y install zsh
sudo apt -y install wslu


chsh -s $(which zsh)
echo "Check with 'echo SHELL'"
