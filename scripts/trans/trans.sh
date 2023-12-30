#!/bin/bash


# Note... indents don't matter in shell scripts
helpcmd=$(python -c 'print("""trans [-] [-b]
-b = nonverbose
Note: by default -b flag is not included:
   trans - hello                        // ~ trans -b en:ta hello
   trans -r vannakkam                    // ~ trans -b ta:en vannakkam
   trans -b en:ta hello                 // ~ trans -b en:ta hello
   trans en:ta hello                    // ~ trans -verbose en:ta hello
   
examples:
   trans src:tar bonjour                // ~ trans -b src:tar bonjour 
   trans -d en:en conflict              // dict mode iff src==tar (ta not supported)    
   trans en:@zh good morning            // @ gives phonetics
   trans en:ta+@zh good morning         // translates ta & zh
   trans -p good morning              // plays translation
""")')

if [[ "$#" -eq 0 ]] || [[ "$1" == "-h" ]]; then
    echo -e "$helpcmd";
elif [[ "$1" == "-" ]]; then
    . $autod/trans/trans_src.sh -b en:ta "$@"
elif [[ "$1" == "-r" ]]; then
    . $autod/trans/trans_src.sh -b ta:en "$@"
else 
    . $autod/trans/trans_src.sh "$@"
fi

