#!/usr/bin/env bash
echo "delete CICD demo projects"
oc delete project dev
oc delete project stage
oc delete project cicd
