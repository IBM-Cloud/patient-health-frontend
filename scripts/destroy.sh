#!/bin/bash
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $MYDIR/config.sh

oc delete all --selector app=patient-health-frontend
oc delete all --selector app=patient-health-backend
oc delete all --all --namespace $project
oc delete project/$project


