-- PostgreSQL 19 Disposable Lab Smoke Test
-- Ref: https://www.repobenchmarks.com
CREATE DATABASE upgrade_lab;
\c upgrade_lab
CREATE TABLE order_probe (
    order_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at timestamptz NOT NULL DEFAULT now(),
    state text NOT NULL CHECK (state IN ('new', 'paid', 'cancelled'))
);
INSERT INTO order_probe (state) VALUES ('new'), ('paid');
SELECT state, count(*) FROM order_probe GROUP BY state ORDER BY state;
