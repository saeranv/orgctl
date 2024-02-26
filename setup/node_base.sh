#!/bin/bash 

NVM_INSTALL_SH="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh"
ZSHRC="$HOME/.zshrc"
NODE_VERSION="v20.10.0"

# Download nvm
curl -o- "$NVM_INSTALL_SH"
source "$ZSHRC"

# Install version of node
nvm install "$NODE_VERSION"

# Install neovim package
npm install -g neovim
