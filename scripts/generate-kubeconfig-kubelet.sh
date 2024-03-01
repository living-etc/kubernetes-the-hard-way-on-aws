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

for instance in worker-1 worker-2 worker-3; do 
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=${TLS_PATH}/ca.pem \
    --embed-certs=true \
    --server=https://${ALB_DNS_NAME}:6443 \
    --kubeconfig=${KUBECONFIG_PATH}/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${TLS_PATH}/${instance}.pem \
    --client-key=${TLS_PATH}/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${KUBECONFIG_PATH}/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${KUBECONFIG_PATH}/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${KUBECONFIG_PATH}/${instance}.kubeconfig
done
