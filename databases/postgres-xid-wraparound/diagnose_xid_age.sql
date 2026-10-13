-- PostgreSQL Transaction ID (XID) Horizon & Exhaustion Diagnostics
-- Ref: https://www.repobenchmarks.com/2026/10/postgresql-transaction-id-wraparound.html

-- 1. Check database-wide XID age and transactions remaining until hard cutoff:
SELECT
    datname,
    age(datfrozenxid) AS xid_age,
    2147483648 - age(datfrozenxid) AS tx_remaining,
    pg_size_pretty(pg_database_size(datname)) AS db_size
FROM pg_database
ORDER BY age(datfrozenxid) DESC;

-- 2. Find top 20 oldest relations in current database:
SELECT
    c.oid::regclass AS table_name,
    greatest(age(c.relfrozenxid), age(t.relfrozenxid)) AS oldest_xid_age,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS total_size,
    c.relfrozenxid
FROM pg_class c
LEFT JOIN pg_class t ON c.reltoastrelid = t.oid
WHERE c.relkind = 'r'
ORDER BY oldest_xid_age DESC
LIMIT 20;

-- 3. Check for currently running anti-wraparound vacuum workers:
SELECT
    pid,
    now() - xact_start AS duration,
    query,
    state
FROM pg_stat_activity
WHERE query ILIKE '%to prevent wraparound%'
   OR query ILIKE '%vacuum%';
