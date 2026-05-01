#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release

install -d -m 0755 /etc/apt/keyrings
if [[ ! -f /etc/apt/keyrings/microsoft.gpg ]]; then
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
  chmod 0644 /etc/apt/keyrings/microsoft.gpg
fi

cat >/etc/apt/sources.list.d/azure-cli.list <<EOF

deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main
EOF

apt-get update
apt-get install -y --no-install-recommends azure-cli

az version
