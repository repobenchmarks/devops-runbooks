import time
import duckdb
import clickhouse_connect

# RepoBenchmarks: ClickHouse vs. DuckDB OLAP Benchmark Runner
# Maintained by Nabil Massaoudi (https://www.repobenchmarks.com)

duck_con = duckdb.connect("analytics.duckdb")
ch_client = clickhouse_connect.get_client(host="clickhouse", port=8123, database="benchmark_db")

def benchmark_query(name, duck_sql, ch_sql):
    print(f"\n--- Benchmarking: {name} ---")
    
    t0 = time.perf_counter()
    duck_res = duck_con.execute(duck_sql).fetchall()
    duck_duration = (time.perf_counter() - t0) * 1000
    print(f"DuckDB:     {duck_duration:.2f} ms (Rows: {len(duck_res)})")

    t0 = time.perf_counter()
    ch_res = ch_client.query(ch_sql).result_rows
    ch_duration = (time.perf_counter() - t0) * 1000
    print(f"ClickHouse: {ch_duration:.2f} ms (Rows: {len(ch_res)})")

sql_query = """
SELECT 
    geo_country, 
    count(*) AS total_hits, 
    avg(response_time_ms) AS avg_latency 
FROM telemetry_events 
GROUP BY geo_country 
ORDER BY total_hits DESC 
LIMIT 10;
"""

if __name__ == '__main__':
    benchmark_query("Top Countries Aggregation", sql_query, sql_query)
