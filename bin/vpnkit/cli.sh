#!/bin/bash

# We need this file to act as intermediate cli that calls sudo so 
# vpnkit <cmd> doesn't have to be sudo vpnkit <cmd>.

VPN_DPATH="$(dirname $(realpath "$0"))"

sudo "$VPN_DPATH/serve_vpnkit.sh" "$@"
