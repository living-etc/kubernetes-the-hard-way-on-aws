#! /usr/bin/env bash

set -euo pipefail

KUBECONFIG_PATH=kubeconfig
TLS_PATH=tls

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${TLS_PATH}/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=${KUBECONFIG_PATH}/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=${TLS_PATH}/admin.pem \
  --client-key=${TLS_PATH}/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=${KUBECONFIG_PATH}/admin.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=${KUBECONFIG_PATH}/admin.kubeconfig

kubectl config use-context default \
  --kubeconfig=${KUBECONFIG_PATH}/admin.kubeconfig

