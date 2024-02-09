#!/bin/bash


# lsr c ./tmp
if [ "$#" -eq 0 ]; then
	_lsf
else
    _lsf "$@"
fi
