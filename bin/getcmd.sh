#!/bin/bash

DEFAULT_HISTORY="-15"
MAX_HISTORY="-1000"

_getcmd_help () {
    echo "Usage: getcmd [-<context>] [<num>|.]"
    echo "NOTE: getcmd ignores any cmds with 'getcmd' in it!"
    echo "NOTE: getcmd searches only last $MAX_HISTORY cmds."
    echo "getcmd -         # prints last $DEFAULT_HISTORY cmds"
    echo "getcmd - 1       # prints most recent cmd"
    echo "getcmd -100 99   # prints 99th most recent cmd"
    echo "getcmd - . | fzf # prints cmds w/o line numbers"
}

_cmdhist () {
    # cmdhist: list of cmds separated by \n.
    # fc -ln: lists most recent commands as lines  
    # grep -v  # inverse greps 'getcmd'
    # tac: reverses order of file input lines 
    # fc -ln | grep -v 'getcmd' | tac 
    # history: zsh history
    # uniq -u: remove duplicate lines
    HISTORY="$1"
    history | tail "$MAX_HISTORY" | grep -v "getcmd" | \
        cut --d=" " --f=3- | uniq -u | tail "$HISTORY"
}


if [[ "$#" == "0" ]] || \
    [[ "$#" -gt 2 ]] || \
        [[ "$1" != "-"* ]]; then

    # Help if required args are not there
    _getcmd_help

else  
    
    # Set HISTORY var
    if [[ "$1" == "-" ]]; then
        # [[ "$1" -eq "$1" ]] ~ checks if input is integer
        # so if error, assume default-context
        HISTORY=$DEFAULT_HISTORY  # context number
    else
        HISTORY="$1"
    fi 
    shift 1   # remove 1 arg 
    

    if [[ "$#" -eq 0 ]]; then
        # nl: numbers lines of file input
        # tac | nl | tac: we do this to get the most recent commands 
        #                 at the bottom
        _cmdhist $HISTORY | tac | nl | tac
    elif [[ "$1" == "." ]]; then
        _cmdhist $HISTORY
    else
        # [[ "$1" -eq "$1" ]] ~ checks if input is integer
        # line_no=$( echo "$1 + 1" | bc -l )
        # echo -n; prints w/o trailing newline 
        line_no="-$1"
        echo -n $( _cmdhist $HISTORY | tail "$line_no" | head -1 )
    fi
fi

