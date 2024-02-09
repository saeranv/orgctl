#!/bin/bash

# Runs ipython for jukit
SCRIPT="$1"
echo $SCRIPT
ipython -i -c 'import sys;script_fpath=sys.argv[4];sys.path.append("/home/saeranv/.config/nvim/vim_plugins/vim-jukit/helpers");import matplotlib;import matplotlib.pyplot as plt;matplotlib.use("module://imgcat");plt.show.__annotations__["tmux_panes"] = ["%0", "%12"];plt.show.__annotations__["save_dpi"] = 150;from IPython import get_ipython;__shell = get_ipython();__shell.run_line_magic("load_ext", "jukit_run");__shell.run_line_magic("jukit_init", f"{script_fpath} 2 --max_size=20");__shell.run_line_magic("print(script_fpath)", "");' $SCRIPT
