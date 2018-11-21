#!/usr/bin/env bash

echo "Create Tasks project"
oc new-project tasks-dev --display-name="Tasks - Dev"

echo "Create Stage project"
oc new-project tasks-test --display-name="Tasks - Test"

echo "Create Prod project"
oc new-project tasks-prod --display-name="Tasks - Prod"

echo "Create CI/CD project"
oc new-project cicd --display-name="CI/CD"

echo "Set serviceaccount status for CI/CD project for dev, stage and prod projects"
oc policy add-role-to-group edit system:serviceaccounts:cicd -n tasks-dev
oc policy add-role-to-group edit system:serviceaccounts:cicd -n tasks-test
oc policy add-role-to-group edit system:serviceaccounts:cicd -n tasks-prod

echo "Start application deployment to trigger CI/CD workflow"
oc new-app -n cicd -f /root/shan-ocp-dep-hw-v2/cicd_template.yaml

echo "Sleep for 5 minutes  to allow to build cicd"
sleep 5m

echo "Test Pipeline - oc start-build tasks-pipeline"
oc start-build tasks-pipeline

# echo "HPA for Production Environment"
# echo "Sleep for 5 minutes  to allow to deploy to Prod"
# sleep 5m

# # Set CPU request for autoscaler
# oc project tasks-prod
# oc set resources dc tasks --requests=cpu=100m
# # Configure autoscaler for openshift-tasks
# oc project tasks-prod
# oc autoscale dc tasks --min 1 --max 4 --cpu-percent=80
