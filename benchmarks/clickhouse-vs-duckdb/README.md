# ClickHouse vs. DuckDB OLAP Benchmark Stack

Production benchmark harness accompanying the technical architectural teardown on [RepoBenchmarks.com](https://www.repobenchmarks.com).

## Overview
- **DuckDB**: In-process, zero-network embedded OLAP engine running vectorized morsel-driven execution.
- **ClickHouse**: Distributed client-server columnar DBMS with MergeTree sparse index marks and high-throughput real-time streaming ingestion.

## Running the Benchmark
```bash
docker compose up -d
docker exec -it duckdb-runner python benchmark_comparison.py
```
