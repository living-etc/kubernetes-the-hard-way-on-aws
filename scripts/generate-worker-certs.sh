#! /usr/bin/env bash
set -euo pipefail

for instance in worker-1 worker-2 worker-3; do
  cat > "./tls/${instance}-csr.json" <<CSR
  {
    "CN": "system:node:${instance}",
    "key": {
      "algo": "rsa",
      "size": 2048
    },
    "names": [
      {
        "C": "US",
        "L": "Portland",
        "O": "system:nodes",
        "OU": "Kubernetes The Hard Way",
        "ST": "Oregon"
      }
    ]
  }
CSR

  EXTERNAL_IP=$(
    aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=${instance}" \
      --query "Reservations[*].Instances[*].PublicIpAddress" \
      --output text
  )

  INTERNAL_IP=$(
    aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=${instance}" \
      --query "Reservations[*].Instances[*].PrivateIpAddress" \
      --output text
  )

  
  cfssl gencert \
    -ca=./tls/ca.pem \
    -ca-key=./tls/ca-key.pem \
    -config=./tls/ca-config.json \
    -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
    -profile=kubernetes \
    ./tls/${instance}-csr.json | cfssljson -bare ./tls/${instance}
done
