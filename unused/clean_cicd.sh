#!/usr/bin/env bash


echo "delete CICD demo projects"
oc delete project tasks-dev
oc delete project tasks-test
oc delete project tasks-prod
oc delete project cicd

oc delete limitrange tasks-hpa


rm -rf shan-ocp-dep-hw-v2/

git clone https://github.com/TechGolla/shan-ocp-dep-hw-v2
cd shan-ocp-dep-hw-v2
chmod 777 *.sh
chmod 777 ./scripts/*.sh
chmod 777 ./unused/*.sh

sh /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
