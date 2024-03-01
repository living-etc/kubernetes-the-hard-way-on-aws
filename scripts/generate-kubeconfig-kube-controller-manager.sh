#! /usr/bin/env bash

set -euo pipefail

KUBECONFIG_PATH=kubeconfig
TLS_PATH=tls

kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=${TLS_PATH}/ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=${KUBECONFIG_PATH}/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=${TLS_PATH}/kube-controller-manager.pem \
  --client-key=${TLS_PATH}/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=${KUBECONFIG_PATH}/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-controller-manager \
  --kubeconfig=${KUBECONFIG_PATH}/kube-controller-manager.kubeconfig

kubectl config use-context default \
  --kubeconfig=${KUBECONFIG_PATH}/kube-controller-manager.kubeconfig
