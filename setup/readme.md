## InSTALLATION FOR ORGMODE ENV 

# TMUX
## Install version 3.2a for compatibility w/ vim-jukit
```
TMUX_URL=https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz
TMUX_FILE=tmux-3.2a.tar.gz    
wget TMUX_URL -o TMUX_FILE
tar zxvf TMUX_FILE
```
Then cd into the unzipped 'tmux-3.2a' dir, and follow instructions in 
README to install tmux.


## NVIM
### curr-version v0.10.0-dev
### Ref: https://github.com/neovim/neovim/releases
NVIM_URL=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
NVIM_FILE=nvim-linux64.tar.gz
```
wget $NVIM_URL
tar xzvf NVIM_FILE 
. ./nvim-linux64/bin/nvim
```

## NVIM-LSP
### Ref:
### https://github.com/pappasam/jedi-language-server
### https://github.com/python-lsp/python-lsp-server/tree/develop#installation

### To install python requirements:
pip install -r $orgd/auto/setup_env/nvim_lsp_requirements.txt


## VISUDO
### Run `sudo visudo`
### Add:
```
Defaults editor="/usr/bin/nvim"
...
saeranv ALL=(ALL) NOPASSWD: /mnt/c/users/admin/masterwin/orgmode/auto/vpn/serve_vpnkit.sh
```

















