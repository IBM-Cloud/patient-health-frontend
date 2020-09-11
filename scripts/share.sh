#!/bin/bash
# shared by other scripts, sourced
wait_jq() {
  command="$1"
  jq_expression="$2"
  total_second=$3
  sleep_interval=$4
  start=$(date +%s)
  echo -n waiting for  $command to jq -e $jq_expression
  while [[ $(date +%s) < $(($start + $total_second)) ]]; do
    if $command | jq -e "$jq_expression" > /dev/null; then
      echo
      return
    fi
    echo -n .
    sleep $sleep_interval
  done
  echo " Giving up"
  return 1
}


frontend_url() {
  echo http://$(oc get routes -o json | jq -r '.items[]|select(.metadata.name == "patient-health-frontend")|.spec.host')
}
