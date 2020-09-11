#!/bin/bash
set -e -o pipefail

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

$MYDIR/020-frontend.sh
$MYDIR/050-autoscale.sh
$MYDIR/060-operator-backend.sh
