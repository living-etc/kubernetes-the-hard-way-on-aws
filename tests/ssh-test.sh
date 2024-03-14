#! /usr/bin/env bash

set -euo pipefail

echo "Testing SSH connection..."

for instance in controller-{1..3} worker-{1..3}
do
  ssh ${instance} true &>/dev/null
  EXIT_CODE=$?

  if [[ ${EXIT_CODE} == 0 ]];
  then
    echo "${instance}  SUCCESS"
  else
    echo "${instance}  FAILURE"
  fi
done
