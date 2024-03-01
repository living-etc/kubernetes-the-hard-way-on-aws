#! /usr/bin/env bash

set -euo pipefail

KUBERNETES_PUBLIC_ADDRESS=$(
  aws --profile kthw elbv2 describe-load-balancers \
    --names "controllers" \
    --query "LoadBalancers[0].DNSName" \
    --output text
)

echo "${KUBERNETES_PUBLIC_ADDRESS}"
