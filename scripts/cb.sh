#!/usr/bin/env sh

# Add symbolic link to bin
# ln -s ./cb.sh $HOME/bin/cb
# chmod +x $HOME/bin/cb 
is_exec() { case "$0" in */cb) : ;; esac; }

if is_exec; then set -eu; fi

case "${OSTYPE:-}$(uname)" in
 [lL]inux*) ;;
 [dD]arwin*) mac_os=1 ;;
  [cC]ygwin) win_os=1 ;;
          *) echo "Unknown operating system \"${OSTYPE:-}$(uname)\"." >&2; false ;;
esac

## SV EDIT @ 010522: Doesn't work. 
## Edited to check if $WAYLAND_DISPLAY is set.
## Alternatively, just check if wl-paste 
## or clip -selection clipboard -out works.
## is_wayland() { [ "$XDG_SESSION_TYPE" = 'wayland' ]; }
is_wayland() { [ ${WAYLAND_DISPLAY+x} ]; } 
is_xsel() { [ $(command -v xsel) ]; } 
is_mac() { [ ${mac_os-0} -ne 0 ]; }
is_win() { [ ${win_os-0} -ne 0 ]; }
if is_mac; then
  alias cbcopy=pbcopy
  alias cbpaste=pbpaste
elif is_win; then
  alias cbcopy=putclip
  alias cbpaste=getclip
else
  # SV EDIT @ 121023: xsel -i|xsel -o doesn't add newline to output 
  # like wl-copy|wl-paste does. Less annoying.
  # SV EDIT @ 191023: going back to wl-copy. Some weirdness. 
  # trim newline if this continues to be a problem w/ sed 
  if is_wayland; then
    alias cbcopy=wl-copy
    alias cbpaste=wl-paste # | sed '$ { /^$/ d}'
    # alias cbcopy='xsel -i'
    # alias cbpaste='xsel -o'
  else
    alias cbcopy='xclip -selection clipboard'
    alias cbpaste='xclip -selection clipboard -out'
  fi
fi

cb() {
  if [ -t 0 ]; then
    # stdin is connected to a terminal.
    cbpaste "$@"
  else
    cbcopy "$@"
  fi
}

if is_exec; then cb "$@"; fi
