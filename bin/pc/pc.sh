#!/bin/bash

# TODO: move to inv... so many subtle bugs here
# TODO: also can make initpc within the pc/tasks.py file!
# set -e
ipyd="/home/saeranv/.ipython/profile_default/"

pc () {
    autod="/mnt/c/users/admin/masterwin/orgmode/auto"
    # mlipy="/home/saeranv/miniconda3/envs/ml/bin/ipython"
    mlipy="ipython"  # this uses whatevers in env
    mlpy="/home/saeranv/miniconda3/envs/ml/bin/python"
    initpc="$autod/pc/initpc.py"
    iflag=""
    if [[ "$1" == "-" ]] || [[ "$1" == "-i" ]]; then

        # Define args
        if [[ $1 == "-i" ]]; then
            iflag="-i";
        fi
        args="${@:2}"

        # Run ipy
        # autocall=0:disable 1:smart 2: for all callable objects
        $mlipy --nosep --no-banner --autocall=1 \
            --TerminalInteractiveShell.editing_mode=vi \
            --InteractiveShell.show_rewritten_input=False \
            -c "${args}" "$iflag"
            # 1> /dev/null  # null stdout 
    else
        # Help/update
        echo 'Usage: pc [-i|-|--hints] "pp 4 "'
        # Always copy new initpc if updated.
        cp -u $initpc "$ipyd/startup/initpc.py"  # copy startup script if needed
        $mlpy $initpc --hints # runs __main__ which calls hints()
    fi
} 

