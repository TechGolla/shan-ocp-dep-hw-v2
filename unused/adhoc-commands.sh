#Create new project CI/CD to host all pipeline tools
oc new-project cicd --display-name="CI/CD"
#Create new projects for DEV and STage
oc new-project dev --display-name="Tasks - Dev"
oc new-project stage --display-name="Tasks - Stage"

#Add Permissions for cicd for DEV and STAGE
oc policy add-role-to-group edit system:serviceaccounts:cicd -n dev
oc policy add-role-to-group edit system:serviceaccounts:cicd -n stage

#Build cicd project with all pipeline tools
oc new-app -n cicd -f cicd-template.yaml --param=DEPLOY_CHE=true

#To start the build pipeline
#oc start-build <pipelineName>
oc start-build tasks-pipeline

#htpasswd -b <password file> <user> <password>
htpasswd -b htpasswd.openshift admin admin

#Adding user 'admin' as cluster admin
oc adm policy add-cluster-role-to-user cluster-admin admin

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
