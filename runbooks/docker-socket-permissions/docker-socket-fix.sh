#!/usr/bin/env bash
# Production Runbook: Docker Socket Permission Fix
# Ref: https://www.repobenchmarks.com/2026/10/how-to-fix-docker-permission-denied.html
set -euo pipefail

echo "==> Checking Docker group membership for current user (vip)..."
if id -nG "vip" | grep -qw "docker"; then
    echo "User vip is already in the docker group."
else
    echo "Adding vip to docker group..."
    sudo usermod -aG docker "vip"
    echo "Done. Run 'newgrp docker' or log out and back in to activate."
fi

echo "==> Verifying Docker daemon socket permissions..."
SOCKET_PATH="/var/run/docker.sock"
if [ -S "" ]; then
    ls -l ""
    DOCKER_GID=
    echo "Docker socket GID is: "
else
    echo "Error: Docker socket not found at . Is dockerd running?"
    exit 1
fi
