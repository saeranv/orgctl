#!/bin/bash 

## Ref: https://github.com/neovim/neovim/blob/master/INSTALL.md
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

## Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim


## Remove downloads
rm ./nvim.appimage
