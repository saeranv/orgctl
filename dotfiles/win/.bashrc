export masterwin="$HOME/masterwin"
# export master="/wsl.localhost/Ubuntu/home/saeranv/master"
export gitbashf="$HOME/.bashrc"; alias gitbashf="vim $gitbashf"

# Utils
lsr () { [[ "$#" -eq 0 ]] && ls . || ls "${@}"; }
cdr () { cd "${@}" && ls .; }

# ADSK
# Add Vault binary to path
export adsk="$masterwin/adsk"
export recapml="$adsk/recap-ml/stack_recap_ml/"
export PATH="/c/Program Files/vault_1.13.1_windows_386:$PATH"
alias sam="sam.cmd"
alias towork="cd $recapml; conda activate recap-ml3"
export RECAP_ML_AUTH="$( cat $adsk/nocommit/recap-ml/lambda_auth.org )"

# OPENSTUDIO
ops34 () { "/c/openstudio-3.4.0/bin/openstudio.exe" "${@}"; }
ops36 () { "/c/openstudio-3.6.1/bin/openstudio.exe" "${@}"; }

export thermd="$masterwin/thermal"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval "$('/c/Users/admin/miniconda3/Scripts/conda.exe' 'shell.bash' 'hook')"
# <<< conda initialize <<<

conda activate ml
cd $masterwin


