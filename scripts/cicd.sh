#!/usr/bin/env bash

echo "Create Tasks project"
oc new-project tasks-dev --display-name="Tasks - Dev"

echo "Create Stage project"
oc new-project tasks-test --display-name="Tasks - Test"

echo "Create Prod project"
oc new-project tasks-prod --display-name="Tasks - Prod"

echo "Create CI/CD project"
oc new-project cicd-dev --display-name="CI/CD"

echo "Set serviceaccount status for CI/CD project for dev, stage and prod projects"
oc policy add-role-to-group edit system:serviceaccounts:cicd-dev -n tasks-dev
oc policy add-role-to-group edit system:serviceaccounts:cicd-dev -n tasks-test
oc policy add-role-to-group edit system:serviceaccounts:cicd-dev -n tasks-prod

echo "Start application deployment to trigger CI/CD workflow"
#Testing with Jenkins PVC - by creating app upfront.
oc new-app jenkins-persistent
oc new-app -n cicd-dev -f /root/shan-ocp-dep-hw-v2/cicd_template.yaml

echo "Sleep for 5 minutes  to allow to build cicd-dev"
sleep 5m

echo "Test Pipeline - oc start-build tasks-pipeline"
oc start-build tasks-pipeline


#Autoscalling without using limitrange
echo "HPA for Production Environment"
echo "Sleep for 10 minutes  to allow to deploy to Prod"
sleep 10m

#================================================================
#Autoscalling without using limitrange (eg: tasks-hpa)
#1. Set Limitrange for HPA for the project.
#2. Set autoscale for the app under the project.
#3. rollout the app
#4. check whether CPU limit needs to set separetly or not like below command
oc project tasks-prod
echo '{
    "kind": "LimitRange",
    "apiVersion": "v1",
    "metadata": {
        "name": "tasks-hpa",
        "creationTimestamp": null
    },
    "spec": {
        "limits": [
            {
                "type": "Pod",
                "max": {
                    "cpu": "2",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "100m",
                    "memory": "512Mi"
                }
            },
            {
                "type": "Container",
                "max": {
                    "cpu": "2",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "100m",
                    "memory": "512Mi"
                },
                "default": {
                    "cpu": "300m",
                    "memory": "2Gi"
                },
                "defaultRequest": {
                    "cpu": "100m",
                    "memory": "512Mi"
                }
            }
        ]
    }
}' | oc create -f - -n tasks-prod

#oc project tasks-prod

oc set resources dc/tasks --requests=cpu=100m

oc autoscale dc/tasks --min 1 --max 5 --cpu-percent=80

#There is no need rollout if there is any change in config such
# as resources etc but limitrange alone needs rollout
#oc rollout latest tasks -n tasks-prod

echo "End of CICD pipeline scripts"
