#!/usr/bin/env bash
# Emergency PostgreSQL Single-User Mode Freeze Runbook
# Ref: https://www.repobenchmarks.com/2026/10/postgresql-transaction-id-wraparound.html
set -euo pipefail

PGDATA="/var/lib/postgresql/data"
DBNAME="production_db"

echo "==> 1. Stopping PostgreSQL service..."
if command -v systemctl &>/dev/null; then
    sudo systemctl stop postgresql
else
    pg_ctl stop -D "" -m fast
fi

echo "==> 2. Launching single-user backend mode for emergency VACUUM FREEZE..."
echo "Executing: VACUUM (VERBOSE, FREEZE);"
echo "VACUUM (VERBOSE, FREEZE);" | sudo -u postgres postgres --single -D "" ""

echo "==> 3. Restarting normal PostgreSQL service..."
if command -v systemctl &>/dev/null; then
    sudo systemctl start postgresql
else
    pg_ctl start -D ""
fi

echo "==> 4. Verifying new database frozen XID age..."
sudo -u postgres psql -d "" -c "SELECT datname, age(datfrozenxid) FROM pg_database WHERE datname = '';"
echo "==> Emergency recovery complete."
