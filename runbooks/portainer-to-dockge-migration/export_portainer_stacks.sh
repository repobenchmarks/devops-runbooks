#!/usr/bin/env bash
# export_portainer_stacks.sh - Extract Stacks from Portainer to Dockge (/opt/stacks)
# Maintained by Nabil Massaoudi (https://www.repobenchmarks.com)

set -euo pipefail

PORTAINER_URL="${PORTAINER_URL:-http://localhost:9000}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-password}"
OUTPUT_DIR="${OUTPUT_DIR:-/opt/stacks}"

mkdir -p "$OUTPUT_DIR"

echo "=== RepoBenchmarks: Portainer to Dockge Stack Migrator ==="

# 1. Obtain JWT token
echo "[1/3] Authenticating with Portainer API..."
JWT_TOKEN=$(curl -s -X POST "$PORTAINER_URL/api/auth" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$ADMIN_USER\",\"password\":\"$ADMIN_PASS\"}" | grep -o '"jwt":"[^"]*' | cut -d'"' -f4)

if [ -z "$JWT_TOKEN" ]; then
    echo "ERROR: Failed to authenticate with Portainer. Check credentials."
    exit 1
fi

# 2. Fetch list of stacks
echo "[2/3] Querying stack definitions..."
STACKS_JSON=$(curl -s -X GET "$PORTAINER_URL/api/stacks" -H "Authorization: Bearer $JWT_TOKEN")

# 3. Export YAML for each stack
echo "[3/3] Exporting Compose YAML files to $OUTPUT_DIR..."
echo "$STACKS_JSON" | grep -o '{"Id":[0-9]*,"Name":"[^"]*' | while read -r line; do
    STACK_ID=$(echo "$line" | grep -o '"Id":[0-9]*' | cut -d: -f2)
    STACK_NAME=$(echo "$line" | grep -o '"Name":"[^"]*' | cut -d'"' -f4)
    
    echo "  Exporting '$STACK_NAME'..."
    mkdir -p "$OUTPUT_DIR/$STACK_NAME"
    
    curl -s -X GET "$PORTAINER_URL/api/stacks/$STACK_ID/file" \
      -H "Authorization: Bearer $JWT_TOKEN" | \
      grep -o '"StackFileContent":"[^"]*' | \
      sed 's/"StackFileContent":"//' | \
      sed 's/\\n/\n/g' | \
      sed 's/\\"/"/g' > "$OUTPUT_DIR/$STACK_NAME/compose.yaml"
done

echo "=== Migration Complete! Open Dockge to Adopt Stacks ==="
