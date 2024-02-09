#!/bin/bash


# -h for human readable sizes
# -p for filedir ending with /
if [ "$#" -eq 0 ]; then 
	ls -h -p -s --group-directories-first . 
else 
    ls -h -p -s --group-directories-first "$@"
fi
