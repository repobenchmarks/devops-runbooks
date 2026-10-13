#!/usr/bin/env bash
# Container-to-Host Connectivity Diagnostic Runbook
# Ref: https://www.repobenchmarks.com/2026/10/docker-container-cannot-connect-to-host.html
set -euo pipefail

TARGET_PORT="5432"

echo "==> 1. Testing DNS resolution of host.docker.internal inside container..."
docker run --rm --add-host=host.docker.internal:host-gateway alpine ping -c 1 host.docker.internal

echo "==> 2. Testing raw TCP socket reachability on port ..."
docker run --rm --add-host=host.docker.internal:host-gateway alpine nc -zv host.docker.internal "" || {
    echo "WARNING: Connection refused or timed out!"
}

echo "==> 3. Inspecting host listening interface on port ..."
if command -v ss &>/dev/null; then
    sudo ss -tulpn | grep ":" || echo "Port  is not listening on host!"
elif command -v netstat &>/dev/null; then
    sudo netstat -tulpn | grep ":" || echo "Port  is not listening on host!"
fi

echo "==> 4. Checking UFW status on docker0 interface..."
if command -v ufw &>/dev/null; then
    sudo ufw status verbose
fi
