#!/bin/bash

# $1 takes args
CDF_DPATH="$(realpath "$1")"
cd $CDF_DPATH
"$HOME/bin/_lsf"
