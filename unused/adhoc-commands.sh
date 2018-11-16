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
