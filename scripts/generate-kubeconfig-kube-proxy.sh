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

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${TLS_PATH}/ca.pem \
  --embed-certs=true \
  --server=https://${ALB_DNS_NAME}:6443 \
  --kubeconfig=${KUBECONFIG_PATH}/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=${TLS_PATH}/kube-proxy.pem \
  --client-key=${TLS_PATH}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=${KUBECONFIG_PATH}/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=${KUBECONFIG_PATH}/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=${KUBECONFIG_PATH}/kube-proxy.kubeconfig
