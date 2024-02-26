# Path to your oh-my-zsh installation / themes
# export ZSH=$HOME/.oh-my-zsh
# ZSH_THEME="sammy"
# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 30

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
#DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files under VCS 
# as dirty. This makes repository status check for large repositories much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
#     # fzf
#     # docker
#     # zsh-autocomplete
#     zsh-autosuggestions
#     # zsh-syntax-highlighting
#     # git
# )
# >>> setup.py >>>
# !! Contents managed by './setup.py' !!
source ~/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# <<< setup.py <<<
# Make sure to source zsh-autocomplete BEFORE compdef 
# source $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Add this line above sourcing omz to prevent .zcompdump littering $HOME dir
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"
# source $ZSH/oh-my-zsh.sh
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ---------------------------------------------------------------------------#
# --------------------------- SAERANV ENV -----------------------------------#
# ---------------------------------------------------------------------------#
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/saeranv/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/saeranv/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/saeranv/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/saeranv/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# set -a: ensure all variables are exported to child procs, so accessible to vim
# set -o physical: sets default cd behaviour to -P. This means resolves symlinks to 
# follow point to actual directory location
# set -o vi: set to vi mode
# set -o noclobber: prevents overwriting files with >
#                   overwrite with >| instead 
# set -o ignoreeof: ignore Ctrl-d which is default for logout
set -a
set -o physical
set -o vi
set -o noclobber
set -o ignoreeof
# Zsh automatically prints bg jobs to stdout making 1>&2 /dev/null 
# not work (i.e. for tutor daemon). Disable this.
setopt NO_NOTIFY NO_MONITOR
# SET ENV VARS FOR LANGUAGE / COLORS
export LANG=en_IN.UTF-8 
LC_ALL=C.UTF-8; export LC_ALL
# Explaination of colors https://askubuntu.com/a/466203
LS_COLORS=$LS_COLORS:'di=1;44:'; export LS_COLORS
# -----------------------------------------#
# VIM 
# Set vi-mode
# -----------------------------------------#
# Preferred editor for local and remote sessions

if [[ $(command -v nvim) ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi
export VISUAL="$EDITOR"

# -----------------------------------------#
# ALIASES
# -----------------------------------------#
# unalias <my_alias>: to remove alias 
# setopt aliases: to allow bash aliases to work in vim terminal
setopt aliases complete_aliases
source $aliasf

# SET TMUX ENV
if [[ "$PWD" == "$HOME" ]] || [[ "$PWD" == "" ]]; then
    cd "$orgd"
else
    cd $PWD
fi
if [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
    conda activate thermal
fi    


## NODE
# To avoid awk segfault errors, first check if node is sourced
if [[ ! $(command -v node) ]]; then
    export NVM_DIR="$HOME/.nvm"
    # Load nvm, nvm bash_completion
    [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"  
    [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  
fi
export PATH="$HOME/.nvm/versions/node/v20.3.1/bin/node/:$PATH"

# Work around https://github.com/mintty/wsltty/issues/197
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    command -v cmd.exe > /dev/null || exit
fi

# vpnkit () {
#     if [[ $1 == "-run" ]]; then
#         sudo "$autod/vpn/serve_vpnkit.sh"
#     elif [[ $1 == "-stop" ]]; then 
#         sudo tmux kill-session -t vpnkit
#     else 
#         echo "Usage: vpnkit [-run | -stop]"
#     fi
# }

# BIND-KEYS
## (this gets overwritten by some auto-complete fns, so add it here)
## zle-line-init to start new line in cmd mode by default
## zle-line-init() { zle -K vicmd; }
## zle -N zle-line-init
bindkey -M vicmd '^K'   up-line-or-history   # C-k | history up
bindkey -M vicmd '^J'   down-line-or-history # C-j | history down
# Default Tab cycles through options, don't ovewrite
# bindkey -M viins '^I'   autosuggest-accept   # Tab | accept all
bindkey -M viins '^[[Z' autosuggest-accept   # S-Tab | accept all
bindkey -M viins '^W'   complete-word        # C-w | accept word
bindkey -v '^?' backward-delete-char         # fixes backspace bug in vi mode
# bindkey -M viins '^[[Z' list-choices          # S-Tab | list choices
# bindkey -M menuselect '^I' down-line-or-beginning-search

## VERY IMPORTANT! Removes duplicate path elements (only for zsh), or else 
## every new tmux will re-add path
typeset -aU path

# Set up colors
LS_COLORS=$LS_COLORS:'di=1;44:'; export LS_COLORS
