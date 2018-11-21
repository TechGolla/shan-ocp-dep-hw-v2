#!/usr/bin/env bash
echo "delete CICD demo projects"
oc delete project tasks-dev
oc delete project tasks-test
oc delete project tasks-prod
oc delete project cicd

chmod +x /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
sh /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
