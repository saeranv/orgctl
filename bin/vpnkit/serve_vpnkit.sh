#!/bin/bash 
set -e
_VPN_DPATH="$(realpath $(dirname "$0"))"
VPNKIT_DPATH="$_VPN_DPATH/vpnkit"
_AUTO_DPATH="$(dirname "$_VPN_DPATH")"
SESS_NAME="vpnkit"
PWSH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

#TODO: Replace with tmux/tasks.py
tmux_in_sess () {
    # if tmux session in 'tmux ls', returns name, else empty string
    # tmux ls outputs to stderr so 2>&1 pipes both to grep
    # grep -q returns grep exit code (0 if found, 1 if not)
    # $? is exit code of last command 
    tname="$1"  # tmux session name
    tmux ls 2>&1 | grep -q "$tname"
    [[ $? -eq 0 ]] && echo "$tname" || echo ""
}

tmux_make_sess () {
    sess_name="$1"
    is_tmux=$(tmux_in_sess "$sess_name") 
    if [[ $is_tmux != "$sess_name" ]]; then
        echo "Creating tmux session '$sess_name'... "
        # When in tiru_server, don't suspend
        # Instead, detach via: 'tmux detach
        # Start a new tmux session (-s) in detached mode (-d)
        # Note: new is alias for new-session 
        tmux new -d -s "$sess_name"  #1> /dev/null
    else
        echo "Tmux session '$sess_name' already exists."
    fi
}

# NOTE: tmux session created in admin, so tmux ls won't show vpnkit.
# Use tmux ls instead.
_run_vpnkit_proc () {
    # Helper to run vpnkit process
    
    # DEPRECATED
    # Stop any running vpnkits if exists
    # tmux send-keys -t "$SESS_NAME" C-c
    # Cd to correct location, run vpnkit
    # tmux send-keys -t "$SESS_NAME" "cd $VPNKIT_DPATH" ENTER
    # tmux send-keys -t "$SESS_NAME" "$VPNKIT_DPATH/run_vpnkit.sh" ENTER
    
    run_wsl_vpnkit="wsl.exe -d wsl-vpnkit --cd /app wsl-vpnkit"
    tmux send-keys -t "$SESS_NAME" "$PWSH \"$run_wsl_vpnkit\"" ENTER 
    # sleep 1 sec before output to get all visible output 
    sleep 2
}


_tmux_clean_capture_pane () {
    # Capture output, while removing blank lines at end
    rm_ln='import sys; print(*filter(lambda x: x!="\n", sys.stdin.readlines()), sep="")'
    tmux capture-pane -pt "$SESS_NAME" | python3 -c "$rm_ln"
}

start_vpnkit_sess () {
    # Only create tmux session if it exists, copied from $autod/utils.sh
    is_tmux=$(tmux_in_sess "$SESS_NAME")
    if [[ $is_tmux != "$SESS_NAME" ]]; then
        tmux_make_sess "$SESS_NAME"
        _run_vpnkit_proc
    else
        echo "Tmux session '$SESS_NAME' already exists."
    fi
}

status_vpnkit_sess () {
    is_tmux=$(tmux_in_sess "$SESS_NAME") 
    if [[ $is_tmux != "$SESS_NAME" ]]; then
        echo "tmux ls: $(tmux ls)..."
    else
        _tmux_clean_capture_pane
    fi
}


stop_vpnkit_sess () {
    # Ensure process only exist if sess exists 
    is_tmux=$(tmux_in_sess "$SESS_NAME")
    if [[ $is_tmux == "$SESS_NAME" ]]; then
        tmux kill-session -t "$SESS_NAME"
    fi
}


# Add script to visdo or else will ask for password
# user ALL=(ALL) NOPASSWD: /mnt/c/users/admin/masterwin/orgmode/auto/vpn/serve_vpnkit.sh
VPN_DPATH="$(dirname $(realpath "$0"))" # /vpn
if [[ $1 == "--start" ]]; then
    start_vpnkit_sess
    status_vpnkit_sess
elif [[ $1 == "--status" ]]; then
    # equivalent to 'tmux ls'  
    status_vpnkit_sess
elif [[ $1 == "--restart" ]]; then
    stop_vpnkit_sess
    status_vpnkit_sess 
    start_vpnkit_sess
    status_vpnkit_sess
elif [[ $1 == "--stop" ]]; then 
    stop_vpnkit_sess
    status_vpnkit_sess
else  
    echo "Usage: vpnkit [--start | --restart | --stop | --status]"
    echo "Arg not --start .. --status, recieved: $1" 
    echo "  --start: starts vpnkit if not already running, else nothing."
    echo "  --restart: kills then starts vpnkit."
    echo "  --stop: kills vpnkit."
    echo "  --status: lists admin tmux sessions, equals 'tmux ls'"
fi


