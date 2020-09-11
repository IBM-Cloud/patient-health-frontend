#!/bin/bash
# Step 2 - Deploying an application - create project, application, expose, display routes
set -e -o pipefail

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $MYDIR/config.sh
source $MYDIR/share.sh

echo '#' Step 2 Deploying an application

echo '#' create a new project
frontend=patient-health-frontend
ibmcloud target -g $resource_group
ibmcloud oc cluster config -c $cluster_name --admin
oc new-project $project

echo '#' create a new application
oc new-app --name=$frontend centos/nodejs-10-centos7~https://github.com/IBM-Cloud/$frontend

echo '#' wait for application pods to be replicated
wait_jq "oc get replicationcontroller --output json" \
  '.items[]|select(.metadata.labels.app == "'$frontend'")|.status.readyReplicas == 1'\
  300 5

echo '#' expose frontend
oc expose service $frontend
oc get pods

echo '#' display routes
oc get routes
HOST=$(frontend_url)
echo open $HOST
echo curl -s $HOST/info
