#!/bin/bash

set -e
# Define some local vars
curdir="$PWD"
orgdir="/mnt/c/users/admin/masterwin/orgmode"
setdir="$orgdir/set"
autodir="$orgdir/auto"
# l28dir="$orgdir/l28"
chtdir="$orgdir/cht"
winadmindir="/mnt/c/users/admin"
python="/usr/bin/python3"

# Files to backup
# TODO: make this config w/ tasks.py
vscodedir="$winadmindir/appdata/roaming/code/user"
winterminal="$winadmindir/appdata/local/packages/"\
"microsoft.windowsterminal_8wekyb3d8bbwe/localstate/settings.json"
ipython_profile_dir="/home/saeranv/.ipython/profile_default"
backup_log_fpath="$autodir/bck/bck.log"
cron_log_fpath="$autodir/bck/cron.log"
backup_script_fpath="$autodir/bck/bck.sh"

# roamdir="/mnt/c/users/admin/AppData/Roaming"
# windir="$roamdir/Microsoft/Windows/Start Menu/Programs/Startup/"

backup_copy () {
    # WARNING: do not set anything with $HOME or ~. it will not work.
    # define using $HOME or ~ in the script itself.
    # WARNING: single quotes don't work.
    cd $autodir
    # cp -u --update  only copies if the source file is newer than the
    # destination file or if the destination file is missing.
    curr_date="$( date )"
    printf "## $(date) COPYING BACKUP\n"
    
    # # L28
    # [ ! -d "$setdir/l28" ] && mkdir "$setdir/l28"
    # cp -u -r "$l28dir/" "$setdir/l28/"
    # printf "Copied set/l28 files.\n"

    # VSCODE
    [ ! -d "$setdir/vscode" ] && mkdir "$setdir/vscode"
    cp -u "$vscodedir/keybindings.json" "$setdir/vscode/keybindings.json"
    cp -u "$vscodedir/settings.json" "$setdir/vscode/settings.json"
    printf "Copied set/vscode files.\n"
    
    # WINDOWS
    [ ! -d "$setdir/win" ] && mkdir "$setdir/win"
    cp -u "$winadmindir/.bashrc" "$setdir/win/"
    #cp -u "$winstartdir/win_start.cmd" "$setdir/win/win_start.cmd"
    #cp -u rh3dm_fpath "$setdir/win/"
    cp -u "$winterminal" "setdir/win/"
    printf "Copied set/win files.\n"

    # TILDA (/HOME/saeranv/)
    [ ! -d "$setdir/tilda" ] && mkdir "$setdir/tilda"
    [ ! -d "$setdir/tilda/.config" ] && mkdir "$setdir/tilda/.config"
    [ ! -d "$setdir/tilda/.config/nvim" ] && mkdir "$setdir/tilda/.config/nvim"
    [ ! -d "$setdir/tilda/ipython" ] && mkdir "$setdir/tilda/ipython"
    cp -u -r "$HOME/.config/nvim" "$setdir/tilda/.config"
    printf "Copied ~/.config to set/tilda/*.\n"
    
    cp -u "$ipython_profile_dir/ipython_config.py" "$setdir/tilda/ipython/"
    cp -u "$ipython_profile_dir/ipython_kernel_config.py" "$setdir/tilda/ipython/"
    cp -u -r "$ipython_profile_dir/startup" "$setdir/tilda/ipython/startup"
    printf "Copied $HOME/.ipython/profile_default to tilda/ipython.\n"

    cp -u "$HOME/.bashrc" "$setdir/tilda/"
    cp -u "$HOME/.zshrc" "$setdir/tilda/"
    cp -u "$HOME/.zshenv" "$setdir/tilda/"
    cp -u "$HOME/.alias" "$setdir/tilda/"
    cp -u "$HOME/.tmux.conf" "$setdir/tilda/"
    cp -u "$HOME/.fzf.zsh" "$setdir/tilda/"
    cp -u "/etc/wsl.conf" "$setdir/tilda/"
    printf "Copied set/tilda dot files.\n"

    # Remove vim-plugins b/c its a git submodule
    rm -rf "$setdir/tilda/.config/nvim/vim_plugins"
    printf "Removed vim_plugins git submodule from set/tilda/.\n"
    printf "Finished copying backup.\n\n"
}   

backup_commit () {
    if [ ! "$#" -eq 1 ]; then
        printf "backup_commit: requires 1 args."
    fi

    printf "## $(date) GIT ADD/COMMIT\n"
    printf "Start git add/commit.\n"

    # Extract git_dir if it's a file
    git_fpath=$(realpath "$1"); cur_dir="$PWD"
    
    [[ -d "$git_fpath" ]] && \
        git_dir="$git_fpath" || git_dir="$(dirname $git_fpath)"
    # echo "Getting dir from: $git_fpath"
    # echo "dir: $git_dir"
    cd $git_dir
    # echo "..cd-ed to git_dir: $git_dir"
    # printf "## $(date) - Git commit."
    git add $git_fpath
    printf "Added ${git_fpath}.\n"
    # git commit -m  "Automatic backup." > /dev/null
    git commit -m "Automatic backup." >> "/dev/null"
    printf "Finished git add/commit.\n"
    cd $cur_dir
}


git_log_cmd () {
    if [ ! "$#" -eq 1 ]; then
        printf "git_log_cmd: requires 1 args.\n"
    fi
    git_fpath="$1"; cur_dir="$PWD"
    cd $git_fpath
    git log --name-only -1 --oneline --pretty=format:'%h %ad %s'
    cd $cur_dir
}


backup_push () {
    if [ ! "$#" -eq 1 ]; then
        printf "backup_push: requires 1 args.\n"
    fi
    git_fpath="$1"; cur_dir="$PWD"
    [ -d "$git_fpath" ] && \
        git_dir="$git_fpath" || git_dir="$(dirname $git_fpath)"

    cd $git_dir
    printf "## $(date) GIT PUSH\n"
    git push --quiet >> '/dev/null'
    printf "Finished git push.\n\n"

    printf "## GIT LOG\n"
    git_log_cmd $git_fpath
    cd $cur_dir
}

backup_header () {
    backup_arg="$1"
    backup_pth="$(realpath $2)"
    printf "#-----------------------------------------------#\n"
    printf "# $(date)\n"
    printf "# ${backup_arg} ${backup_pth}\n"
    printf "#-----------------------------------------------#\n"
    printf "\n"
}



# Backup meta
helpcmd=$($python -c 'print("""bck [-config] [-git <path>] [-configlog|gitlog|cronlog] [-vim]
Example:
    bck -git <path>
    bck -config
    bck -gitlog <path> [--timestamp]
    bck -configlog
    bck -cronlog
    bck -vim

-git <path>: git add, commit and push
-gitlog <path> [--timstamp]: pprints git log at provided path:
    `$ git log --name-only -1 --oneline --pretty=format:\"%h %ad %s\"`
    Optional flag `--timestamp` prints current time at start.
-configlog: cats $autod/bck/bck.log
-cronlog: cats $autod/bck/cron.log
-config: backs up .config files to $orgdir/set
-vim: opens this script (bck.sh) in nvim

""")')

if [[ "$#" -eq 0 ]]; then
    echo -e "$helpcmd"
elif [[ "$1" == "-h" ]] || [[ "$1" == "--help"  ]]; then
    echo -e "$helpcmd"
elif [[ "$1" == "-configlog" ]]; then
    cat $backup_log_fpath
elif [[ "$1" == "-cronlog" ]]; then
    cat $cron_log_fpath
elif [[ "$1" == "-gitlog" ]]; then
    bck_path="$(realpath $2)"
    tc="--timestamp"
    tp=$($python -c "print('/'.join('${bck_path}'.split('/')[-2:]))")
    ts="#---------------------------\n[bck.sh at $(date) for ../${tp}]"
    echo $@ | $python -c "if '${tc}' in input().split(' '): print('${ts}')"
    git_log_cmd $bck_path
elif [[ "$1" == "-vim" ]]; then
    nvim $backup_script_fpath
elif [[ "$1" == "-git" ]]; then
    # DO NOT ADD backup_log_make here..
    # runs into conflict with stdout async
    bck_path="$(realpath $2)"
    backup_header "$1" "$bck_path" && \
        backup_commit "$bck_path" && \
        backup_push "$bck_path"
elif [[ "$1" == "-config" ]]; then
    backup_header "$1" "$orgdir" && \
        backup_copy | tee $backup_log_fpath
fi

cd $curdir
