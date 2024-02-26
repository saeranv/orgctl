#!/bin/bash

_lsf () {
    # -h for human readable sizes
    # -p for filedir ending with /
    if [ "$#" -eq 0 ]; then 
        ls -h -p -s --group-directories-first --color=always . 
    else 
        ls -h -p -s --group-directories-first --color=always "$@"
    fi
}

# lsr c ./tmp
if [ "$#" -eq 0 ]; then
	_lsf
else
    _lsf "$@"
fi
