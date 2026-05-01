#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get -y autoremove
apt-get -y clean
rm -rf /var/lib/apt/lists/*

# Clear shell history and cloud-init instance artifacts for cleaner captures.
rm -f /root/.bash_history
rm -f /home/*/.bash_history || true
cloud-init clean || true
