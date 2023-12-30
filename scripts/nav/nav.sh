#!/usr/bin/zsh

# Source in ~/.alias
# Don't use cdr - it is builtin 

# cdr: change working directory to working directory from history
# pushd
# popd
# dirs

_ls_fn () {
    # -h for human readable sizes, -p for filedir ending with /
    if [ "$#" -eq 0 ]; then 
        ls -h -p -s --group-directories-first . 
    else 
        ls -h -p -s --group-directories-first "$@"
    fi
}

lsf () {
    # lsr c ./tmp
    if [ "$#" -eq 0 ]; then
        _ls_fn
    else
        _ls_fn "$@"
    fi
}

cdf () { 
    cd $@ && _ls_fn 
}

