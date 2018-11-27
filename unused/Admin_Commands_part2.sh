#!/usr/bin/env bash
#Get hpa on a project
oc get hpa

#Get Pvc
oc get pvc

#Node Commands
#oc describe node node1.example.com;
oc describe node node1.196d.internal

#display usage statistics about nodes
oc adm top nodes

#
#client=alpha

#Describe Deployment Configure for app "oc describe dc/<app-name>"
oc describe dc/tasks

#To export the project objects into a project.yaml file:
oc get -o yaml --export all > project.yaml

#To list all the namespaced objects:
oc api-resources --namespaced=true -o name

#role bindings for self-provisioners
oc  describe clusterrolebinding.rbac self-provisioners

#Remove the self-provisioner cluster role from the group system:authenticated:oauth.
#If the self-provisioners cluster role binding binds only the self-provisioner role
# to the system:authenticated:oauth group, run the following command:
oc patch clusterrolebinding.rbac self-provisioners -p '{"subjects": null}'

#If the self-provisioners clusterrolebinding binds the self-provisioner role to more users, groups, or serviceaccounts
#  than the system:authenticated:oauth group, run the following command:
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth

#Using Node Selectors
#Node selectors are used in conjunction with labeled nodes to control pod placement.

#Node selector to crete project in specific node based on labels of node.
oc adm new-project alphacorp \
    --node-selector='client=alpha'

oc adm new-project betacorp --node-selector='client=beta'

#To display all pods under the project and node details
oc get pods -o wide


# restart OpenShift Container Platform for the changes to take effect.
master-restart api
master-restart controllers
