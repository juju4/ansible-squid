#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

if [ $# != 0 ]; then
rolesdir=$1
else
rolesdir=$(dirname $0)/..
fi

[ ! -d $rolesdir/juju4.redhat_epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat_epel
[ ! -d $rolesdir/juju4.harden_apache ] && git clone https://github.com/juju4/ansible-harden-apache $rolesdir/juju4.harden_apache
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.squid ] && ln -s ansible-squid $rolesdir/juju4.squid
[ ! -e $rolesdir/juju4.squid ] && cp -R $rolesdir/ansible-squid $rolesdir/juju4.squid

## don't stop build on this script return code
true

