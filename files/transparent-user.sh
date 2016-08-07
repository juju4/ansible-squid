#!/bin/sh
##
## configure one user to use local squid transparently
##

SQUID_PORT="3128"
USER=deploy

#IF_EXT="eth0"
#IF_EXT="lxdbr0"

[ "X$USER" != "X" ] && ipt_arg="-m owner --uid-owner $USER"
[ "X$IF_EXT" != "X" ] && ipt_arg="$ipt_arg -o $IF_EXT"

# process squid user normally
iptables -t nat -m owner --uid-owner proxy -A OUTPUT -j ACCEPT
# targeted user is redirected
iptables -t nat $ipt_arg -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-port $SQUID_PORT
iptables -t nat $ipt_arg -A OUTPUT -p tcp --dport 8080 -j REDIRECT --to-port $SQUID_PORT

## delete
#iptables -L --line-numbers
#iptables -t nat -A OUTPUT -D #number#

