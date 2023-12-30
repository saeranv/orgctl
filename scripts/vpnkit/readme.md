# VPNKIT 

Allows WSL2 to get around VPN DNS conflicts. 

## Installation
- follow "Setup as distro" instructions from:
- https://github.com/sakai135/wsl-vpnkit?tab=readme-ov-file

## Run wsl-vpnkit in a detached tmux session called 'vpnkit'
### Note: to check/kill/view this tmux session, you have to run 
### "sudo tmux <cmd>"; "tmux <cmd>" won't work
```
sudo tmux ls   # check if vpnkit exists
sudo ./serve_vpnkit.sh
sudo tmux capture-pane -pt   # output to current session
```


