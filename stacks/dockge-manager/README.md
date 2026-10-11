# Dockge Production Stack & Portainer Migration Harness

Production deployment for Dockge container stack manager, paired with an automated zero-downtime migration runbook for extracting stacks from Portainer's internal database.

Accompanies the technical comparison on [RepoBenchmarks.com](https://www.repobenchmarks.com).

## Quick Start
```bash
sudo mkdir -p /opt/dockge/data /opt/stacks
docker compose up -d
```
Access dashboard at `http://localhost:5001`.
