#!/usr/bin/env bash
#==========Limit Ranges and HPA=============
oc new-project test-hpa

#Deploy hello-openshift in the new project:
oc new-app openshift/hello-openshift:v3.9 -n test-hpa
oc expose svc hello-openshift

echo '{
    "kind": "LimitRange",
    "apiVersion": "v1",
    "metadata": {
        "name": "limits",
        "creationTimestamp": null
    },
    "spec": {
        "limits": [
            {
                "type": "Pod",
                "max": {
                    "cpu": "100m",
                    "memory": "750Mi"
                },
                "min": {
                    "cpu": "10m",
                    "memory": "5Mi"
                }
            },
            {
                "type": "Container",
                "max": {
                    "cpu": "100m",
                    "memory": "750Mi"
                },
                "min": {
                    "cpu": "10m",
                    "memory": "5Mi"
                },
                "default": {
                    "cpu": "50m",
                    "memory": "100Mi"
                }
            }
        ]
    }
}' | oc create -f - -n test-hpa

#Show Limitrange
oc get limitrange
#Display Limitrange
#oc describe limitrange <limits name>
oc describe limitrange limits

#Autoscale
oc autoscale dc/hello-openshift --min 1 --max 5 --cpu-percent=80

#Test autoscale
oc get hpa/hello-openshift -n test-hpa

#Describe Autoscale
oc describe hpa/hello-openshift -n test-hpa

#Redeploy after LimitRange
oc rollout latest hello-openshift -n test-hpa


#Get App URL and generate load using curl
ROUTE="http://"$(oc get route hello-openshift --template "{{ .spec.host }}")
  for time in {1..15000}
    do
     echo time $time
     curl ${ROUTE}
    done

#//////////////////////////////
#===========NEED TO DEBUG THIS PLAY============#
# Failing at first task as it is not able to find tasks.
# - name: HPA Configuration on Production Deployment of openshift-tasks
#   hosts: localhost
#   tasks:
#     - name: Set CPU request for autoscaler
oc project tasks-prod
oc set resources dc/tasks --requests=cpu=100m

#     - name: Configure autoscaler for openshift-tasks
oc project tasks-prod;
oc autoscale dc/tasks --min 1 --max 4 --cpu-percent=80

#=========================TASKS-PROD======================

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
                    "cpu": "1000m",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "50m",
                    "memory": "256Mi"
                }
            },
            {
                "type": "Container",
                "max": {
                    "cpu": "1000m",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "50m",
                    "memory": "256Mi"
                },
                "default": {
                    "cpu": "100m",
                    "memory": "512Mi"
                }
            }
        ]
    }
}' | oc create -f - -n tasks-prod


#oc describe limitrange <limits name>
oc describe limitrange tasks-hpa

#To delete the existing limit Ranges
#oc delete limitrange tasks-hpa

#Autoscale
oc autoscale dc/tasks --min 1 --max 5 --cpu-percent=80
#To delete autoscale for the app <use app number>
#oc delete hpa tasks

#Test autoscale
oc get hpa/tasks -n tasks-prod

#Describe Autoscale
oc describe hpa/tasks -n tasks-prod

#Redeploy after LimitRange
oc rollout latest tasks -n tasks-prod

#Get App URL and generate load using curl
sudo -i
ROUTE="http://"$(oc get route tasks --template "{{ .spec.host }}")
  for time in {1..15000}
    do
     echo time $time
     curl ${ROUTE}
    done


#describe deployment config for tasks app
oc describe dc/tasks
#================================================================
#Autoscalling without using limitrange (eg: tasks-hpa)
#1. Set Limitrange for HPA for the project.
#2. Set autoscale for the app under the project.
#3. rollout the app
#4. check whether CPU limit needs to set separetly or not like below command
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
                    "cpu": "1000m",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "50m",
                    "memory": "256Mi"
                }
            },
            {
                "type": "Container",
                "max": {
                    "cpu": "1000m",
                    "memory": "4Gi"
                },
                "min": {
                    "cpu": "50m",
                    "memory": "256Mi"
                },
                "default": {
                    "cpu": "100m",
                    "memory": "512Mi"
                }
            }
        ]
    }
}' | oc create -f - -n tasks-prod

oc project tasks-prod
oc set resources dc/tasks --requests=cpu=100m
oc autoscale dc/tasks --min 1 --max 5 --cpu-percent=80
oc rollout latest tasks -n tasks-prod

#================================================================
