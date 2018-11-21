#!/usr/bin/env bash
echo "delete CICD demo projects"
oc delete project dev
oc delete project stage
oc delete project prod
oc delete project cicd

chmod +x /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
sh /root/shan-ocp-dep-hw-v2/scripts/cicd.sh
