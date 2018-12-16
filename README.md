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
$ KITCHEN_YAML=".kitchen.vagrant.yml" kitchen verify
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

* HTTPS support for squid depends on compilation option. Centos7 has it but not Ubuntu (bionic)

* Splash page is work in progress. Only Cento7 currently and squid error
```
The splash_page helpers are crashing too rapidly, need help!
```
https://stackoverflow.com/questions/47030569/how-to-configure-a-splash-page-for-squid
https://www.linuxquestions.org/questions/linux-server-73/squid-fatal-the-basic-authenticator-helpers-are-crashing-too-rapidly-need-help-855806/

## License

BSD 2-clause

