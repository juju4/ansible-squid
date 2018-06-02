[![Build Status - Master](https://travis-ci.org/juju4/ansible-squid.svg?branch=master)](https://travis-ci.org/juju4/ansible-squid)
[![Build Status - Devel](https://travis-ci.org/juju4/ansible-squid.svg?branch=devel)](https://travis-ci.org/juju4/ansible-squid/branches)
# Squid ansible role

Ansible role to setup a secure and clean Squid proxy with
* Dansguardian for url filtering
* clamav daemon for malware scanning
* ads filtering
On centos, for now, only have squidGuard (configuration as work in progress).

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


## License

BSD 2-clause

