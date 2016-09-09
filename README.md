Ansible project template
========================

Template project for configuration management with Ansible.

Prerequisites
-------------

 - python with virtualenv for local installation of Ansible
 - vagrant for local test servers
    - vagrant requires virtualbox or other virtual host management application
 - bash to run setup automatically

Setup
-----

In bash:

    . setup.sh

 - installs and activates a local python virtual environment
 - installs Ansible and its dependencies in that virtual environment
 - sets up a virtual host for testing Ansible runs with Vagrant

Setup script can be run any number of times to update current state without side effects.

Usage
-----

Start work with either `. setup.sh` or `. local/bin/activate` to use Ansible in local context.

    ansible -i local/hosts local-test-hosts -m command -a uptime
