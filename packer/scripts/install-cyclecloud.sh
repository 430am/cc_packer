#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends curl gnupg2 python3 python3-pip openjdk-8-jre

install -d -m 0755 /etc/apt/keyrings
if [[ ! -f /etc/apt/keyrings/microsoft.gpg ]]; then
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
  chmod 0644 /etc/apt/keyrings/microsoft.gpg
fi

cat >/etc/apt/sources.list.d/cyclecloud.list <<'EOF'

deb [signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/cyclecloud stable main
EOF

apt-get update
apt-get install -y --no-install-recommends cyclecloud8

python3 -m pip install --upgrade pip
python3 -m pip install --no-cache-dir cyclecloud-cli

cyclecloud --version || true
dpkg -s cyclecloud8 | grep -E '^Version:'
