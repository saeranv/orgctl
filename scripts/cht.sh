#!/bin/bash

CHT_FPATH="$(realpath "$0")"
CHT_DPATH="/mnt/c/users/admin/master/orgmode/cht"


helpcmd=$(python -c 'print("""cht [-tag] [-fn] [-p] [-cat] [-ls] [-h]
Note: Pass full filepath (i.e. fpath) for cht to work on any files
Examples: 
   cht                       , lsr $chtd
   cht vim -                 , cat $chtd/vim.md
   cht vim                   , nvim +$ $chtd/vim.md 
   cht -vim                  , opens cht.sh in vim
""")')

openv () {
    chtf=$1
    if [[ "$#" -eq 1 ]]; then
        nvim $chtf +":exe 'normal! 60%'"
    else 
        nvim $chtf +"/${@:2}"
    fi
}

# Handle positional args
if [[ "$#" -eq 0 ]]; then
    # 0 args
    ls $CHT_DPATH;
else 
    # >0 args 
    # Assign $chtf if exists and remove from arglist 
    if [[ $1 != -* ]]; then
        # if first char NOT -
        # eg $ cht osm OR cht osm -  
        if [[ "$#" -eq 1 ]]; then
            # eg $ cht osm
            arg1="-cat"
            args=("${@:2}")
        else 
            # eg $ cht osm -
            arg1="-vim"
            args=("${@:3}")
        fi
        chtf="$CHT_DPATH/$1.md"
    else
        arg1="$1"
        args=("${@:2}")
        chtf="$CHT_FPATH"
    fi

    # Handle flags
    if [[ "$arg1" == "-ls" ]]; then
        ls "$CHT_DPATH"
    elif [[ "$arg1" == "-h" ]]; then
        echo -e "$helpcmd"
    elif [[ "$arg1" == "-vim" ]]; then
        openv $chtf $args 
    elif [[ "$arg1" == "-cat" ]]; then
        cat $chtf
    else
        echo "command $@ not recognized."
        echo -e "$helpcmd"
    fi
fi
