#!/bin/bash 

set -e 

SETUP_DPATH="$(dirname "$0")"
REQ_FPATH="$SETUP_DPATH/nvim_requirements.txt"
cd "$SETUP_DPATH"

## Loads junegunn's "vim-plug" plugin manager 
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## Install lsp packages via python
pip install -r "$REQ_FPATH"

echo "Open nvim and run"
echo "':PlugInstall :UpdatePlug :UpdateRemotePlugins' in commandline."
echo "Run :checkhealth and follow instructions to update."
