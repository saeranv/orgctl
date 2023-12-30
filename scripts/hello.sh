#!/bin/bash

echo "Hello!"
echo "echo \$0 (hello.sh fpath):" 
echo "  $0" 
echo "echo (realpath \$0) (real hello.sh fpath):"
echo "  $(realpath $0)"
echo "echo \$1 (arg to fn): $1"
echo "echo \$! (success?): $!"
