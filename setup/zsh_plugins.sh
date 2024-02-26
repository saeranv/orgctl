#!/bin/bash
# Run with: . ./zsh_plugins.sh &

set -e   
SETUP="$(realpath $(dirname "$0"))"
ZSHRC="$SETUP/../dotfiles/zshrc.sh"
ZSH="$HOME/zsh"
# PLUGINS="$ZSH/plugins"
OHMYZSH="$HOME/.oh-my-zsh"
PLUGINS="$OHMYZSH/custom/plugins"

## Check and create directories if not exist
[[ ! -d "$ZSH" ]] && mkdir "$ZSH"
[[ ! -d "$PLUGINS" ]] && mkdir "$PLUGINS"

# # OHMYZSH
# ## Download ohmyzsh from https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# ## Remove .zshrc they make
mv ~/.zshrc ~/.zshrc_ohmyzsh
ln -sf $ZSHRC ~/.zshrc

# ## Disable git tracking
git config --global oh-my-zsh.hide-info 1   # git_prompt_info
git config --global oh-my-zsh.hide-status 1 # git_prompt_status
git config --global oh-my-zsh.hide-dirty 1  # parse_git_dirty

# PLUGINS
# ## Add zsh-autosuggestions
# AUTOSUG="$PLUGINS/zsh-autosuggestions"
# [[ -d "$AUTOSUG" ]] && rm -rf "$AUTOSUG"
# git clone \
#     "https://github.com/zsh-users/zsh-autosuggestions" \
#     "$AUTOSUG"

# echo "# >>> setup.py >>>" >> $ZSHRC
# echo "# !! Contents managed by './setup.py' !!" >> $ZSHRC
# echo "source $AUTOSUG/zsh-auto-suggestions.zsh" >> $ZSHRC
# echo "# <<< setup.py <<<" >> $ZSHRC

## Add fzf
# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# ~/.fzf/install

# echo "# <<< setup.py <<<" >> $ZSHRC


echo "Finished executing ./zsh_plugins.sh"
