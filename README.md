[![Build Status - Master](https://travis-ci.org/juju4/ansible-squid.svg?branch=master)](https://travis-ci.org/juju4/ansible-squid)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-squid.svg?branch=devel)](https://travis-ci.org/juju4/ansible-squid/branches)
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

### Operating systems

Tested Ubuntu 14.04, 16.04, 18.04 and centos7

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

## License

BSD 2-clause

