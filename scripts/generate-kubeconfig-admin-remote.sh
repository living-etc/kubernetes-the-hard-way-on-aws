#! /usr/bin/env bash

set -euo pipefail

KUBECONFIG_PATH=kubeconfig
TLS_PATH=tls

ALB_DNS_NAME=$(
  aws --profile kthw elbv2 describe-load-balancers \
    --names "controllers" \
    --query "LoadBalancers[0].DNSName" \
    --output text
)

kubectl config set-cluster kthw-aws \
  --certificate-authority=${TLS_PATH}/ca.pem \
  --embed-certs=true \
  --server=https://${ALB_DNS_NAME}:6443

kubectl config set-credentials admin-aws \
  --client-certificate=${TLS_PATH}/admin.pem \
  --client-key=${TLS_PATH}/admin-key.pem \

kubectl config set-context kthw-aws \
  --cluster=kthw-aws \
  --user=admin-aws

kubectl config use-context kthw-aws
