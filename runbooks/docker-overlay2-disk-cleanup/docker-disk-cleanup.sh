#!/usr/bin/env bash
# docker-disk-cleanup.sh - Safe /var/lib/docker/overlay2 Emergency Space Reclaimer
# Maintained by Nabil Massaoudi (https://www.repobenchmarks.com)

set -euo pipefail

echo "=== RepoBenchmarks: Safe Docker Storage Cleanup ==="

# 1. Check disk utilization
echo "[1/4] Current Docker root disk utilization:"
df -h /var/lib/docker

# 2. Safely truncate runaway JSON container logs without stopping containers
echo "[2/4] Truncating container json logs exceeding 100MB..."
LOG_COUNT=0
for log in /var/lib/docker/containers/*/*-json.log; do
    if [ -f "" ]; then
        SIZE=0
        if [ "" -gt 104857600 ]; then
            echo "  Truncating  (Size: )..."
            truncate -s 0 ""
            LOG_COUNT=1
        fi
    fi
done
echo "  Truncated  runaway container log files."

# 3. Clean BuildKit cache
echo "[3/4] Pruning dangling Docker build cache (older than 48 hours)..."
docker builder prune --filter "until=48h" -f || true

# 4. Prune unused images and stopped containers
echo "[4/4] Pruning stopped containers and dangling images..."
docker container prune -f
docker image prune -f

echo "=== Cleanup Complete. New Disk Utilization: ==="
df -h /var/lib/docker
