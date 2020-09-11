#!/bin/bash
# Step 6: Cloud operator for cloudant db, deploy backend application, connecto frontend to backend
set -e -o pipefail

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $MYDIR/config.sh
source $MYDIR/share.sh

echo '#' create the ibm operator
oc apply -f - <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibmcloud-operator
  namespace: openshift-operators
spec:
  channel: alpha
  name: ibmcloud-operator 
  source: community-operators 
  sourceNamespace: openshift-marketplace
EOF

echo '#' create the secret
curl -sL https://raw.githubusercontent.com/IBM/cloud-operators/master/hack/configure-operator.sh | bash

echo '#' create the cloudant service using the ibm operator
oc apply -f - <<EOF
apiVersion: ibmcloud.ibm.com/v1alpha1
kind: Service
metadata:
  name: $initials-cloudant-service
  namespace: example-health
spec:
  serviceClass: cloudantnosqldb
  plan: standard
EOF

echo '#' bind the secret
oc apply -f - <<EOF
apiVersion: ibmcloud.ibm.com/v1alpha1
kind: Binding
metadata:
  name: cloudant-binding
  namespace: example-health
spec:
  serviceName: $initials-cloudant-service
EOF

echo '#' create backend
github_backend=https://github.com/IBM-Cloud/patient-health-backend 
oc new-app --name=patient-health-backend centos/nodejs-10-centos7~$github_backend

echo '#' wait for secret to exist
wait_jq "oc get secrets --output json" \
  '.items[]|select(.metadata.name=="cloudant-binding")'\
  600 5

echo '#' connect backend to the cloudant using the bound secret
oc set env --from=secret/cloudant-binding --prefix CLOUDANT_ dc/patient-health-backend

echo '#' connect frontend to backend
oc set env dc/patient-health-frontend API_URL=default
HOST=$(oc get routes -o json | jq -r '.items[0].spec.host')
echo open http://$HOST
