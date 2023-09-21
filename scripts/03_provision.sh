#!/usr/bin/env bash
set -euo pipefail

yum install -y git
mkdir /opt/package-hunter && cd /opt/package-hunter
git clone https://gitlab.com/gitlab-org/security-products/package-hunter.git .
cp falco/falco_rules.local.yaml /etc/falco/ && service falco restart
npm ci

# create a user for authenticating calls to the Package Hunter API
scripts/create-user

# run server - port 3000
DEBUG=pkgs* node src/server.js
