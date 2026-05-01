#!/usr/bin/env bash
set -euxo pipefail

if command -v waagent >/dev/null 2>&1; then
  waagent -force -deprovision+user
fi

truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
sync
