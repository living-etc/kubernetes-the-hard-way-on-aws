#! /usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="Kubernetes-The-Hard-Way"
TLS_PATH=tls

INSTANCE_IPS=$(
  aws --profile kthw ec2 describe-instances \
    --query 'Reservations[*].Instances[*].[PublicIpAddress,PrivateIpAddress]' \
    --output text | tr '\t' ',' | tr '\n' ',' | sed 's/,$//g'
)

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

ALB_DNS_NAME=$(
  aws --profile kthw elbv2 describe-load-balancers \
    --names "controllers" \
    --query "LoadBalancers[0].DNSName" \
    --output text
)

cfssl gencert \
  -ca=${TLS_PATH}/ca.pem \
  -ca-key=${TLS_PATH}/ca-key.pem \
  -config=${TLS_PATH}/ca-config.json \
  -hostname=10.32.0.1,${INSTANCE_IPS},127.0.0.1,${KUBERNETES_HOSTNAMES},${ALB_DNS_NAME} \
  -profile=kubernetes \
  ${TLS_PATH}/kubernetes-csr.json | cfssljson -bare ${TLS_PATH}/kubernetes
