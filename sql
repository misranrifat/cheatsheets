# Comprehensive SQL Cheatsheet

## Table of Contents
- [Basic SQL Commands](#basic-sql-commands)
- [Data Types](#data-types)
- [Database Management](#database-management)
- [Table Operations](#table-operations)
- [Querying Data](#querying-data)
- [Sorting and Filtering](#sorting-and-filtering)
- [Join Operations](#join-operations)
- [Aggregate Functions](#aggregate-functions)
- [Grouping Data](#grouping-data)
- [Subqueries](#subqueries)
- [Views](#views)
- [Indexes](#indexes)
- [Transactions](#transactions)
- [Users and Permissions](#users-and-permissions)
- [Advanced Functions](#advanced-functions)
- [Common Table Expressions (CTEs)](#common-table-expressions-ctes)
- [Window Functions](#window-functions)
- [Stored Procedures and Functions](#stored-procedures-and-functions)
- [Triggers](#triggers)
- [Performance Optimization](#performance-optimization)
- [SQL Dialect Differences](#sql-dialect-differences)
- [Command Line Tools](#command-line-tools)

## Basic SQL Commands

### DDL (Data Definition Language)
```sql
CREATE DATABASE database_name;
CREATE TABLE table_name (column_definitions);
ALTER TABLE table_name ADD column_name datatype;
DROP TABLE table_name;
TRUNCATE TABLE table_name;
```

### DML (Data Manipulation Language)
```sql
SELECT column1, column2 FROM table_name;
INSERT INTO table_name (column1, column2) VALUES (value1, value2);
UPDATE table_name SET column1 = value1 WHERE condition;
DELETE FROM table_name WHERE condition;
```

### DCL (Data Control Language)
```sql
GRANT privilege ON object TO user;
REVOKE privilege ON object FROM user;
```

### TCL (Transaction Control Language)
```sql
BEGIN TRANSACTION; -- or START TRANSACTION or just BEGIN
COMMIT;
ROLLBACK;
SAVEPOINT savepoint_name;
ROLLBACK TO savepoint_name;
```

## Data Types

### Common Data Types
| Category | Types |
|----------|-------|
| **Numeric** | INT, TINYINT, SMALLINT, MEDIUMINT, BIGINT, DECIMAL(p,s), NUMERIC(p,s), FLOAT, DOUBLE |
| **String** | CHAR(n), VARCHAR(n), TEXT, TINYTEXT, MEDIUMTEXT, LONGTEXT |
| **Date/Time** | DATE, TIME, DATETIME, TIMESTAMP, YEAR |
| **Binary** | BINARY, VARBINARY, BLOB, TINYBLOB, MEDIUMBLOB, LONGBLOB |
| **Boolean** | BOOLEAN, BOOL |
| **Other** | JSON (MySQL 5.7+), ENUM, SET, UUID |

### PostgreSQL Specific
```sql
-- Array data type
CREATE TABLE inventory (
    id INT,
    item_names TEXT[],
    item_prices DECIMAL(10,2)[]
);

-- JSON data types
CREATE TABLE documents (
    id INT,
    data JSON, 
    data_b JSONB  -- Binary JSON format, more efficient
);
```

## Database Management

### Create Database
```sql
CREATE DATABASE database_name
    [WITH [OWNER = role_name]
          [ENCODING = encoding]
          [LC_COLLATE = collation]
          [LC_CTYPE = character_type]
          [TABLESPACE = tablespace_name]
          [CONNECTION LIMIT = max_connections]];
```

### Drop Database
```sql
DROP DATABASE [IF EXISTS] database_name;
```

### Backup & Restore

#### PostgreSQL
```bash
# Backup
pg_dump dbname > outfile.sql

# Restore
psql dbname < infile.sql
```

#### MySQL
```bash
# Backup
mysqldump -u username -p database_name > backup_file.sql

# Restore
mysql -u username -p database_name < backup_file.sql
```

## Table Operations

### Create Table
```sql
CREATE TABLE table_name (
    column1 datatype [constraints],
    column2 datatype [constraints],
    ...,
    [table_constraints]
);
```

### Common Constraints
```sql
NOT NULL        -- Column cannot contain NULL values
UNIQUE          -- All values in column must be unique
PRIMARY KEY     -- NOT NULL and UNIQUE combined
FOREIGN KEY     -- Enforces referential integrity
CHECK           -- Ensures values meet a condition
DEFAULT         -- Sets default value for column
```

### Example Create Table
```sql
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE DEFAULT CURRENT_DATE,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

### Alter Table
```sql
-- Add column
ALTER TABLE table_name ADD column_name datatype [constraints];

-- Drop column
ALTER TABLE table_name DROP COLUMN column_name;

-- Modify column
ALTER TABLE table_name ALTER COLUMN column_name TYPE new_datatype;  -- PostgreSQL
ALTER TABLE table_name MODIFY column_name new_datatype;             -- MySQL

-- Rename column
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;

-- Add constraint
ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition;

-- Drop constraint
ALTER TABLE table_name DROP CONSTRAINT constraint_name;
```

### Drop Table
```sql
DROP TABLE [IF EXISTS] table_name [CASCADE | RESTRICT];
```

### Truncate Table
```sql
TRUNCATE TABLE table_name [CASCADE | RESTART IDENTITY];
```

## Querying Data

### Basic SELECT
```sql
SELECT column1, column2, ... FROM table_name;
SELECT * FROM table_name;  -- Select all columns
```

### Column Aliases
```sql
SELECT column_name AS alias_name FROM table_name;
SELECT column_name alias_name FROM table_name;  -- AS is optional
```

### Distinct Values
```sql
SELECT DISTINCT column_name FROM table_name;
SELECT COUNT(DISTINCT column_name) FROM table_name;
```

### Limiting Results
```sql
-- MySQL, PostgreSQL, SQLite
SELECT column_name FROM table_name LIMIT count [OFFSET skip];

-- SQL Server
SELECT TOP count column_name FROM table_name;
SELECT column_name FROM table_name OFFSET skip ROWS FETCH NEXT count ROWS ONLY;

-- Oracle
SELECT column_name FROM table_name WHERE ROWNUM <= count;
SELECT column_name FROM table_name OFFSET skip ROWS FETCH NEXT count ROWS ONLY;  -- 12c+
```

## Sorting and Filtering

### ORDER BY
```sql
SELECT column1, column2 FROM table_name ORDER BY column1 [ASC|DESC], column2 [ASC|DESC];
```

### WHERE Clause
```sql
SELECT column1, column2 FROM table_name WHERE condition;
```

### Comparison Operators
```sql
=       -- Equal to
<>      -- Not equal to (also written as !=)
<       -- Less than
>       -- Greater than
<=      -- Less than or equal to
>=      -- Greater than or equal to
```

### Logical Operators
```sql
AND     -- All conditions must be true
OR      -- At least one condition must be true
NOT     -- Negates a condition
```

### Pattern Matching
```sql
-- LIKE operator
SELECT * FROM table_name WHERE column_name LIKE 'pattern';
-- % matches any sequence of characters
-- _ matches any single character

-- ILIKE for case-insensitive matching (PostgreSQL)
SELECT * FROM table_name WHERE column_name ILIKE 'pattern';

-- Regular expressions (PostgreSQL)
SELECT * FROM table_name WHERE column_name ~ 'regex_pattern';
SELECT * FROM table_name WHERE column_name ~* 'case_insensitive_regex';
```

### NULL Values
```sql
SELECT * FROM table_name WHERE column_name IS NULL;
SELECT * FROM table_name WHERE column_name IS NOT NULL;
```

### IN and BETWEEN
```sql
-- IN operator
SELECT * FROM table_name WHERE column_name IN (value1, value2, ...);
SELECT * FROM table_name WHERE column_name IN (SELECT column_name FROM another_table);

-- BETWEEN operator
SELECT * FROM table_name WHERE column_name BETWEEN value1 AND value2;
```

### CASE Expression
```sql
SELECT column1,
    CASE
        WHEN condition1 THEN result1
        WHEN condition2 THEN result2
        ...
        ELSE result_else
    END AS derived_column
FROM table_name;
```

## Join Operations

### Types of Joins
```sql
-- INNER JOIN
SELECT * FROM table1 INNER JOIN table2 ON table1.column = table2.column;

-- LEFT JOIN (or LEFT OUTER JOIN)
SELECT * FROM table1 LEFT JOIN table2 ON table1.column = table2.column;

-- RIGHT JOIN (or RIGHT OUTER JOIN)
SELECT * FROM table1 RIGHT JOIN table2 ON table1.column = table2.column;

-- FULL JOIN (or FULL OUTER JOIN)
SELECT * FROM table1 FULL JOIN table2 ON table1.column = table2.column;

-- CROSS JOIN
SELECT * FROM table1 CROSS JOIN table2;

-- Self Join
SELECT a.column, b.column 
FROM table_name a 
JOIN table_name b ON a.common_column = b.common_column;
```

### Join Example
```sql
SELECT 
    e.employee_id, 
    e.first_name, 
    e.last_name, 
    d.department_name
FROM 
    employees e
INNER JOIN 
    departments d ON e.department_id = d.department_id;
```

## Aggregate Functions

### Common Aggregate Functions
```sql
COUNT()     -- Returns the number of rows
SUM()       -- Returns the sum of values
AVG()       -- Returns the average of values
MIN()       -- Returns the minimum value
MAX()       -- Returns the maximum value
```

### Examples
```sql
SELECT 
    COUNT(*) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary
FROM 
    employees;
```

## Grouping Data

### GROUP BY
```sql
SELECT 
    column1, 
    aggregate_function(column2) 
FROM 
    table_name 
GROUP BY 
    column1;
```

### HAVING
```sql
SELECT 
    column1, 
    aggregate_function(column2) 
FROM 
    table_name 
GROUP BY 
    column1 
HAVING 
    condition;
```

### Example
```sql
SELECT 
    department_id,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM 
    employees
GROUP BY 
    department_id
HAVING 
    COUNT(*) > 5;
```

## Subqueries

### Single Value Subquery
```sql
SELECT column_name 
FROM table_name 
WHERE column_name = (SELECT column_name FROM table_name WHERE condition);
```

### Multiple Values Subquery
```sql
SELECT column_name 
FROM table_name 
WHERE column_name IN (SELECT column_name FROM table_name WHERE condition);
```

### Correlated Subquery
```sql
SELECT a.column_name
FROM table1 a
WHERE a.column_name > (
    SELECT AVG(b.column_name)
    FROM table1 b
    WHERE b.group_column = a.group_column
);
```

### Subquery in FROM Clause
```sql
SELECT column_name
FROM (SELECT column_name FROM table_name WHERE condition) AS derived_table;
```

### Exists Subquery
```sql
SELECT column_name
FROM table1
WHERE EXISTS (SELECT 1 FROM table2 WHERE table2.column = table1.column);
```

## Views

### Create View
```sql
CREATE [OR REPLACE] VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Drop View
```sql
DROP VIEW [IF EXISTS] view_name;
```

### Materialized Views (PostgreSQL)
```sql
-- Create materialized view
CREATE MATERIALIZED VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW view_name;
```

## Indexes

### Create Index
```sql
CREATE INDEX index_name ON table_name (column1, column2, ...);
```

### Create Unique Index
```sql
CREATE UNIQUE INDEX index_name ON table_name (column1, column2, ...);
```

### Create Partial Index (PostgreSQL)
```sql
CREATE INDEX index_name ON table_name (column_name) WHERE condition;
```

### Drop Index
```sql
DROP INDEX [IF EXISTS] index_name;  -- PostgreSQL, SQLite
DROP INDEX index_name ON table_name;  -- MySQL
DROP INDEX table_name.index_name;  -- SQL Server
```

## Transactions

### Basic Transaction
```sql
BEGIN TRANSACTION;  -- or BEGIN WORK or just BEGIN
    -- SQL statements here
COMMIT;  -- or COMMIT WORK
```

### Transaction with Rollback
```sql
BEGIN TRANSACTION;
    -- SQL statements here
    IF condition THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
```

### Savepoints
```sql
BEGIN TRANSACTION;
    -- SQL statements
    SAVEPOINT savepoint_name;
    -- More SQL statements
    ROLLBACK TO savepoint_name;  -- Rollback to savepoint
    -- Continue with more statements
COMMIT;
```

### Transaction Isolation Levels
```sql
-- PostgreSQL, SQL Server
SET TRANSACTION ISOLATION LEVEL {
    READ UNCOMMITTED |
    READ COMMITTED |
    REPEATABLE READ |
    SERIALIZABLE
};

-- MySQL
SET SESSION TRANSACTION ISOLATION LEVEL {
    READ UNCOMMITTED |
    READ COMMITTED |
    REPEATABLE READ |
    SERIALIZABLE
};
```

## Users and Permissions

### Create User
```sql
-- PostgreSQL
CREATE USER username WITH PASSWORD 'password';

-- MySQL
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```

### Grant Permissions
```sql
-- PostgreSQL
GRANT ALL PRIVILEGES ON DATABASE database_name TO username;
GRANT SELECT, INSERT, UPDATE, DELETE ON table_name TO username;

-- MySQL
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'host';
GRANT SELECT, INSERT, UPDATE, DELETE ON database_name.table_name TO 'username'@'host';
```

### Revoke Permissions
```sql
-- PostgreSQL
REVOKE ALL PRIVILEGES ON DATABASE database_name FROM username;

-- MySQL
REVOKE ALL PRIVILEGES ON database_name.* FROM 'username'@'host';
```

### Drop User
```sql
-- PostgreSQL
DROP USER [IF EXISTS] username;

-- MySQL
DROP USER 'username'@'host';
```

## Advanced Functions

### String Functions
```sql
-- Concatenation
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;  -- MySQL, SQL Server
SELECT first_name || ' ' || last_name AS full_name FROM employees;  -- PostgreSQL, SQLite

-- Substring
SELECT SUBSTRING(column_name, start, length) FROM table_name;  -- MySQL, SQL Server
SELECT SUBSTR(column_name, start, length) FROM table_name;  -- Oracle, SQLite
SELECT SUBSTRING(column_name FROM start FOR length) FROM table_name;  -- PostgreSQL

-- Upper/Lower case
SELECT UPPER(column_name), LOWER(column_name) FROM table_name;

-- String length
SELECT LENGTH(column_name) FROM table_name;  -- PostgreSQL, MySQL, SQLite
SELECT LEN(column_name) FROM table_name;  -- SQL Server
```

### Date and Time Functions
```sql
-- Current date and time
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;  -- PostgreSQL, SQLite
SELECT CURDATE(), CURTIME(), NOW();  -- MySQL
SELECT GETDATE();  -- SQL Server
SELECT SYSDATE;  -- Oracle

-- Date arithmetic
SELECT DATEADD(unit, value, date);  -- SQL Server
SELECT DATE_ADD(date, INTERVAL value unit);  -- MySQL
SELECT date + INTERVAL 'value unit';  -- PostgreSQL

-- Extract parts of dates
SELECT EXTRACT(YEAR FROM date_column) FROM table_name;  -- PostgreSQL, MySQL
SELECT YEAR(date_column) FROM table_name;  -- MySQL, SQL Server

-- Format dates
SELECT TO_CHAR(date_column, 'YYYY-MM-DD') FROM table_name;  -- PostgreSQL, Oracle
SELECT DATE_FORMAT(date_column, '%Y-%m-%d') FROM table_name;  -- MySQL
SELECT FORMAT(date_column, 'yyyy-MM-dd') FROM table_name;  -- SQL Server
```

### Mathematical Functions
```sql
SELECT ABS(value);  -- Absolute value
SELECT CEILING(value);  -- Round up
SELECT FLOOR(value);  -- Round down
SELECT ROUND(value, decimals);  -- Round to specified decimal places
SELECT POWER(base, exponent);  -- Power
SELECT SQRT(value);  -- Square root
SELECT RANDOM();  -- Random value (0-1)
```

### Conditional Functions
```sql
-- COALESCE - Returns first non-null expression
SELECT COALESCE(column1, column2, 'default_value') FROM table_name;

-- NULLIF - Returns NULL if expr1 = expr2, otherwise returns expr1
SELECT NULLIF(expr1, expr2) FROM table_name;

-- GREATEST/LEAST
SELECT GREATEST(value1, value2, value3) FROM table_name;  -- PostgreSQL, MySQL
SELECT LEAST(value1, value2, value3) FROM table_name;  -- PostgreSQL, MySQL
```

## Common Table Expressions (CTEs)

### Basic CTE
```sql
WITH cte_name AS (
    SELECT column1, column2
    FROM table_name
    WHERE condition
)
SELECT * FROM cte_name;
```

### Multiple CTEs
```sql
WITH 
    cte1 AS (
        SELECT column1, column2 FROM table1
    ),
    cte2 AS (
        SELECT column1, column2 FROM table2
    )
SELECT cte1.column1, cte2.column2 
FROM cte1 
JOIN cte2 ON cte1.column1 = cte2.column1;
```

### Recursive CTE
```sql
WITH RECURSIVE cte_name AS (
    -- Base case
    SELECT column1, column2 FROM table_name WHERE condition
    
    UNION ALL
    
    -- Recursive case
    SELECT t.column1, t.column2 
    FROM table_name t
    JOIN cte_name c ON t.column1 = c.column2
)
SELECT * FROM cte_name;
```

## Window Functions

### Basic Window Function
```sql
SELECT
    column1,
    column2,
    aggregate_function(column3) OVER (PARTITION BY column1 ORDER BY column2) AS window_result
FROM table_name;
```

### Ranking Functions
```sql
SELECT
    column1,
    ROW_NUMBER() OVER (ORDER BY column2) AS row_num,
    RANK() OVER (ORDER BY column2) AS rank_val,
    DENSE_RANK() OVER (ORDER BY column2) AS dense_rank_val,
    NTILE(4) OVER (ORDER BY column2) AS quartile
FROM table_name;
```

### Window Frame Clause
```sql
SELECT
    column1,
    column2,
    AVG(column2) OVER (
        PARTITION BY column1 
        ORDER BY column2
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg
FROM table_name;
```

### Window Function Examples
```sql
-- Running total
SELECT
    order_date,
    order_amount,
    SUM(order_amount) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- Moving average
SELECT
    date,
    value,
    AVG(value) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_days
FROM daily_values;

-- Percent of total
SELECT
    category,
    sales,
    sales / SUM(sales) OVER () * 100 AS percent_of_total
FROM sales_data;
```

## Stored Procedures and Functions

### Create Function (PostgreSQL)
```sql
CREATE OR REPLACE FUNCTION function_name(parameter1 datatype, parameter2 datatype)
RETURNS return_datatype AS
$$
BEGIN
    -- Function logic here
    RETURN value;
END;
$$ LANGUAGE plpgsql;
```

### Create Procedure (PostgreSQL 11+)
```sql
CREATE OR REPLACE PROCEDURE procedure_name(parameter1 datatype, parameter2 datatype)
AS $$
BEGIN
    -- Procedure logic here
END;
$$ LANGUAGE plpgsql;
```

### Create Stored Procedure (MySQL)
```sql
DELIMITER //
CREATE PROCEDURE procedure_name(IN parameter1 datatype, OUT parameter2 datatype)
BEGIN
    -- Procedure logic here
END //
DELIMITER ;
```

### Calling Stored Procedures and Functions
```sql
-- Call a function
SELECT function_name(parameter1, parameter2);

-- Call a procedure (PostgreSQL)
CALL procedure_name(parameter1, parameter2);

-- Call a procedure (MySQL)
CALL procedure_name(@param1, @param2);
```

## Triggers

### Create Trigger (PostgreSQL)
```sql
CREATE OR REPLACE TRIGGER trigger_name
BEFORE|AFTER|INSTEAD OF INSERT|UPDATE|DELETE ON table_name
FOR EACH ROW
EXECUTE FUNCTION function_name();
```

### Create Trigger (MySQL)
```sql
DELIMITER //
CREATE TRIGGER trigger_name
BEFORE|AFTER INSERT|UPDATE|DELETE ON table_name
FOR EACH ROW
BEGIN
    -- Trigger logic here
END //
DELIMITER ;
```

## Performance Optimization

### Analyzing Queries
```sql
-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM table_name WHERE condition;

-- MySQL
EXPLAIN SELECT * FROM table_name WHERE condition;
```

### Table Statistics
```sql
-- PostgreSQL
ANALYZE table_name;

-- MySQL
ANALYZE TABLE table_name;
```

### Index Suggestions
```sql
-- PostgreSQL
SELECT * 
FROM pg_stat_activity 
WHERE state = 'active';

-- MySQL
SHOW PROFILE FOR QUERY query_id;
```

## SQL Dialect Differences

### String Concatenation
```sql
-- PostgreSQL, SQLite, Oracle
SELECT column1 || ' ' || column2 FROM table_name;

-- MySQL, SQL Server
SELECT CONCAT(column1, ' ', column2) FROM table_name;
```

### Limit vs Top
```sql
-- PostgreSQL, MySQL, SQLite
SELECT * FROM table_name LIMIT 10;

-- SQL Server
SELECT TOP 10 * FROM table_name;

-- Oracle
SELECT * FROM table_name WHERE ROWNUM <= 10;
```

### Auto-increment
```sql
-- PostgreSQL
CREATE TABLE table_name (
    id SERIAL PRIMARY KEY,
    column1 datatype
);

-- MySQL
CREATE TABLE table_name (
    id INT AUTO_INCREMENT PRIMARY KEY,
    column1 datatype
);

-- SQL Server
CREATE TABLE table_name (
    id INT IDENTITY(1,1) PRIMARY KEY,
    column1 datatype
);
```

## Command Line Tools

### PostgreSQL Command Line
```bash
# Connect to database
psql -U username -d database_name

# List databases
\l

# Connect to a database
\c database_name

# List tables
\dt

# Describe table
\d table_name

# Execute SQL from file
\i file_name.sql

# Exit
\q
```

### MySQL Command Line
```bash
# Connect to database
mysql -u username -p database_name

# List databases
SHOW DATABASES;

# Use a database
USE database_name;

# List tables
SHOW TABLES;

# Describe table
DESCRIBE table_name;

# Execute SQL from file
SOURCE file_name.sql;

# Exit
EXIT;
```
