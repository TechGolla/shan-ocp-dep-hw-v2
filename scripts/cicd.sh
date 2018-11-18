#!/usr/bin/env bash

echo "Create Tasks project"
oc new-project dev --display-name="Tasks - Dev"

echo "Create Stage project"
oc new-project stage --display-name="Tasks - Stage"

echo "Create CI/CD project"
oc new-project cicd --display-name="CI/CD"

echo "Set serviceaccount status for CI/CD project for dev and stage projects"
oc policy add-role-to-group edit system:serviceaccounts:cicd -n dev
oc policy add-role-to-group edit system:serviceaccounts:cicd -n stage

echo "Start application deployment to trigger CI/CD workflow"
oc new-app -n cicd -f /root/shan-ocp-dep-hw-v2/cicd_template.yaml

echo "Sleep for 60 seconds to allow to build cicd"
sleep 60s

echo "Test Pipeline - oc start-build tasks-pipeline"
oc start-build tasks-pipeline
