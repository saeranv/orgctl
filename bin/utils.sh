#!/bin/bash

AUTO_DIR="$(dirname "$0")"  # /orgctl/scripts

tmx_in_sess () {
    # if tmux session in 'tmux ls', returns name, else empty string
    # tmux ls outputs to stderr so 2>&1 pipes both to grep
    # grep -q returns grep exit code (0 if found, 1 if not)
    # $? is exit code of last command 
    tname="$1"  # tmux session name
    tmux ls 2>&1 | grep -q "$tname"
    [[ $? -eq 0 ]] && echo "$tname" || echo ""
}

tmx_make_sess () {
    sess_name="$1"
    is_tmux=$(tmx_in_sess "$sess_name") 
    if [[ $is_tmux != "$sess_name" ]]; then
        echo "Creating tmux session '$sess_name'..."
        # When in tiru_server, don't suspend
        # Instead, detach via: 'tmux detach
        # Start a new tmux session (-s) in detached mode (-d)
        # Note: new is alias for new-session 
        tmux new -d -s "$sess_name"  #1> /dev/null
    else
        echo "Tmux session '$sess_name' exists."
    fi
}

tmxcmd () {
    if [[ $# -eq 0 ]] || \
        [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
        echo "Usage: tmuxcmd <session> <cmd>"
    else
        tmux send-keys -t $@
    fi
}

tmxview () {
    if [[ $# -eq 0 ]] || \
        [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
        echo "Usage: tmuxview <session>"
    else
        tmux capture-pane -pt $@
    fi
}

getcmd () { 
    . "$AUTO_DIR/getcmd.sh" "$@"; 
}
