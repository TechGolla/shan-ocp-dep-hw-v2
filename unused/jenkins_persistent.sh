#!/usr/bin/env bash

# Create new project specific for Jenkins persistent deployment and CI/CD
oc new-project cicd

# Install Jenkins with persistent storage
oc new-app jenkins-persistent

# Create dev, test, and prod environments
oc new-project cicd-dev
oc new-project cicd-test
oc new-project cicd-prod

# Give jenkins service account from cicd project privilage to edit dev, test, and prod environments
oc adm policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n cicd-dev
oc adm policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n cicd-test
oc adm policy add-role-to-user edit system:serviceaccount:cicd:jenkins -n cicd-prod

