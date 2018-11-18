#!/bin/bash
echo 'Starting the installation of OCP'
echo 'set log_plays to true'
export ANSIBLE_LOG_PATH=/var/log/ansible.log
echo '*******************RUN PLAYBOOK****************'
ansible-playbook -v -f 20 homework.yaml

# echo "Configure and Build Pipeline"
# chmod +x /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
# sh /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
#
# echo "Pipeline has been configured and first build has been started"
