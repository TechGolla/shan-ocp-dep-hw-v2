#Create Tasks project
oc new-project dev --display-name="Tasks - Dev"

#Create Stage project
oc new-project stage --display-name="Tasks - Stage"

#Create CI/CD project
oc new-project cicd --display-name="CI/CD"

#Set serviceaccount status for CI/CD project for dev and stage projects
oc policy add-role-to-group edit system:serviceaccounts:cicd dev
oc policy add-role-to-group edit system:serviceaccounts:cicd stage

#Start application deployment to trigger CI/CD workflow
oc new-app -n cicd -f cicd_template.yaml
