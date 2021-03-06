#!/bin/bash
echo 'Uninstalling Openshift'

echo 'set log_plays to true'
export ANSIBLE_LOG_PATH=/var/log/ansible_uninstall.log

echo '*********RUN UNINSTALL PLAYBOOK****************'
echo '/usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml'
ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml

echo 'Delete leftovers'
ansible nodes -a "rm -rf /etc/origin"

echo 'Delete nfs server'
ansible nfs -a "rm -rf /srv/nfs/*"
