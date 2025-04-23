# PostgreSQL Cheatsheet

## Table of Contents
- [Connection & Authentication](#connection--authentication)
- [Database Management](#database-management)
- [Schema & Table Management](#schema--table-management)
- [Data Manipulation](#data-manipulation)
- [Querying Data](#querying-data)
- [Indexes](#indexes)
- [Transactions](#transactions)
- [Views](#views)
- [Functions & Stored Procedures](#functions--stored-procedures)
- [Triggers](#triggers)
- [Common Data Types](#common-data-types)
- [JSON/JSONB Operations](#jsonjsonb-operations)
- [Full-Text Search](#full-text-search)
- [User & Permission Management](#user--permission-management)
- [Backup & Restore](#backup--restore)
- [Performance & Monitoring](#performance--monitoring)
- [Vim Commands for PostgreSQL File Editing](#vim-commands-for-postgresql-file-editing)
- [Advanced PostgreSQL Features](#advanced-postgresql-features)
- [psql Commands](#psql-commands)
- [Configuration Settings](#configuration-settings)
- [Extensions](#extensions)

## Connection & Authentication

```sql
-- Connect to PostgreSQL
psql -h hostname -p port -U username -d database_name

-- Connect with no password prompt
export PGPASSWORD="your_password" && psql -h hostname -U username -d database_name

-- Connection string format
postgresql://username:password@hostname:port/database_name
```

## Database Management

```sql
-- List all databases
\l

-- Create database
CREATE DATABASE database_name;

-- Drop database
DROP DATABASE database_name;

-- Switch to another database
\c database_name

-- Show current database
SELECT current_database();

-- Get database size
SELECT pg_size_pretty(pg_database_size('database_name'));
```

## Schema & Table Management

```sql
-- List schemas
\dn

-- Create schema
CREATE SCHEMA schema_name;

-- List tables in current schema
\dt

-- List tables in specific schema
\dt schema_name.*

-- Show table structure
\d table_name

-- Create table
CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    amount NUMERIC(10,2)
);

-- Create table with foreign key
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    order_date DATE NOT NULL
);

-- Add column to table
ALTER TABLE table_name ADD COLUMN column_name data_type;

-- Modify column type
ALTER TABLE table_name ALTER COLUMN column_name TYPE new_data_type;

-- Drop column
ALTER TABLE table_name DROP COLUMN column_name;

-- Rename table
ALTER TABLE table_name RENAME TO new_table_name;

-- Drop table
DROP TABLE table_name;

-- Truncate table (remove all data but keep structure)
TRUNCATE TABLE table_name;
```

## Data Manipulation

```sql
-- Insert data
INSERT INTO table_name (column1, column2) VALUES ('value1', 'value2');

-- Insert multiple rows
INSERT INTO table_name (column1, column2)
VALUES 
    ('value1', 'value2'),
    ('value3', 'value4');

-- Update data
UPDATE table_name SET column1 = 'new_value' WHERE condition;

-- Delete data
DELETE FROM table_name WHERE condition;

-- Upsert (insert or update) - PostgreSQL 9.5+
INSERT INTO table_name (column1, column2)
VALUES ('value1', 'value2')
ON CONFLICT (column1) DO UPDATE
SET column2 = EXCLUDED.column2;
```

## Querying Data

```sql
-- Basic SELECT
SELECT * FROM table_name;
SELECT column1, column2 FROM table_name;

-- WHERE clause
SELECT * FROM table_name WHERE condition;

-- Common operators: =, !=, >, <, >=, <=, LIKE, IN, BETWEEN, IS NULL, IS NOT NULL

-- ORDER BY
SELECT * FROM table_name ORDER BY column_name ASC|DESC;

-- GROUP BY with aggregates
SELECT column1, COUNT(*), SUM(column2) 
FROM table_name 
GROUP BY column1;

-- HAVING (filtering for grouped data)
SELECT column1, COUNT(*) 
FROM table_name 
GROUP BY column1
HAVING COUNT(*) > 5;

-- LIMIT and OFFSET
SELECT * FROM table_name LIMIT 10 OFFSET 20;

-- Joins
SELECT a.column1, b.column2
FROM table_a a
INNER JOIN table_b b ON a.id = b.a_id;

-- Other joins: LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN

-- Subqueries
SELECT * FROM table_name 
WHERE column_name IN (SELECT column_name FROM another_table);

-- Common Table Expressions (CTE)
WITH cte_name AS (
    SELECT column1, column2 FROM table_name WHERE condition
)
SELECT * FROM cte_name;

-- Window functions
SELECT 
    column1,
    column2,
    AVG(column2) OVER (PARTITION BY column1) as avg_by_column1
FROM table_name;
```

## Indexes

```sql
-- Create index
CREATE INDEX index_name ON table_name(column_name);

-- Create multi-column index
CREATE INDEX index_name ON table_name(column1, column2);

-- Create unique index
CREATE UNIQUE INDEX index_name ON table_name(column_name);

-- Create partial index
CREATE INDEX index_name ON table_name(column_name) WHERE condition;

-- Create B-tree index (default)
CREATE INDEX index_name ON table_name USING btree (column_name);

-- Create GIN index (for arrays, jsonb)
CREATE INDEX index_name ON table_name USING gin (column_name);

-- Create GiST index (for geometric, full-text search)
CREATE INDEX index_name ON table_name USING gist (column_name);

-- Drop index
DROP INDEX index_name;

-- List all indexes
SELECT
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
```

## Transactions

```sql
-- Begin transaction
BEGIN;

-- Commit transaction
COMMIT;

-- Rollback transaction
ROLLBACK;

-- Set isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Other levels: READ UNCOMMITTED, REPEATABLE READ, SERIALIZABLE
```

## Views

```sql
-- Create view
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

-- Create materialized view
CREATE MATERIALIZED VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW view_name;

-- Drop view
DROP VIEW view_name;

-- Drop materialized view
DROP MATERIALIZED VIEW view_name;
```

## Functions & Stored Procedures

```sql
-- Create function
CREATE OR REPLACE FUNCTION function_name(param1 type, param2 type)
RETURNS return_type AS $$
BEGIN
    -- function body
    RETURN value;
END;
$$ LANGUAGE plpgsql;

-- Create procedure (PostgreSQL 11+)
CREATE OR REPLACE PROCEDURE procedure_name(param1 type, param2 type)
AS $$
BEGIN
    -- procedure body
    COMMIT;
END;
$$ LANGUAGE plpgsql;

-- Call function
SELECT function_name(value1, value2);

-- Call procedure
CALL procedure_name(value1, value2);
```

## Triggers

```sql
-- Create trigger function
CREATE OR REPLACE FUNCTION trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    -- logic here
    -- NEW refers to new row, OLD refers to old row
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER trigger_name
BEFORE INSERT OR UPDATE ON table_name
FOR EACH ROW EXECUTE FUNCTION trigger_function();

-- Drop trigger
DROP TRIGGER trigger_name ON table_name;
```

## Common Data Types

```
-- Numeric types
SMALLINT, INTEGER, BIGINT
DECIMAL, NUMERIC(precision, scale)
REAL, DOUBLE PRECISION
SERIAL, BIGSERIAL (auto-incrementing)

-- Character types
CHAR(n), VARCHAR(n), TEXT

-- Date/Time types
DATE
TIME [WITH TIME ZONE]
TIMESTAMP [WITH TIME ZONE] (TIMESTAMPTZ)
INTERVAL

-- Boolean type
BOOLEAN

-- Binary data
BYTEA

-- JSON types
JSON, JSONB

-- Array types
INTEGER[], TEXT[], etc.

-- UUID type
UUID

-- Special types
CIDR, INET, MACADDR (network addresses)
POINT, LINE, POLYGON (geometric)
TSVECTOR, TSQUERY (full-text search)
```

## JSON/JSONB Operations

```sql
-- Query JSON data
SELECT data->'user'->>'name' FROM table_name;

-- Insert JSON data
INSERT INTO table_name (json_column) VALUES ('{"key": "value"}');

-- Update JSON data
UPDATE table_name
SET json_column = json_column || '{"new_key": "new_value"}'::jsonb;

-- Check for existence of key
SELECT * FROM table_name WHERE json_column ? 'key_name';

-- Extract keys as array
SELECT jsonb_object_keys(json_column) FROM table_name;

-- Convert JSON to table format
SELECT * FROM jsonb_to_record(json_column) AS x(id int, name text);
```

## Full-Text Search

```sql
-- Create tsvector column
ALTER TABLE table_name
ADD COLUMN document_vectors TSVECTOR;

-- Create GIN index for fast searching
CREATE INDEX document_vectors_idx
ON table_name USING GIN (document_vectors);

-- Update vectors
UPDATE table_name
SET document_vectors = to_tsvector('english', title || ' ' || content);

-- Search query
SELECT * FROM table_name
WHERE document_vectors @@ to_tsquery('english', 'search & terms');

-- Rank results
SELECT *, 
  ts_rank(document_vectors, to_tsquery('english', 'search & terms')) as rank
FROM table_name
WHERE document_vectors @@ to_tsquery('english', 'search & terms')
ORDER BY rank DESC;
```

## User & Permission Management

```sql
-- Create user
CREATE USER username WITH PASSWORD 'password';

-- Create role
CREATE ROLE role_name;

-- Grant privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON table_name TO username;
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;

-- Grant role to user
GRANT role_name TO username;

-- Revoke privileges
REVOKE SELECT, INSERT ON table_name FROM username;

-- Drop user
DROP USER username;

-- List users
\du
```

## Backup & Restore

```bash
# Backup database to file
pg_dump -h hostname -U username -d database_name -f backup.sql

# Backup specific schema
pg_dump -h hostname -U username -d database_name -n schema_name -f backup.sql

# Backup in custom format (compressed)
pg_dump -h hostname -U username -d database_name -Fc -f backup.dump

# Restore from file
psql -h hostname -U username -d database_name -f backup.sql

# Restore from custom format
pg_restore -h hostname -U username -d database_name backup.dump
```

## Performance & Monitoring

```sql
-- Show running queries
SELECT pid, age(clock_timestamp(), query_start), usename, query
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start desc;

-- Kill query
SELECT pg_cancel_backend(pid);  -- graceful
SELECT pg_terminate_backend(pid);  -- forceful

-- Table stats
SELECT * FROM pg_stat_user_tables WHERE relname = 'table_name';

-- Index usage stats
SELECT * FROM pg_stat_user_indexes WHERE relname = 'table_name';

-- Database size
SELECT pg_size_pretty(pg_database_size(current_database()));

-- Table size (including indexes)
SELECT pg_size_pretty(pg_total_relation_size('table_name'));

-- Table size (excluding indexes)
SELECT pg_size_pretty(pg_relation_size('table_name'));

-- Index size
SELECT pg_size_pretty(pg_relation_size('index_name'));

-- Cache hit ratio (should be > 0.99)
SELECT 
    sum(heap_blks_read) as heap_read,
    sum(heap_blks_hit)  as heap_hit,
    sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read)) as ratio
FROM pg_statio_user_tables;

-- Analyze table (update statistics)
ANALYZE table_name;

-- Vacuum (reclaim space)
VACUUM table_name;

-- Full vacuum (requires exclusive lock)
VACUUM FULL table_name;
```

## Vim Commands for PostgreSQL File Editing

```
# Navigation
j, k, h, l - Basic movement (down, up, left, right)
gg - Go to first line
G - Go to last line
:n - Go to line n
w, b - Move forward/backward by word
0, $ - Move to beginning/end of line

# Editing
i - Insert mode before cursor
a - Insert mode after cursor
o - Open new line below and enter insert mode
O - Open new line above and enter insert mode
x - Delete character under cursor
dd - Delete current line
yy - Copy current line
p - Paste after cursor
u - Undo
Ctrl+r - Redo

# SQL-specific operations
=iB - Auto-indent an SQL block
:% !pg_format - Format entire file with pg_format (if installed)
:set syntax=sql - Ensure SQL syntax highlighting
:set expandtab shiftwidth=4 - Use spaces for tabs with 4 space indentation
:g/SELECT/ - Find all lines containing SELECT

# Search/Replace
/pattern - Search forward for pattern
?pattern - Search backward for pattern
:%s/old/new/g - Replace all occurrences of "old" with "new"
:%s/old/new/gc - Replace with confirmation

# Visual mode
v - Start visual selection
V - Select entire lines
Ctrl+v - Column selection mode

# File operations
:w - Save file
:q - Quit
:wq - Save and quit
:e filename - Edit another file
```

## Advanced PostgreSQL Features

```sql
-- Partitioning (PostgreSQL 10+)
CREATE TABLE measurements (
    logdate date not null,
    peaktemp int,
    unitsales int
) PARTITION BY RANGE (logdate);

CREATE TABLE measurements_y2020 PARTITION OF measurements
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

-- LATERAL joins
SELECT a.id, b.value
FROM a
CROSS JOIN LATERAL (
    SELECT * FROM b WHERE b.a_id = a.id LIMIT 5
) b;

-- Recursive queries
WITH RECURSIVE subordinates AS (
    SELECT employee_id, manager_id, name
    FROM employees
    WHERE name = 'Manager'
    UNION
    SELECT e.employee_id, e.manager_id, e.name
    FROM employees e
    INNER JOIN subordinates s ON s.employee_id = e.manager_id
)
SELECT * FROM subordinates;

-- Table inheritance
CREATE TABLE cities (
    name text,
    population real,
    altitude int
);

CREATE TABLE capitals (
    state char(2)
) INHERITS (cities);

-- LISTEN/NOTIFY for async messaging
-- In one session:
LISTEN channel_name;
-- In another session:
NOTIFY channel_name, 'Hello world';

-- Foreign Data Wrappers (connect to external data sources)
CREATE EXTENSION postgres_fdw;
CREATE SERVER foreign_server
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'remote_host', dbname 'remote_db', port '5432');
```

## psql Commands

```
-- General
\? - Help on psql commands
\q - Quit psql
\! command - Execute shell command
\i file - Execute commands from file
\timing - Toggle timing of commands

-- Connection
\c dbname - Connect to database
\conninfo - Display connection info

-- Output formatting
\x - Toggle expanded display
\a - Toggle between aligned/unaligned output
\H - Toggle HTML output
\t - Toggle tuples only (hide headers/footers)
\o file - Send results to file
\copy - Import/export data between table and file

-- Information
\l - List databases
\dn - List schemas
\dt - List tables
\di - List indexes
\dv - List views
\dm - List materialized views
\ds - List sequences
\df - List functions
\dT - List data types
\du - List roles/users
\dp - List access privileges
\d table_name - Describe table

-- Editor
\e - Edit command buffer with external editor (uses $EDITOR)
\ef function_name - Edit function definition
\ev view_name - Edit view definition
```

## Configuration Settings

```sql
-- View settings
SHOW ALL;
SHOW parameter_name;

-- Set parameter temporarily (session only)
SET parameter_name = 'value';

-- Common parameters to adjust:
-- shared_buffers - Memory for caching data (25% of RAM)
-- work_mem - Memory for sorting/joins (4MB default)
-- maintenance_work_mem - Memory for maintenance tasks (64MB default)
-- effective_cache_size - Estimate of disk cache (50-75% of RAM)
-- max_connections - Maximum concurrent connections
-- wal_buffers - Memory for write-ahead logging
-- checkpoint_segments - Number of WAL segments between checkpoints
-- random_page_cost - Cost estimate for random disk access
-- default_statistics_target - Statistics detail level

-- Location of postgresql.conf
SHOW config_file;
```

## Extensions

```sql
-- List available extensions
SELECT * FROM pg_available_extensions;

-- List installed extensions
\dx

-- Install extension
CREATE EXTENSION extension_name;

-- Popular extensions:
-- postgis - Geographic objects support
-- pg_stat_statements - Query performance monitoring
-- hstore - Key-value store
-- uuid-ossp - UUID generation
-- pgcrypto - Cryptographic functions
-- pg_trgm - Trigram text similarity
-- btree_gist, btree_gin - Additional index types
-- plv8 - JavaScript procedural language
-- TimescaleDB - Time-series data
-- PostGIS - Geographic objects
```
