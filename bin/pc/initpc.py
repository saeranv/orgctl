"""For pc cli tool.

Place in ~/.ipython/profile_default/startup/ to run on ipython start:

Currently startup script updated automatically when pc 'Usage:...'
command comes up.
```
# if profile dir doesn't exist
$ ipython profile create
$ cp $autod/initpc.py ~/.ipython/profile_default/startup/

```
"""

import os
import sys
import re
from pprint import pprint as ppp
import numpy as np
import matplotlib.pyplot as plt
# import pandas as pd
import functools as ft

# Globals
ORGD = "/mnt/c/users/admin/masterwin/orgmode"
args = sys.argv[1:]
path = os.path
pp = print
inp = input
arr = np.array


# w/ list not generator (l:=list)
mapl = (lambda fn, xs: list(map(fn, xs)))
reducel = (lambda fn, xs: list(ft.reduce(fn, xs)))
filterl = (lambda fn, xs: list(filter(fn, xs)))
# # w/ closure lambdas (c:=closure)
# mapc = (lambda fn, xs: mapl(lambda x: fn(x), xs))
# reducec = (lambda fn, xs: reducel(lambda x: fn(x), xs))
# filterc = (lambda fn, xs: filterl(lambda x: fn(x), xs))


hints = '''
PTHS: orgd
PKGS: os, sys, np, plt, re
VARS: args:sys.args[1:], path:os.path
FNS:  pp:print(), inp:input(), ppp:pprint()
      mapl, reducel, filterl  # unpacks as list
      arr:np.array
'''
usage = '''
$printf "aXa X" | pc - 'pp(*mapl(lambda x:re.sub("X","Y",x), args))'
>> aYa Y
# To get rid of ipy default of printing last line, must add statement
# ';x=""' at end, i.e:
$pc - 'mapl(lambda x: pp(x), [12]);x=""'
>> 12
# Fns are inferred w/o brackets (autocall):
$pc - 'pp 4 -> pp(4)'
'''

print("For more help: `pp(hints); pp(usage);`")

if __name__ == "__main__":

    if len(args) > 0 and args[0] == "--hints":
        pp(hints); pp(usage);


