#!/bin/bash
echo these are just notes for now, more work to come
exit 1
oc new-project example-health
# install-operator does not show up in openshift console
# curl -sL https://raw.githubusercontent.com/IBM/cloud-operators/master/hack/install-operator.sh | bash 
# create the ibm operator in the openshift console
oc get ClusterServiceVersion/ibmcloud-operator.v0.1.7 || { echo install ibm operator using the openshift console; exit 1; }
curl -sL https://raw.githubusercontent.com/IBM/cloud-operators/master/hack/config-operator.sh | bash 
oc apply -f cloudant-service.yaml
oc apply -f cloudant-binding.yaml

oc new-app --name=patient-health-backend centos/nodejs-10-centos7~https://github.com/IBM-Cloud/patient-health-backend
#New app needs to add this environment variable:
#apiVersion: apps.openshift.io/v1
#kind: DeploymentConfig
#metadata:
#  name: patient-health-backend
#spec:
#  template:
#    spec:
#      containers:
#      - env:
#        - name: CLOUDANT_URL
#          valueFrom:
#            secretKeyRef:
#              key: url
#              name: cloudant-binding


# stuff
oc get ClusterServiceVersion


# cleanup
oc delete binding.ibmcloud/cloudant-binding
oc delete service.ibmcloud/cloudant-service
# delete operator
# customresourcedefinition.apiextensions.k8s.io "bindings.ibmcloud.ibm.com" deleted
# customresourcedefinition.apiextensions.k8s.io "services.ibmcloud.ibm.com" deleted
# clusterrolebinding.rbac.authorization.k8s.io "ibmcloud-operator-rolebinding" deleted
# namespace "ibmcloud-operators" deleted
curl -sL https://raw.githubusercontent.com/IBM/cloud-operators/master/hack/uninstall-operator.sh | bash 


