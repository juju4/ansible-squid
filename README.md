[![Actions Status - Main](https://github.com/juju4/ansible-squid/workflows/AnsibleCI/badge.svg)](https://github.com/juju4/ansible-squid/actions?query=branch%3Amain)
[![Actions Status - Devel](https://github.com/juju4/ansible-squid/workflows/AnsibleCI/badge.svg?branch=devel)](https://github.com/juju4/ansible-squid/actions?query=branch%3Adevel)

# Squid ansible role

Ansible role to setup a secure and clean Squid proxy with
* Dansguardian for url filtering (port 8080)
* clamav daemon for malware scanning (through dansguardian)
* ads filtering (through dansguardian)
* squid after (port 3128)

On centos, for now, only have squidGuard (configuration as work in progress).
HTTPS supported only on centos as Ubuntu squid is missing compilation flags.

## Requirements & Dependencies

### Ansible
It was tested on the following versions:
 * 1.9
 * 2.0
 * 2.2
 * 2.5
 * 2.10

### Operating systems

Tested Ubuntu 16.04, 18.04, 20.04 and centos7-8

On RedHat family, EPEL is required. You can use juju4.redhat_epel role.

## Example Playbook

Just include this role in your list.
For example

```
- host: all
  roles:
    - juju4.squid
```

## Variables

Nothing specific for now.

## Continuous integration

This role has a travis basic test (for github), more advanced with kitchen and also a Vagrantfile (test/vagrant).

Once you ensured all necessary roles are present, You can test with:
```
$ cd /path/to/roles/juju4.squid
$ kitchen verify
$ kitchen login
```
or
```
$ cd /path/to/roles/juju4.squid/test/vagrant
$ vagrant up
$ vagrant ssh
```

## Troubleshooting & Known issues

* squidguard EPEL bug
https://bugzilla.redhat.com/show_bug.cgi?id=1253662

* HTTPS support for squid depends on compilation option. Centos7 has it but not Ubuntu/Debian (bionic or focal)
Debian: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=898307 (license issue; buster with squid-4 and gnutls)
Ubuntu: https://bugs.launchpad.net/ubuntu/+source/squid3/+bug/16669 (addressed in 18.10+ with squid-4 and gnutls support but missing --enable-security-cert-generators)
Squid 4.1-4.11: ["SSL-Bump and certificate generation features are not yet supported by GnuTLS builds."](http://www.squid-cache.org/Versions/v4/RELEASENOTES.html#ss2.8)
Squid 5.0: [No mention](https://github.com/squid-cache/squid/blob/master/ChangeLog)

* [How to fix X509_V_ERR_UNABLE_TO_GET_ISSUER_CERT_LOCALLY Squid error](https://docs.diladele.com/faq/squid/fix_unable_to_get_issuer_cert_locally.html)

* HTTPS squid build failing on Ubuntu 22.04
```
/bin/bash ../../libtool  --tag=CXX   --mode=compile g++ -DHAVE_CONFIG_H -DDEFAULT_CONFIG_FILE=\"/etc/squid/squid.conf\" -DDEFAULT_SQUID_DATA_DIR=\"/usr/share/squid\" -DDEFAULT_SQUID_CONFIG
_DIR=\"/etc/squid\"   -I../.. -I../../include -I../../lib -I../../src -I../../include  -isystem /usr/include/mit-krb5  -Wdate-time -D_FORTIFY_SOURCE=2 -I/usr/include/libxml2 -Wall -Wpointe
r-arith -Wwrite-strings -Wcomments -Wshadow -Woverloaded-virtual -Werror -pipe -D_REENTRANT -I/usr/include/libxml2 -I/usr/include/p11-kit-1 -g -O2 -ffile-prefix-map=/var/cache/build/squid/
squid-5.6=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security -Wno-error=deprecated-declarations -c -o Icmp.lo Icmp.cc
/bin/bash ../../libtool  --tag=CXX   --mode=compile g++ -DHAVE_CONFIG_H -DDEFAULT_CONFIG_FILE=\"/etc/squid/squid.conf\" -DDEFAULT_SQUID_DATA_DIR=\"/usr/share/squid\" -DDEFAULT_SQUID_CONFIG
_DIR=\"/etc/squid\"   -I../.. -I../../include -I../../lib -I../../src -I../../include  -isystem /usr/include/mit-krb5  -Wdate-time -D_FORTIFY_SOURCE=2 -I/usr/include/libxml2 -Wall -Wpointe
r-arith -Wwrite-strings -Wcomments -Wshadow -Woverloaded-virtual -Werror -pipe -D_REENTRANT -I/usr/include/libxml2 -I/usr/include/p11-kit-1 -g -O2 -ffile-prefix-map=/var/cache/build/squid/
squid-5.6=. -flto=auto -ffat-lto-objects -flto=auto -ffat-lto-objects -fstack-protector-strong -Wformat -Werror=format-security -Wno-error=deprecated-declarations -c -o IcmpConfig.lo IcmpC
onfig.cc
cc1plus: all warnings being treated as errors
make[5]: *** [Makefile:985: Icmp4.o] Error 1
make[5]: *** Waiting for unfinished jobs....
Icmp6.cc: In member function ‘Icmp6::SendEcho(Ip::Address&, int, char const*, int)’:
Icmp6.cc:151:11: error: array subscript ‘struct icmpEchoData[0]’ is partly outside array bounds of ‘char[282]’ [-Werror=array-bounds]
  151 |     echo->opcode = (unsigned char) opcode;
      |     ~~~~~~^~~~~~
In file included from ../../include/squid.h:81,
                 from Icmp6.cc:13:
Icmp6.cc:122:23: note: while referencing ‘Icmp6::SendEcho(Ip::Address&, int, char const*, int)::pkt’
  122 |     LOCAL_ARRAY(char, pkt, MAX_PKT6_SZ);
      |                       ^~~
```
It seems a compiler issue from https://gitlab.gnome.org/GNOME/gtk/-/issues/3776

## License

BSD 2-clause
