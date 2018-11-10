#!/bin/bash
echo 'Starting the installation of OCP'
echo 'set log_plays to true'
export ANSIBLE_LOG_PATH=/var/log/ansible.log
echo '*******************RUN PLAYBOOK****************'
ansible-playbook -v -f 20 homework.yaml
