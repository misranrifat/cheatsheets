# PySpark Comprehensive Cheatsheet

## Table of Contents
- [Setup and Configuration](#setup-and-configuration)
- [SparkSession and SparkContext](#sparksession-and-sparkcontext)
- [RDD Operations](#rdd-operations)
- [DataFrame Operations](#dataframe-operations)
- [Data Types](#data-types)
- [Reading and Writing Data](#reading-and-writing-data)
- [SQL Operations](#sql-operations)
- [Data Manipulation](#data-manipulation)
- [Window Functions](#window-functions)
- [UDFs (User Defined Functions)](#udfs-user-defined-functions)
- [Machine Learning (MLlib)](#machine-learning-mllib)
- [Streaming](#streaming)
- [Optimization Techniques](#optimization-techniques)
- [Debugging and Monitoring](#debugging-and-monitoring)
- [Useful Settings](#useful-settings)
- [Vim Commands for PySpark Development](#vim-commands-for-pyspark-development)

## Setup and Configuration

### Installation
```bash
pip install pyspark
```

### Basic Setup in Python Script
```python
import findspark
findspark.init()

import pyspark
from pyspark.sql import SparkSession
```

### Environment Variables
```bash
export SPARK_HOME=/path/to/spark
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'
```

### PySpark Configuration
```python
conf = pyspark.SparkConf() \
    .setMaster("local[*]") \
    .setAppName("MyApp") \
    .set("spark.executor.memory", "2g") \
    .set("spark.driver.memory", "2g")
```

## SparkSession and SparkContext

### Creating SparkSession (Spark 2.0+)
```python
spark = SparkSession.builder \
    .appName("MyApp") \
    .master("local[*]") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()
```

### Getting SparkContext from SparkSession
```python
sc = spark.sparkContext
```

### Creating SparkContext Directly (legacy)
```python
from pyspark import SparkContext, SparkConf

conf = SparkConf().setAppName("MyApp").setMaster("local[*]")
sc = SparkContext(conf=conf)
```

### SparkSession Properties
```python
# Get all configuration properties
spark.conf.getAll()

# Set configuration
spark.conf.set("spark.sql.shuffle.partitions", 100)

# Get Spark UI URL
spark.sparkContext.uiWebUrl
```

### Stopping Session
```python
spark.stop()
```

## RDD Operations

### Creating RDDs
```python
# From a list
rdd = sc.parallelize([1, 2, 3, 4, 5])

# From a file
rdd = sc.textFile("file.txt")

# From another RDD
rdd2 = rdd.map(lambda x: x * 2)
```

### Basic RDD Transformations
```python
# Map: Apply function to each element
mapped_rdd = rdd.map(lambda x: x * 2)

# FlatMap: Map and flatten results
flat_rdd = rdd.flatMap(lambda x: [x, x*2, x*3])

# Filter: Keep elements satisfying condition
filtered_rdd = rdd.filter(lambda x: x % 2 == 0)

# Distinct: Remove duplicates
distinct_rdd = rdd.distinct()

# Sample: Randomly sample elements
sampled_rdd = rdd.sample(False, 0.5) # withReplacement, fraction

# Union: Combine two RDDs
union_rdd = rdd1.union(rdd2)

# Intersection: Elements in both RDDs
intersect_rdd = rdd1.intersection(rdd2)

# Subtract: Remove elements
diff_rdd = rdd1.subtract(rdd2)

# Cartesian product
cartesian_rdd = rdd1.cartesian(rdd2)
```

### Pair RDD Operations
```python
# Create key-value pairs
pair_rdd = rdd.map(lambda x: (x % 3, x))

# ReduceByKey: Combine values with same key
reduced = pair_rdd.reduceByKey(lambda a, b: a + b)

# GroupByKey: Group values with same key
grouped = pair_rdd.groupByKey()

# SortByKey: Sort by key
sorted_rdd = pair_rdd.sortByKey(ascending=True)

# Join: Inner join of two pair RDDs
joined = pair_rdd1.join(pair_rdd2)

# Left outer join
left_join = pair_rdd1.leftOuterJoin(pair_rdd2)

# Right outer join
right_join = pair_rdd1.rightOuterJoin(pair_rdd2)

# Full outer join
full_join = pair_rdd1.fullOuterJoin(pair_rdd2)

# Keys and values
keys_rdd = pair_rdd.keys()
values_rdd = pair_rdd.values()

# CountByKey: Count elements with same key
count_by_key = pair_rdd.countByKey()

# CollectAsMap: Collect as dictionary
as_map = pair_rdd.collectAsMap()
```

### RDD Actions
```python
# Collect: Return all elements
data = rdd.collect()

# Count: Number of elements
count = rdd.count()

# First: Get first element
first = rdd.first()

# Take: Get first n elements
first_n = rdd.take(5)

# Top: Get top n elements
top_n = rdd.top(5)

# TakeSample: Take random sample
sample = rdd.takeSample(False, 5)

# Reduce: Aggregate using a function
sum_val = rdd.reduce(lambda a, b: a + b)

# Fold: Like reduce but with initial value
sum_val = rdd.fold(0, lambda a, b: a + b)

# Aggregate: Aggregate with different return type
result = rdd.aggregate(
    0,
    lambda acc, val: acc + val,  # seqOp
    lambda acc1, acc2: acc1 + acc2  # combOp
)

# ForEach: Execute function on each element
rdd.foreach(lambda x: print(x))

# SaveAsTextFile: Save RDD to text file
rdd.saveAsTextFile("output_dir")
```

### RDD Persistence
```python
# Cache RDD in memory
rdd.cache()
# Same as
rdd.persist()

# Persist with specific storage level
from pyspark import StorageLevel
rdd.persist(StorageLevel.MEMORY_AND_DISK)

# Storage levels
# MEMORY_ONLY
# MEMORY_AND_DISK
# MEMORY_ONLY_SER
# MEMORY_AND_DISK_SER
# DISK_ONLY
# OFF_HEAP

# Unpersist
rdd.unpersist()
```

### RDD Partitioning
```python
# Get number of partitions
rdd.getNumPartitions()

# Repartition (shuffle)
repartitioned = rdd.repartition(10)

# Coalesce (minimize shuffle)
coalesced = rdd.coalesce(5)

# Custom partitioner for pair RDD
from pyspark import Partitioner

class CustomPartitioner(Partitioner):
    def __init__(self, partitions):
        self.partitions = partitions
    
    def numPartitions(self):
        return self.partitions
    
    def getPartition(self, key):
        return hash(key) % self.partitions

partitioned = pair_rdd.partitionBy(10, CustomPartitioner(10))

# Map with partition index
def func(partition_id, partition):
    return [f"Partition {partition_id}: {x}" for x in partition]

rdd.mapPartitionsWithIndex(func).collect()
```

## DataFrame Operations

### Creating DataFrames
```python
# From RDD
rdd = sc.parallelize([(1, "John"), (2, "Jane"), (3, "Bob")])
df = spark.createDataFrame(rdd, ["id", "name"])

# From lists
data = [(1, "John", 30), (2, "Jane", 25), (3, "Bob", 45)]
df = spark.createDataFrame(data, ["id", "name", "age"])

# Using schema
from pyspark.sql.types import StructType, StructField, IntegerType, StringType
schema = StructType([
    StructField("id", IntegerType(), False),
    StructField("name", StringType(), True),
    StructField("age", IntegerType(), True)
])
df = spark.createDataFrame(data, schema)

# From Pandas DataFrame
import pandas as pd
pandas_df = pd.DataFrame({"id": [1, 2, 3], "name": ["John", "Jane", "Bob"]})
df = spark.createDataFrame(pandas_df)
```

### DataFrame Basic Operations
```python
# Show data
df.show()
df.show(5, truncate=False)  # Show 5 rows, don't truncate strings

# Print schema
df.printSchema()

# Select columns
df.select("name", "age").show()
df.select(df["name"], df["age"] + 1).show()

# Add a column
from pyspark.sql.functions import lit
df = df.withColumn("country", lit("USA"))

# Rename columns
df = df.withColumnRenamed("name", "full_name")

# Drop columns
df = df.drop("country")

# Filter rows
df.filter(df["age"] > 30).show()
df.filter("age > 30").show()  # SQL-like syntax

# Distinct values
df.distinct().show()
df.select("age").distinct().show()

# Sample data
df.sample(fraction=0.5, seed=42).show()

# Count rows
df.count()

# Describe statistics
df.describe().show()
df.describe("age", "id").show()

# Sort/Order
df.sort("age").show()
df.sort(df["age"].desc()).show()
df.orderBy("age", ascending=False).show()

# Limit
df.limit(5).show()

# Convert to Pandas DataFrame
pandas_df = df.toPandas()

# Convert to RDD
rdd = df.rdd
```

### Working with Columns
```python
from pyspark.sql.functions import col, expr, lit, when, concat

# Different ways to specify columns
df.select("name").show()
df.select(df["name"]).show()
df.select(col("name")).show()
df.select(expr("name")).show()

# Column operations
df.select(
    col("name"),
    col("age") + 1,
    col("age") * 2,
    col("age") > 30
).show()

# Conditional expressions
df.select(
    "name",
    "age",
    when(df["age"] > 30, "Senior")
    .when(df["age"] > 20, "Adult")
    .otherwise("Young")
    .alias("category")
).show()

# String concatenation
df.select(
    concat(col("name"), lit(" - "), col("age").cast("string")).alias("info")
).show()
```

### Handling Missing Data
```python
# Drop rows with any null values
df.na.drop().show()

# Drop rows where specific columns have null values
df.na.drop(subset=["name", "age"]).show()

# Fill null values
df.na.fill(0).show()  # Fill all numeric columns with 0
df.na.fill({"age": 0, "name": "Unknown"}).show()  # Fill specific columns

# Replace values
df.na.replace([" ", "NULL"], ["", None]).show()
```

## Data Types

### Basic Types
```python
from pyspark.sql.types import (
    BooleanType, ByteType, ShortType, IntegerType, LongType,
    FloatType, DoubleType, DecimalType, StringType, BinaryType,
    DateType, TimestampType, ArrayType, MapType, StructType, StructField
)

# Define a complex schema
schema = StructType([
    StructField("id", IntegerType(), False),  # not nullable
    StructField("name", StringType(), True),  # nullable
    StructField("age", IntegerType(), True),
    StructField("dob", DateType(), True),
    StructField("last_update", TimestampType(), True),
    StructField("is_customer", BooleanType(), True),
    StructField("scores", ArrayType(DoubleType()), True),
    StructField("attributes", MapType(StringType(), StringType()), True),
    StructField(
        "address",
        StructType([
            StructField("street", StringType(), True),
            StructField("city", StringType(), True),
            StructField("zip", StringType(), True)
        ]),
        True
    )
])
```

### Type Casting
```python
from pyspark.sql.functions import col

# Cast column to different type
df = df.withColumn("age", col("age").cast("double"))
df = df.withColumn("age", col("age").cast(DoubleType()))

# Check column type
df.schema["age"].dataType
```

## Reading and Writing Data

### CSV Files
```python
# Read CSV
df = spark.read.csv("data.csv", header=True, inferSchema=True)
df = spark.read.format("csv") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .option("sep", ",") \
    .option("nullValue", "NA") \
    .option("dateFormat", "yyyy-MM-dd") \
    .load("data.csv")

# Write CSV
df.write.csv("output_csv", header=True)
df.write.format("csv") \
    .option("header", "true") \
    .option("sep", ",") \
    .mode("overwrite") \
    .save("output_csv")
```

### Parquet Files
```python
# Read Parquet
df = spark.read.parquet("data.parquet")
df = spark.read.format("parquet").load("data.parquet")

# Write Parquet
df.write.parquet("output_parquet")
df.write.format("parquet") \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .save("output_parquet")
```

### JSON Files
```python
# Read JSON
df = spark.read.json("data.json")
df = spark.read.format("json") \
    .option("multiLine", "true") \
    .load("data.json")

# Write JSON
df.write.json("output_json")
df.write.format("json") \
    .mode("overwrite") \
    .save("output_json")
```

### ORC Files
```python
# Read ORC
df = spark.read.orc("data.orc")
df = spark.read.format("orc").load("data.orc")

# Write ORC
df.write.orc("output_orc")
df.write.format("orc") \
    .mode("overwrite") \
    .save("output_orc")
```

### Avro Files
```python
# Read Avro (Spark 2.4+)
df = spark.read.format("avro").load("data.avro")

# Write Avro
df.write.format("avro") \
    .mode("overwrite") \
    .save("output_avro")
```

### Delta Lake
```python
# Read Delta (requires delta-core library)
df = spark.read.format("delta").load("delta_table")

# Write Delta
df.write.format("delta") \
    .mode("overwrite") \
    .save("delta_table")

# Update/Merge (using Delta Lake API)
from delta.tables import DeltaTable

deltaTable = DeltaTable.forPath(spark, "delta_table")
deltaTable.update(
    condition="id = 123",
    set={"name": "'Updated Name'", "age": "30"}
)

# Merge/Upsert
deltaTable.alias("target").merge(
    source = df.alias("source"),
    condition = "target.id = source.id"
) \
.whenMatchedUpdate(set={
    "name": "source.name",
    "age": "source.age"
}) \
.whenNotMatchedInsert(values={
    "id": "source.id",
    "name": "source.name",
    "age": "source.age"
}) \
.execute()
```

### Databases (JDBC)
```python
# Read from database
df = spark.read.format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "schema.table") \
    .option("user", "username") \
    .option("password", "password") \
    .option("driver", "org.postgresql.Driver") \
    .load()

# Read with query
df = spark.read.format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("query", "SELECT * FROM schema.table WHERE id > 100") \
    .option("user", "username") \
    .option("password", "password") \
    .load()

# Write to database
df.write.format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "schema.output_table") \
    .option("user", "username") \
    .option("password", "password") \
    .mode("overwrite") \
    .save()
```

### Save Modes
```python
# Available modes:
# - "error" or "errorifexists" (default): error if data exists
# - "append": append to data
# - "overwrite": overwrite data
# - "ignore": ignore operation if data exists

df.write.mode("overwrite").parquet("path")
df.write.mode("append").parquet("path")
```

### Partitioning
```python
# Write with partitioning
df.write.partitionBy("year", "month").parquet("path")

# Read specific partitions
df = spark.read.parquet("path/year=2023/month=01")
```

## SQL Operations

### Register and Use Tables
```python
# Register DataFrame as temp view
df.createOrReplaceTempView("people")

# Register DataFrame as global temp view
df.createOrReplaceGlobalTempView("people")

# Run SQL query on view
result = spark.sql("SELECT * FROM people WHERE age > 30")

# Access global temp view (note the prefix)
result = spark.sql("SELECT * FROM global_temp.people")
```

### SQL Queries
```python
# Basic query
result = spark.sql("""
    SELECT 
        name, 
        age, 
        CASE 
            WHEN age > 30 THEN 'Senior' 
            ELSE 'Junior' 
        END AS category
    FROM people
    WHERE age > 18
    ORDER BY age DESC
    LIMIT 10
""")

# Aggregations
result = spark.sql("""
    SELECT 
        department,
        AVG(salary) as avg_salary,
        COUNT(*) as employee_count
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 5
    ORDER BY avg_salary DESC
""")

# Joins
result = spark.sql("""
    SELECT 
        e.name, 
        e.salary, 
        d.department_name
    FROM employees e
    JOIN departments d ON e.dept_id = d.id
    WHERE e.salary > 50000
""")

# Window functions
result = spark.sql("""
    SELECT 
        name,
        department,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dept_rank
    FROM employees
""")
```

### Catalog API
```python
# List all tables
spark.catalog.listTables().show()

# List all databases
spark.catalog.listDatabases().show()

# List columns of a table
spark.catalog.listColumns("tableName").show()

# List all functions
spark.catalog.listFunctions().show()

# Check if table exists
spark.catalog.tableExists("tableName")

# Create database
spark.sql("CREATE DATABASE IF NOT EXISTS my_db")

# Use database
spark.sql("USE my_db")

# Drop table
spark.sql("DROP TABLE IF EXISTS my_table")
```

## Data Manipulation

### Basic Functions
```python
from pyspark.sql.functions import (
    col, lit, expr, concat, substring, upper, lower, 
    trim, lpad, rpad, regexp_replace, regexp_extract,
    year, month, dayofmonth, hour, minute, second,
    date_format, to_date, to_timestamp, datediff, add_months,
    round, bround, abs, sqrt, cbrt, exp, log, pow, rand,
    hash, sha1, sha2, md5, crc32,
    count, sum, avg, min, max, mean, stddev, collect_list, collect_set
)
```

### String Functions
```python
# String manipulation
df = df.select(
    col("name"),
    upper(col("name")).alias("upper_name"),
    lower(col("name")).alias("lower_name"),
    concat(col("first_name"), lit(" "), col("last_name")).alias("full_name"),
    substring(col("name"), 1, 3).alias("name_prefix"),
    trim(col("name")).alias("trimmed_name"),
    lpad(col("id").cast("string"), 5, "0").alias("id_padded"),
    regexp_replace(col("text"), "[^a-zA-Z\\s]", "").alias("clean_text"),
    regexp_extract(col("email"), "^(.*)@.*$", 1).alias("username")
)
```

### Date and Time Functions
```python
# Date manipulation
df = df.select(
    col("date"),
    year(col("date")).alias("year"),
    month(col("date")).alias("month"),
    dayofmonth(col("date")).alias("day"),
    hour(col("timestamp")).alias("hour"),
    minute(col("timestamp")).alias("minute"),
    date_format(col("date"), "yyyy-MM").alias("year_month"),
    to_date(col("date_string"), "yyyy-MM-dd").alias("parsed_date"),
    to_timestamp(col("ts_string"), "yyyy-MM-dd HH:mm:ss").alias("parsed_ts"),
    datediff(col("end_date"), col("start_date")).alias("days_diff"),
    add_months(col("date"), 3).alias("plus_3_months")
)
```

### Math Functions
```python
# Math operations
df = df.select(
    col("value"),
    round(col("value"), 2).alias("rounded"),
    abs(col("value")).alias("absolute"),
    sqrt(col("value")).alias("square_root"),
    pow(col("value"), 2).alias("squared"),
    rand().alias("random_value"),
    hash(col("name")).alias("hash_value")
)
```

### Collection Functions
```python
from pyspark.sql.functions import (
    array, array_contains, explode, explode_outer, 
    size, sort_array, collect_list, collect_set,
    map_keys, map_values, create_map
)

# Array operations
df = df.select(
    col("name"),
    col("scores"),
    array(lit(1), lit(2), lit(3)).alias("fixed_array"),
    array_contains(col("scores"), 100).alias("has_perfect_score"),
    size(col("scores")).alias("scores_count"),
    sort_array(col("scores")).alias("sorted_scores")
)

# Explode arrays
df = df.select(
    col("name"),
    explode(col("scores")).alias("score")
)

# Map operations
df = df.select(
    col("name"),
    col("properties"),
    map_keys(col("properties")).alias("property_names"),
    map_values(col("properties")).alias("property_values"),
    create_map(lit("key1"), lit("value1"), lit("key2"), lit("value2")).alias("new_map")
)
```

### Aggregation Functions
```python
# Basic aggregations
result = df.groupBy("department").agg(
    count("*").alias("employee_count"),
    sum("salary").alias("total_salary"),
    avg("salary").alias("avg_salary"),
    min("salary").alias("min_salary"),
    max("salary").alias("max_salary"),
    stddev("salary").alias("stddev_salary"),
    collect_list("name").alias("employee_names"),
    collect_set("title").alias("unique_titles")
)

# First and last values
from pyspark.sql.functions import first, last
result = df.groupBy("department").agg(
    first("name").alias("first_employee"),
    last("name").alias("last_employee")
)

# Custom aggregation with expressions
result = df.groupBy("department").agg(
    expr("SUM(CASE WHEN salary > 50000 THEN 1 ELSE 0 END) as high_salary_count")
)
```

### Pivot Tables
```python
# Create pivot table
pivoted = df.groupBy("department").pivot("year").sum("sales")

# Specify pivot values (better performance)
pivoted = df.groupBy("department").pivot("year", ["2020", "2021", "2022"]).sum("sales")
```

### Complex Transformations
```python
# Transforming multiple columns
from pyspark.sql.functions import when

# Case statement
df = df.withColumn(
    "size_category",
    when(col("size") < 3, "Small")
    .when(col("size") < 8, "Medium")
    .otherwise("Large")
)

# Multiple conditions
df = df.withColumn(
    "discount",
    when((col("membership") == "Premium") & (col("purchase") > 100), 0.2)
    .when((col("membership") == "Regular") & (col("purchase") > 200), 0.1)
    .otherwise(0)
)

# Working with NULL values
df = df.withColumn(
    "full_address",
    concat(
        col("street"), 
        lit(", "), 
        col("city"), 
        when(col("state").isNotNull(), concat(lit(", "), col("state")))
        .otherwise(lit(""))
    )
)
```

## Window Functions

### Basic Window Functions
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import (
    row_number, rank, dense_rank, percent_rank, ntile,
    lag, lead, first, last,
    sum, avg, min, max, count
)

# Define window specification
window_spec = Window.partitionBy("department").orderBy("salary")

# Ranking functions
df = df.select(
    col("name"),
    col("department"),
    col("salary"),
    row_number().over(window_spec).alias("row_number"),
    rank().over(window_spec).alias("rank"),
    dense_rank().over(window_spec).alias("dense_rank"),
    percent_rank().over(window_spec).alias("percent_rank"),
    ntile(4).over(window_spec).alias("quartile")
)

# Analytics functions
df = df.select(
    col("name"),
    col("department"),
    col("salary"),
    lag("salary", 1).over(window_spec).alias("prev_salary"),
    lead("salary", 1).over(window_spec).alias("next_salary"),
    first("salary").over(window_spec.rangeBetween(Window.unboundedPreceding, Window.currentRow)).alias("first_salary"),
    last("salary").over(window_spec.rangeBetween(Window.currentRow, Window.unboundedFollowing)).alias("last_salary")
)

# Aggregation functions with windows
df = df.select(
    col("name"),
    col("department"),
    col("salary"),
    sum("salary").over(Window.partitionBy("department")).alias("dept_total"),
    avg("salary").over(Window.partitionBy("department")).alias("dept_avg"),
    count("*").over(Window.partitionBy("department")).alias("dept_count"),
    (col("salary") / sum("salary").over(Window.partitionBy("department"))).alias("salary_ratio")
)
```

### Advanced Window Functions
```python
# Cumulative sum
df = df.withColumn(
    "cumulative_sales",
    sum("sales").over(Window.partitionBy("region").orderBy("date").rowsBetween(Window.unboundedPreceding, 0))
)

# Moving average
df = df.withColumn(
    "moving_avg_7day",
    avg("value").over(Window.partitionBy("id").orderBy("date").rowsBetween(-3, 3))
)

# Running totals
df = df.withColumn(
    "running_total",
    sum("amount").over(Window.partitionBy("account").orderBy("date").rowsBetween(Window.unboundedPreceding, 0))
)

# Year-over-year comparison
df = df.withColumn(
    "prev_year_sales",
    lag("sales", 1).over(Window.partitionBy("product").orderBy("year"))
)

# Month-over-month growth
df = df.withColumn(
    "mom_growth",
    (col("sales") - lag("sales", 1).over(Window.partitionBy("product").orderBy("yearmonth"))) / 
    lag("sales", 1).over(Window.partitionBy("product").orderBy("yearmonth"))
)
```

## UDFs (User Defined Functions)

### Python UDFs
```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType, IntegerType, ArrayType

# Define a UDF
def upper_case(s):
    if s is None:
        return None
    return s.upper()

# Register UDF
upper_udf = udf(upper_case, StringType())

# Apply UDF
df = df.withColumn("upper_name", upper_udf(col("name")))

# Alternative syntax
df = df.withColumn("upper_name", upper_udf("name"))

# Complex return type
array_len_udf = udf(lambda arr: len(arr) if arr else 0, IntegerType())
df = df.withColumn("tags_count", array_len_udf(col("tags")))

# Register UDF for SQL
spark.udf.register("UPPER_CASE", upper_case, StringType())
result = spark.sql("SELECT UPPER_CASE(name) as upper_name FROM people")
```

### Pandas UDFs (Vectorized UDFs)
```python
from pyspark.sql.functions import pandas_udf
from pyspark.sql.types import IntegerType
import pandas as pd

# Scalar Pandas UDF
@pandas_udf(IntegerType())
def plus_one(s: pd.Series) -> pd.Series:
    return s + 1

df = df.withColumn("value_plus_one", plus_one(col("value")))

# Grouped Map Pandas UDF
from pyspark.sql.functions import PandasUDFType
from pyspark.sql import Window

# Define the output schema
schema = StructType([
    StructField("id", IntegerType()),
    StructField("mean", DoubleType())
])

# Grouped map function
@pandas_udf(schema, PandasUDFType.GROUPED_MAP)
def grouped_mean(pdf: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({
        "id": [pdf["id"].iloc[0]],
        "mean": [pdf["value"].mean()]
    })

# Apply grouped map
result = df.groupBy("id").apply(grouped_mean)

# Grouped Aggregate Pandas UDF
@pandas_udf(DoubleType())
def mean_udf(v: pd.Series) -> float:
    return v.mean()

result = df.groupBy("id").agg(mean_udf(col("value")).alias("mean_value"))
```

### Vectorized UDFs with Arrow
```python
# Enable Arrow for better performance with Pandas UDFs
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")

# Batch processing with Arrow and Pandas
def transform_batch(iterator):
    for batch in iterator:
        # batch is a pandas DataFrame
        yield batch.assign(
            doubled=batch.value * 2,
            squared=batch.value ** 2
        )

result = df.mapInPandas(transform_batch, df.schema.add("doubled", DoubleType()).add("squared", DoubleType()))
```

## Machine Learning (MLlib)

### Setup
```python
from pyspark.ml import Pipeline
from pyspark.ml.feature import *
from pyspark.ml.classification import *
from pyspark.ml.regression import *
from pyspark.ml.evaluation import *
from pyspark.ml.tuning import *
```

### Data Preparation
```python
# Split data
train, test = df.randomSplit([0.8, 0.2], seed=42)

# Feature processing transformers
tokenizer = Tokenizer(inputCol="text", outputCol="words")
hashingTF = HashingTF(inputCol="words", outputCol="features", numFeatures=1000)
idf = IDF(inputCol="features", outputCol="idf_features")
assembler = VectorAssembler(
    inputCols=["feature1", "feature2", "feature3"],
    outputCol="features"
)

# Feature scaling
scaler = StandardScaler(inputCol="features", outputCol="scaled_features")
normalizer = Normalizer(inputCol="features", outputCol="norm_features", p=2.0)
minMaxScaler = MinMaxScaler(inputCol="features", outputCol="scaled_features")
```

### Building a Pipeline
```python
# Define pipeline stages
stages = [
    tokenizer,
    hashingTF,
    idf,
    RandomForestClassifier(labelCol="label", featuresCol="idf_features")
]

# Create and fit the pipeline
pipeline = Pipeline(stages=stages)
model = pipeline.fit(train)

# Make predictions
predictions = model.transform(test)
```

### Classification Models
```python
# Logistic Regression
lr = LogisticRegression(
    maxIter=10,
    regParam=0.3,
    elasticNetParam=0.8,
    labelCol="label",
    featuresCol="features"
)

# Decision Tree
dt = DecisionTreeClassifier(
    maxDepth=5,
    labelCol="label",
    featuresCol="features"
)

# Random Forest
rf = RandomForestClassifier(
    numTrees=100,
    maxDepth=5,
    seed=42,
    labelCol="label",
    featuresCol="features"
)

# Gradient Boosted Trees
gbt = GBTClassifier(
    maxIter=10,
    maxDepth=5,
    labelCol="label",
    featuresCol="features"
)

# Naive Bayes
nb = NaiveBayes(
    smoothing=1.0,
    labelCol="label",
    featuresCol="features"
)

# Multi-layer Perceptron
mlp = MultilayerPerceptronClassifier(
    layers=[784, 256, 128, 10],
    maxIter=100,
    labelCol="label",
    featuresCol="features"
)
```

### Regression Models
```python
# Linear Regression
lr = LinearRegression(
    maxIter=10,
    regParam=0.3,
    elasticNetParam=0.8,
    labelCol="label",
    featuresCol="features"
)

# Decision Tree Regressor
dtr = DecisionTreeRegressor(
    maxDepth=5,
    labelCol="label",
    featuresCol="features"
)

# Random Forest Regressor
rfr = RandomForestRegressor(
    numTrees=100,
    maxDepth=5,
    labelCol="label",
    featuresCol="features"
)

# Gradient Boosted Trees Regressor
gbtr = GBTRegressor(
    maxIter=10,
    maxDepth=5,
    labelCol="label",
    featuresCol="features"
)
```

### Model Evaluation
```python
# Classification Evaluator
evaluator = BinaryClassificationEvaluator(
    labelCol="label",
    rawPredictionCol="rawPrediction",
    metricName="areaUnderROC"
)
auc = evaluator.evaluate(predictions)

# For other metrics
evaluator = MulticlassClassificationEvaluator(
    labelCol="label",
    predictionCol="prediction",
    metricName="accuracy"  # f1, weightedPrecision, weightedRecall, etc.
)
accuracy = evaluator.evaluate(predictions)

# Regression Evaluator
evaluator = RegressionEvaluator(
    labelCol="label",
    predictionCol="prediction",
    metricName="rmse"  # mse, r2, mae
)
rmse = evaluator.evaluate(predictions)
```

### Hyperparameter Tuning
```python
# Create parameter grid
paramGrid = ParamGridBuilder() \
    .addGrid(lr.regParam, [0.1, 0.01]) \
    .addGrid(lr.elasticNetParam, [0.0, 0.5, 1.0]) \
    .addGrid(lr.maxIter, [10, 50, 100]) \
    .build()

# Cross Validation
cv = CrossValidator(
    estimator=pipeline,
    estimatorParamMaps=paramGrid,
    evaluator=evaluator,
    numFolds=3,
    seed=42
)

# Train with CV
cvModel = cv.fit(train)

# Best Model
bestModel = cvModel.bestModel
bestPipelineModel = bestModel.stages[-1]  # If your model is the last stage in the pipeline

# Extract parameters
bestParams = {param.name: bestModel.stages[-1].getOrDefault(param) 
              for param in paramGrid[0].keys()}
print(bestParams)
```

### Saving and Loading Models
```python
# Save pipeline model
model.save("path/to/model")

# Load pipeline model
from pyspark.ml import PipelineModel
loaded_model = PipelineModel.load("path/to/model")

# Save individual model
lr_model = lr.fit(train)
lr_model.save("path/to/lr_model")

# Load individual model
from pyspark.ml.classification import LogisticRegressionModel
loaded_lr_model = LogisticRegressionModel.load("path/to/lr_model")
```

## Streaming

### Structured Streaming Basics
```python
# Create streaming DataFrame from a source
streamDF = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "host1:port,host2:port") \
    .option("subscribe", "topic1") \
    .load()

# Process data
resultDF = streamDF.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)") \
    .groupBy("key") \
    .count()

# Write to sink
query = resultDF.writeStream \
    .outputMode("complete") \
    .format("console") \
    .start()

# Wait for termination
query.awaitTermination()
```

### Input Sources
```python
# Read from socket
socketDF = spark.readStream \
    .format("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()

# Read from files
fileDF = spark.readStream \
    .format("csv") \
    .option("header", "true") \
    .schema(schema) \
    .load("path/to/directory")

# Read from Kafka
kafkaDF = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "host:port") \
    .option("subscribe", "topic1,topic2") \
    .option("startingOffsets", "earliest") \
    .load()

# Read from Rate source (for testing)
rateDF = spark.readStream \
    .format("rate") \
    .option("rowsPerSecond", 10) \
    .load()
```

### Output Sinks
```python
# Write to console
query = streamDF.writeStream \
    .outputMode("append") \
    .format("console") \
    .option("truncate", False) \
    .start()

# Write to files
query = streamDF.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "output/path") \
    .option("checkpointLocation", "checkpoint/path") \
    .start()

# Write to Kafka
query = streamDF.writeStream \
    .outputMode("append") \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "host:port") \
    .option("topic", "output-topic") \
    .option("checkpointLocation", "checkpoint/path") \
    .start()

# Write to memory (for debugging)
query = streamDF.writeStream \
    .queryName("table_name") \
    .outputMode("complete") \
    .format("memory") \
    .start()

# Query the in-memory table
spark.sql("SELECT * FROM table_name").show()

# Foreach batch processing
def process_batch(batch_df, batch_id):
    # Process each batch of data
    batch_df.persist()
    
    # Do something with the batch
    batch_df.write.format("jdbc").option("url", "jdbc:...").save()
    
    # Clean up
    batch_df.unpersist()

query = streamDF.writeStream \
    .foreachBatch(process_batch) \
    .outputMode("append") \
    .option("checkpointLocation", "checkpoint/path") \
    .start()
```

### Watermarking and Window Operations
```python
from pyspark.sql.functions import window

# Define watermark
windowedDF = streamDF \
    .withWatermark("timestamp", "10 minutes") \
    .groupBy(window("timestamp", "5 minutes")) \
    .count()

# Tumbling windows
windowedDF = streamDF \
    .withWatermark("timestamp", "10 minutes") \
    .groupBy(
        window("timestamp", "5 minutes"),
        "deviceId"
    ) \
    .agg(count("*").alias("count"))

# Sliding windows
windowedDF = streamDF \
    .withWatermark("timestamp", "10 minutes") \
    .groupBy(
        window("timestamp", "10 minutes", "5 minutes"),
        "deviceId"
    ) \
    .agg(avg("value").alias("avg_value"))
```

### Stream-Stream Joins
```python
# Join two streams
joined = impressionsDF \
    .withWatermark("impressionTime", "2 hours") \
    .join(
        clicksDF.withWatermark("clickTime", "3 hours"),
        expr("""
            impressionId = clickImpressionId AND
            clickTime >= impressionTime AND
            clickTime <= impressionTime + interval 1 hour
        """),
        "leftOuter"
    )
```

### Streaming Queries Management
```python
# Get active queries
spark.streams.active

# Stop a query
query.stop()

# Get query status
query.status
query.lastProgress
query.recentProgress

# Exception handling
try:
    query.awaitTermination()
except StreamingQueryException as e:
    print(e)
```

## Optimization Techniques

### Spark Configuration
```python
# Memory management
spark.conf.set("spark.memory.fraction", "0.8")  # Fraction of heap for execution/storage
spark.conf.set("spark.memory.storageFraction", "0.5")  # Fraction of (spark.memory.fraction) for storage

# Serialization
spark.conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
spark.conf.set("spark.kryo.registrationRequired", "false")

# Shuffle partitions
spark.conf.set("spark.sql.shuffle.partitions", "200")  # Default is 200
spark.conf.set("spark.default.parallelism", "100")  # Default parallelism

# Broadcast joins
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10485760")  # 10MB
```

### Performance Optimization
```python
# Broadcast hint for joins
from pyspark.sql.functions import broadcast
result = df1.join(broadcast(df2), df1["key"] == df2["key"])

# Repartition data
df = df.repartition(10)  # Shuffle to N partitions
df = df.repartition("key")  # Repartition by key
df = df.repartition(10, "key")  # Repartition by key into N partitions

# Coalesce (avoid shuffle when possible)
df = df.coalesce(5)

# Cache and persist
df.cache()  # Same as df.persist(StorageLevel.MEMORY_AND_DISK)

df.persist(StorageLevel.MEMORY_ONLY)
df.persist(StorageLevel.MEMORY_ONLY_SER)
df.persist(StorageLevel.MEMORY_AND_DISK)
df.persist(StorageLevel.OFF_HEAP)

# Check if cached
df.is_cached

# Unpersist when done
df.unpersist()

# Explain plan
df.explain()  # Basic plan
df.explain(True)  # Detailed plan
```

### SQL Optimization
```python
# Enable adaptive query execution
spark.conf.set("spark.sql.adaptive.enabled", "true")

# Cost-based optimizer
spark.conf.set("spark.sql.cbo.enabled", "true")

# Join Reorder
spark.conf.set("spark.sql.cbo.joinReorder.enabled", "true")

# Statistics collection
df.write.mode("overwrite").saveAsTable("my_table")
spark.sql("ANALYZE TABLE my_table COMPUTE STATISTICS")
spark.sql("ANALYZE TABLE my_table COMPUTE STATISTICS FOR COLUMNS col1, col2")

# Hint join strategy
spark.sql("""
    SELECT /*+ BROADCAST(t1) */ * 
    FROM large_table t2
    JOIN small_table t1 ON t1.key = t2.key
""")

# Common SQL hints
# BROADCAST: Force broadcast join
# MERGE: Force sort-merge join
# SHUFFLE_HASH: Force shuffle hash join
# SHUFFLE_REPLICATE_NL: Force shuffle-and-replicate nested loop join
```

## Debugging and Monitoring

### Logging
```python
# Set log level
spark.sparkContext.setLogLevel("INFO")  # Options: ALL, DEBUG, ERROR, FATAL, INFO, OFF, TRACE, WARN

# Log4j logger
log4jLogger = spark._jvm.org.apache.log4j
logger = log4jLogger.LogManager.getLogger("your-logger-name")
logger.info("This is an info message")
logger.warn("This is a warning")
logger.error("This is an error message")
```

### Spark UI
```python
# Get Spark UI URL
spark.sparkContext.uiWebUrl

# Important Spark UI tabs:
# - Jobs: Overall job execution
# - Stages: Detailed stage information
# - Storage: Cached RDDs/DataFrames
# - Executors: Executor information
# - SQL: SQL query execution
```

### Spark Metrics
```python
# Enable Spark metrics
spark.conf.set("spark.metrics.conf.*.sink.console.class", "org.apache.spark.metrics.sink.ConsoleSink")

# Enable event log for history server
spark.conf.set("spark.eventLog.enabled", "true")
spark.conf.set("spark.eventLog.dir", "hdfs://namenode:8021/directory")

# Start history server
# $SPARK_HOME/sbin/start-history-server.sh
```

### Accumulators
```python
# Create accumulator
errorCount = spark.sparkContext.accumulator(0)

# Use in transformations
def count_errors(record):
    global errorCount
    if not valid_record(record):
        errorCount.add(1)
    return record

result = rdd.map(count_errors)
result.count()  # Force evaluation

# Get accumulator value
print(f"Error count: {errorCount.value}")
```

### Broadcast Variables
```python
# Create broadcast variable
lookup_table = {"key1": "value1", "key2": "value2"}
broadcast_lookup = spark.sparkContext.broadcast(lookup_table)

# Use in transformations
def lookup_value(record):
    return record + broadcast_lookup.value.get(record, "default")

result = rdd.map(lookup_value)
```

## Useful Settings

### Common Configuration Settings
```python
# Memory settings
spark.conf.set("spark.driver.memory", "4g")
spark.conf.set("spark.executor.memory", "4g")
spark.conf.set("spark.executor.cores", "2")
spark.conf.set("spark.task.cpus", "1")

# Dynamic allocation
spark.conf.set("spark.dynamicAllocation.enabled", "true")
spark.conf.set("spark.dynamicAllocation.minExecutors", "2")
spark.conf.set("spark.dynamicAllocation.maxExecutors", "10")

# Speculative execution (relaunch slow tasks)
spark.conf.set("spark.speculation", "true")

# SQL settings
spark.conf.set("spark.sql.files.maxPartitionBytes", "134217728")  # 128MB
spark.conf.set("spark.sql.shuffle.partitions", "200")
spark.conf.set("spark.sql.autoBroadcastJoinThreshold", "10485760")  # 10MB

# Network timeouts
spark.conf.set("spark.network.timeout", "800s")
spark.conf.set("spark.executor.heartbeatInterval", "30s")

# Compression and serialization
spark.conf.set("spark.io.compression.codec", "snappy")  # lz4, snappy, zstd
spark.conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")

# Python settings
spark.conf.set("spark.python.worker.memory", "1g")
spark.conf.set("spark.python.worker.reuse", "true")
```

### Data Skew Handling
```python
# Detect skew
df.groupBy("key").count().orderBy("count", ascending=False).show(10)

# Handle skew with salting
from pyspark.sql.functions import rand, abs, hash
num_partitions = 10

# Add salt to key for better distribution
df_salted = df.withColumn("salted_key", abs(hash(col("key")) % num_partitions))

# Join with salted key
df_result = df_salted.join(
    broadcast(other_df),
    (df_salted["key"] == other_df["key"]) & (df_salted["salted_key"] < num_partitions),
    "inner"
).drop("salted_key")
```

## Vim Commands for PySpark Development

### Basic Navigation
```
h, j, k, l - move left, down, up, right
0 - move to beginning of line
$ - move to end of line
gg - move to beginning of file
G - move to end of file
:n - move to line n
```

### Editing Commands
```
i - insert mode at cursor
a - insert mode after cursor
A - insert mode at end of line
o - insert mode on new line below
O - insert mode on new line above
ESC - exit insert mode
```

### Search and Replace
```
/pattern - search forward for pattern
?pattern - search backward for pattern
n - repeat search forward
N - repeat search backward
:%s/old/new/g - replace all old with new in file
:s/old/new/g - replace all old with new in current line
```

### Cut, Copy, Paste
```
yy - copy current line
4yy - copy 4 lines
dd - cut current line
4dd - cut 4 lines
p - paste after cursor
P - paste before cursor
```

### PySpark Development Specific
```
:set syntax=python - enable Python syntax highlighting
:set number - show line numbers
:set autoindent - auto indent
:set tabstop=4 - tab width of 4 spaces
:set expandtab - use spaces instead of tabs
:set softtabstop=4 - softtabstop of 4 spaces
:set shiftwidth=4 - shift width of 4 spaces
```

### Indentation
```
>> - indent current line
<< - unindent current line
5>> - indent 5 lines
```

### Saving and Quitting
```
:w - save
:q - quit
:wq - save and quit
:x - save and quit
:q! - quit without saving
```

### Multiple Files/Windows
```
:sp filename - open a file in a new split window
:vsp filename - open a file in a new vertical split window
Ctrl+w then h,j,k,l - navigate between windows
```

### Useful Vim Settings for PySpark
```
" Add to .vimrc for PySpark development
syntax on
filetype plugin indent on
set number
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ruler
set hlsearch
set incsearch
set cursorline
" Auto-complete for Python
autocmd FileType python set omnifunc=pythoncomplete#Complete
```
