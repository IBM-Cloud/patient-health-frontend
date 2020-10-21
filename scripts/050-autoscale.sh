#!/bin/bash
# Step 3 Autoscaling from the command line
set -e -o pipefail

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $MYDIR/config.sh
source $MYDIR/share.sh

frontend=patient-health-frontend
oc project $project

echo '#' patch deployment config with limits and requests
kubectl patch deploymentconfig/$frontend --type "json" -p '[{
  "op":"replace",
  "path":"/spec/template/spec/containers/0/resources",
  "value": {
    "limits": {
      "cpu": "30m",
      "memory": "100Mi"},
    "requests": {
      "cpu": "3m",
      "memory": "40Mi"}
  }}]'

echo '#' configure autoscaling
oc autoscale deploymentconfig/$frontend --name patient-hpa --min 1 --max 10 --cpu-percent=1

echo try this command to generate load:
echo $MYDIR/load.sh
