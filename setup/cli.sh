#!/bin/bash
# Run with: ./utils.sh
set -e   
SETUP_DPATH="$(dirname "$0")"

# OHMYZSH
## Download ohmyzsh from https://github.com/ohmyzsh/ohmyzsh
ZSHRC_FPATH="$SETUP_DPATH/../tilda/.zshrc"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
## Remove .zshrc they make
mv ~/.zshrc ~/.zshrc_ohmyzsh
ln -s $ZSHRC_FPATH ~/.zshrc
 
# Add zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
# Add fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Disable git tracking
git config --global oh-my-zsh.hide-info 1   # git_prompt_info
git config --global oh-my-zsh.hide-status 1 # git_prompt_status
git config --global oh-my-zsh.hide-dirty 1  # parse_git_dirty

# TRASH
sudo apt install trash-cli