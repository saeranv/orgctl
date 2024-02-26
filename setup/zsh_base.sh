#!/bin/bash
# Run with: sudo ./zsh.sh &

set -e   
SETUP="$(realpath $(dirname "$0"))"
ZSHRC="$SETUP/../dotfiles/zshrc.sh"


# Install from apt-get
sudo apt-get -y update
sudo apt-get -y dist-upgrade


# Install zsh separately
sudo apt-get -y install zsh
chsh -s $(which zsh)
echo "Check shell is zsh with 'echo SHELL'"

# Add symlink to ~/.zshrc
ln -sf $ZSHRC "~/.zshrc"




