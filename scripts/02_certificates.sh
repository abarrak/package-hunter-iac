#!/usr/bin/env bash
set -euo pipefail

# Setup falco connection
#
LOCATION="/etc/falco/certs"

SERVER_CERT="${LOCATION}/server.crt"
SERVER_KEY="${LOCATION}/server.key"

CA_KEY="${LOCATION}/ca.key"
CA_CRT="${LOCATION}/ca.crt"
SERVER_CSR="${LOCATION}/server.csr"

echo $SERVER_KEY, $SERVER_CERT, $CA_KEY

printf "\n# Create the CA...\n"
openssl genrsa -des3 -out $CA_KEY 4096
openssl req -new -x509 -days 365 -key $CA_KEY -out $CA_CRT

printf "\n# Create the Server Key...\n"
openssl genrsa -out $SERVER_KEY 4096

printf "\n# Create the Server CSR...\n"
openssl req -new -key $SERVER_KEY -out $SERVER_CSR

printf "\n# Self-sign the Server CSR...\n"
openssl x509 -req -days 365 -in $SERVER_CSR -CA $CA_CRT -CAkey $CA_KEY -set_serial 01 -out $SERVER_CERT

cat >> /etc/falco/falco.yaml <<EOF
grpc:
  enabled: true
  bind_address: "0.0.0.0:5060"
  threadiness: 8
  private_key: "/etc/falco/certs/server.key"
  cert_chain: "/etc/falco/certs/server.crt"
  root_certs: "/etc/falco/certs/ca.crt"
EOF
