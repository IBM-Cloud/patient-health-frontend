#!/bin/bash
# The following steps need application load, this script will generate some
# Step 3 - Logging and monitoring
# Step 4 - Metrics and dashboards
# Step 5 - Scaling the application

set -e -o pipefail
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $MYDIR/config.sh
source $MYDIR/share.sh

HOST=$(frontend_url)
echo HOST=$HOST
curl -s $HOST/info
while sleep 0.2; do
  curl -s $HOST/info
done
