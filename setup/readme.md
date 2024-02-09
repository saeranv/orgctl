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


## JUKIT_REQUIREMENTS.TXT 
For jukit compatibility, just `pip install -r ...`

## FNM 
Faster node package manager (than npm)
Run this to curl and run install script that appends fnm vars/path to $zshf
```
curl -fssl https://fnm.vercel.app/install | bash 
source $zshf

# Then install v16.20.1 (for copilot compatibility) 
fnm v16.20.1/bin/node
fnm default v16.20.1

# To get the node binary path to set manually in the init.lua for copilot:
# confirm version
$(where node | head -1) --version
# save fpath to clipboard
where node | cb 

# You can also now comment out the fnm stuff in zsh. We don't need it.
```

## VISUDO
### Run `sudo visudo`
### Add:
```
Defaults editor="/usr/bin/nvim"
...
saeranv ALL=(ALL) NOPASSWD: /mnt/c/users/admin/masterwin/orgmode/auto/vpn/serve_vpnkit.sh
```

















