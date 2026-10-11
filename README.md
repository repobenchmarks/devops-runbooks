# RepoBenchmarks Production DevOps Runbooks & Configurations 🚀

[![Website](https://img.shields.io/badge/Website-repobenchmarks.com-blue)](https://www.repobenchmarks.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-brightgreen.svg)](https://github.com/repobenchmarks/devops-runbooks)

This repository contains verified, production-ready configuration templates, `docker-compose.yml` stacks, and database scripts published on **[RepoBenchmarks](https://www.repobenchmarks.com)** by **Nabil Massaoudi**.

All configurations are tested against current stable releases on Linux (Ubuntu / Debian) and macOS.

---

## 📂 Repository Structure

```text
├── docker/
│   ├── ollama-gpu/              # Ollama with NVIDIA GPU passthrough & Nginx
│   ├── vllm-inference/          # vLLM continuous batching OpenAI-compatible server
│   ├── uptime-kuma/             # Uptime Kuma monitoring stack with Caddy & Nginx
│   └── nginx-reverse-proxy/     # Hardened Nginx proxy with dynamic Docker DNS resolution
├── databases/
│   ├── postgres-pgbouncer/      # PostgreSQL 16 + PgBouncer transaction pooling
│   ├── pgvector/                # HNSW vector indexing & hybrid search SQL schemas
│   ├── sqlite-concurrency/      # WAL mode, busy timeouts, and thread-safe Python helpers
│   ├── duckdb-out-of-core/      # Memory streaming and out-of-core Parquet aggregations
│   └── valkey-dragonfly/        # Modern in-memory caching stacks replacing Redis
└── cli-configs/
    ├── fzf/                     # High-velocity shell dotfiles, bat previews, git shortcuts
    └── uv-docker/               # Multi-stage Dockerfile with Astral uv cache mount
```

---

## 🛠 Featured Stacks & Associated Guides

| Directory | Stack Components | Associated Article Guide |
| :--- | :--- | :--- |
| `docker/ollama-gpu/` | Ollama, NVIDIA Container Toolkit, Nginx | [Deploying Ollama with Docker Compose](https://www.repobenchmarks.com/2026/10/deploying-ollama-with-docker-compose.html) |
| `docker/vllm-inference/` | vLLM, PagedAttention, OpenAI API | [vLLM vs. Ollama Production Architecture](https://www.repobenchmarks.com/2026/10/vllm-vs-ollama-production-serving.html) |
| `databases/postgres-pgbouncer/`| Postgres 16, PgBouncer, Transaction Pooling | [How to Fix PostgreSQL too many clients](https://www.repobenchmarks.com/2026/10/how-to-fix-postgresql-sorry-too-many.html) |
| `databases/pgvector/` | PostgreSQL, pgvector 0.7+, HNSW | [pgvector vs. Pinecone vs. Chroma](https://www.repobenchmarks.com/2026/10/pgvector-vs-pinecone-vs-chroma.html) |
| `docker/uptime-kuma/` | Uptime Kuma, Nginx, Caddy | [Self-Hosting Uptime Kuma Guide](https://www.repobenchmarks.com/2026/10/self-hosting-uptime-kuma-complete.html) |
| `docker/nginx-reverse-proxy/`| Nginx, Docker 127.0.0.11 DNS | [How to Fix Nginx 502 Bad Gateway](https://www.repobenchmarks.com/2026/10/how-to-fix-nginx-502-bad-gateway-with.html) |

---

## 📜 License
All scripts and templates in this repository are open source and provided under the [MIT License](LICENSE).

Published by **[Nabil Massaoudi](https://www.repobenchmarks.com/p/about.html)** at [RepoBenchmarks](https://www.repobenchmarks.com).
