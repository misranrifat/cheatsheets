# Dask Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Core Concepts](#core-concepts)
- [Dask Arrays](#dask-arrays)
- [Dask DataFrames](#dask-dataframes)
- [Dask Bags](#dask-bags)
- [Dask Delayed](#dask-delayed)
- [Task Graphs](#task-graphs)
- [Schedulers](#schedulers)
- [Distributed Computing](#distributed-computing)
- [Performance Optimization](#performance-optimization)
- [Machine Learning with Dask](#machine-learning-with-dask)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Introduction

Dask is a flexible parallel computing library for analytic computing in Python. It provides parallel implementations of NumPy arrays, Pandas DataFrames, and custom parallel computations.

**Key Features:**
- Parallel computing with familiar APIs (NumPy, Pandas)
- Scales from laptops to clusters
- Works well with existing Python ecosystem
- Lazy evaluation and task scheduling

## Installation

### Basic Installation
```bash
# Install Dask
pip install dask

# Install with all dependencies
pip install "dask[complete]"

# Install specific components
pip install "dask[array]"        # Dask arrays
pip install "dask[dataframe]"    # Dask DataFrames
pip install "dask[bag]"          # Dask bags
pip install "dask[distributed]"  # Distributed scheduler

# Install with conda
conda install dask
```

### Additional Dependencies
```bash
# For distributed computing
pip install dask distributed

# For diagnostics dashboard
pip install bokeh

# For cloud storage
pip install s3fs gcsfs adlfs

# For machine learning
pip install dask-ml xgboost lightgbm
```

### Verify Installation
```python
import dask
import dask.array as da
import dask.dataframe as dd
import dask.bag as db

print(f"Dask version: {dask.__version__}")
```

## Core Concepts

### Lazy Evaluation
```python
import dask.array as da

# Create Dask array (lazy, no computation yet)
x = da.ones((10000, 10000), chunks=(1000, 1000))
y = x + x.T

# Trigger computation
result = y.compute()
```

### Chunks
```python
import dask.array as da

# Create array with specific chunk size
x = da.ones((10000, 10000), chunks=(1000, 1000))
print(x.chunks)  # ((1000, 1000, ...), (1000, 1000, ...))

# Auto-chunking
x = da.ones((10000, 10000), chunks='auto')

# Rechunk existing array
x = x.rechunk((2000, 2000))
```

### Compute vs Persist
```python
import dask.array as da

x = da.ones((10000, 10000), chunks=(1000, 1000))
y = x + 1
z = y * 2

# Compute: execute and return result
result = z.compute()

# Persist: execute and keep in memory
y_persisted = y.persist()
# Use persisted result multiple times
result1 = (y_persisted + 1).compute()
result2 = (y_persisted * 2).compute()
```

## Dask Arrays

### Creating Dask Arrays
```python
import dask.array as da
import numpy as np

# Create from shape
x = da.zeros((10000, 10000), chunks=(1000, 1000))
y = da.ones((10000, 10000), chunks=(1000, 1000))
z = da.random.random((10000, 10000), chunks=(1000, 1000))

# Create from NumPy array
numpy_array = np.arange(100)
dask_array = da.from_array(numpy_array, chunks=10)

# Create with specific chunks
x = da.arange(100, chunks=10)

# Create from delayed objects
import dask.delayed as delayed

@delayed
def load_chunk(i):
    return np.random.random((1000, 1000))

arrays = [da.from_delayed(load_chunk(i), shape=(1000, 1000), dtype=float)
          for i in range(10)]
x = da.concatenate(arrays, axis=0)
```

### Array Operations
```python
import dask.array as da

x = da.random.random((10000, 10000), chunks=(1000, 1000))
y = da.random.random((10000, 10000), chunks=(1000, 1000))

# Element-wise operations
z = x + y
z = x * y
z = da.sin(x)
z = da.exp(x)

# Aggregations
mean = x.mean().compute()
sum_val = x.sum().compute()
std = x.std().compute()
max_val = x.max().compute()

# Reductions along axis
row_sums = x.sum(axis=1).compute()
col_means = x.mean(axis=0).compute()

# Linear algebra
result = da.dot(x, y.T)
result = da.linalg.svd(x)
```

### Slicing and Indexing
```python
import dask.array as da

x = da.random.random((10000, 10000), chunks=(1000, 1000))

# Slicing (preserves laziness)
subset = x[:5000, :5000]
rows = x[100:200, :]
cols = x[:, 500:600]

# Fancy indexing
mask = x > 0.5
filtered = x[mask]

# Boolean indexing
result = x[x > 0.5].compute()
```

### Stacking and Concatenating
```python
import dask.array as da

x = da.random.random((1000, 1000), chunks=(100, 100))
y = da.random.random((1000, 1000), chunks=(100, 100))

# Stack arrays
stacked = da.stack([x, y], axis=0)

# Concatenate arrays
concatenated = da.concatenate([x, y], axis=0)

# Horizontal stack
hstacked = da.hstack([x, y])

# Vertical stack
vstacked = da.vstack([x, y])
```

### Reshaping
```python
import dask.array as da

x = da.random.random((1000, 1000), chunks=(100, 100))

# Reshape
reshaped = x.reshape((100, 10000))

# Flatten
flattened = x.flatten()

# Transpose
transposed = x.T
```

## Dask DataFrames

### Creating Dask DataFrames
```python
import dask.dataframe as dd
import pandas as pd

# Read from CSV
df = dd.read_csv('data.csv')
df = dd.read_csv('data/*.csv')  # Multiple files
df = dd.read_csv('s3://bucket/data/*.csv')  # S3

# Read from Parquet
df = dd.read_parquet('data.parquet')
df = dd.read_parquet('data/*.parquet')

# Read from JSON
df = dd.read_json('data.json')

# From Pandas DataFrame
pdf = pd.DataFrame({'x': range(100), 'y': range(100)})
df = dd.from_pandas(pdf, npartitions=4)

# Create from delayed objects
@delayed
def load_partition(i):
    return pd.DataFrame({'x': range(i*10, (i+1)*10)})

dfs = [dd.from_delayed(load_partition(i), meta={'x': int})
       for i in range(10)]
df = dd.concat(dfs)
```

### DataFrame Operations
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Column selection
subset = df[['col1', 'col2']]
single_col = df['col1']

# Filtering
filtered = df[df['age'] > 30]
filtered = df[df['name'].str.contains('John')]

# Sorting (expensive operation)
sorted_df = df.set_index('date').compute()

# Drop columns
df = df.drop(['col1', 'col2'], axis=1)

# Rename columns
df = df.rename(columns={'old_name': 'new_name'})
```

### Aggregations
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Basic aggregations
mean = df['age'].mean().compute()
sum_val = df['amount'].sum().compute()
count = df['id'].count().compute()
max_val = df['score'].max().compute()

# GroupBy operations
grouped = df.groupby('category')['amount'].sum().compute()
grouped = df.groupby('category').agg({'amount': 'sum', 'count': 'mean'}).compute()

# Multiple aggregations
agg_result = df.groupby('category').agg({
    'amount': ['sum', 'mean', 'std'],
    'count': ['min', 'max']
}).compute()

# Value counts
counts = df['category'].value_counts().compute()
```

### Merging and Joining
```python
import dask.dataframe as dd

df1 = dd.read_csv('data1.csv')
df2 = dd.read_csv('data2.csv')

# Merge
merged = dd.merge(df1, df2, on='id')
merged = dd.merge(df1, df2, left_on='id', right_on='user_id')

# Join (set index first for efficiency)
df1 = df1.set_index('id')
df2 = df2.set_index('id')
joined = df1.join(df2)

# Concatenate
concatenated = dd.concat([df1, df2], axis=0)
```

### Apply and Map
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Apply function to column
df['new_col'] = df['amount'].apply(lambda x: x * 2, meta=('amount', 'f8'))

# Map values
df['category'] = df['category'].map({'A': 1, 'B': 2, 'C': 3})

# Apply custom function
def custom_function(row):
    return row['x'] + row['y']

df['sum'] = df.apply(custom_function, axis=1, meta=('sum', 'f8'))

# Map partitions (more efficient)
def process_partition(partition):
    partition['new_col'] = partition['amount'] * 2
    return partition

df = df.map_partitions(process_partition)
```

### Writing Data
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Write to CSV
df.to_csv('output/*.csv')

# Write to Parquet
df.to_parquet('output.parquet')
df.to_parquet('output/', engine='pyarrow')

# Write to JSON
df.to_json('output/*.json')

# Convert to Pandas (use carefully with large data)
pdf = df.compute()
```

## Dask Bags

### Creating Dask Bags
```python
import dask.bag as db

# From sequence
bag = db.from_sequence([1, 2, 3, 4, 5], partition_size=2)

# From text files
bag = db.read_text('data.txt')
bag = db.read_text('data/*.txt')
bag = db.read_text('s3://bucket/data/*.txt')

# From delayed objects
@delayed
def load_data(i):
    return list(range(i*10, (i+1)*10))

bags = [db.from_delayed(load_data(i)) for i in range(10)]
bag = db.concat(bags)
```

### Bag Operations
```python
import dask.bag as db

bag = db.from_sequence(range(100), partition_size=10)

# Map
result = bag.map(lambda x: x * 2)

# Filter
result = bag.filter(lambda x: x % 2 == 0)

# Pluck (extract field from dict/object)
records = db.from_sequence([
    {'name': 'Alice', 'age': 30},
    {'name': 'Bob', 'age': 25}
])
names = records.pluck('name')

# Fold (reduce)
sum_val = bag.fold(lambda acc, x: acc + x, lambda acc1, acc2: acc1 + acc2).compute()

# Groupby
grouped = bag.groupby(lambda x: x % 3)

# Take (get first n items)
first_10 = bag.take(10)

# Count
count = bag.count().compute()
```

### Advanced Bag Operations
```python
import dask.bag as db

bag = db.from_sequence(range(100), partition_size=10)

# Flatten
nested = db.from_sequence([[1, 2], [3, 4], [5, 6]])
flattened = nested.flatten()

# Frequencies (count occurrences)
bag = db.from_sequence(['a', 'b', 'a', 'c', 'b', 'a'])
freq = bag.frequencies().compute()

# TopK
top_5 = bag.topk(5).compute()

# Distinct
unique = bag.distinct().compute()

# Join
bag1 = db.from_sequence([('a', 1), ('b', 2)])
bag2 = db.from_sequence([('a', 3), ('c', 4)])
joined = bag1.join(bag2)
```

### Bag to DataFrame
```python
import dask.bag as db
import dask.dataframe as dd

# Create bag of records
records = db.from_sequence([
    {'name': 'Alice', 'age': 30, 'city': 'NYC'},
    {'name': 'Bob', 'age': 25, 'city': 'LA'},
    {'name': 'Charlie', 'age': 35, 'city': 'SF'}
])

# Convert to DataFrame
df = records.to_dataframe()
result = df.compute()
```

## Dask Delayed

### Basic Delayed Functions
```python
import dask.delayed as delayed

# Decorate function
@delayed
def increment(x):
    return x + 1

@delayed
def add(x, y):
    return x + y

# Build computation graph
x = increment(1)
y = increment(2)
z = add(x, y)

# Compute result
result = z.compute()  # Returns 5
```

### Complex Workflows
```python
import dask.delayed as delayed
import time

@delayed
def load_data(filename):
    time.sleep(1)  # Simulate I/O
    return [1, 2, 3, 4, 5]

@delayed
def process_data(data):
    return sum(data)

@delayed
def combine_results(results):
    return sum(results)

# Build workflow
files = ['file1.txt', 'file2.txt', 'file3.txt']
loaded = [load_data(f) for f in files]
processed = [process_data(d) for d in loaded]
final = combine_results(processed)

# Execute
result = final.compute()
```

### Delayed with Collections
```python
import dask.delayed as delayed
import dask.array as da

@delayed
def load_chunk(i):
    return np.random.random((1000, 1000))

# Create delayed arrays
delayed_arrays = [load_chunk(i) for i in range(10)]

# Convert to Dask array
arrays = [da.from_delayed(arr, shape=(1000, 1000), dtype=float)
          for arr in delayed_arrays]
big_array = da.concatenate(arrays, axis=0)

# Compute
result = big_array.sum().compute()
```

## Task Graphs

### Visualize Task Graph
```python
import dask.array as da

x = da.random.random((1000, 1000), chunks=(100, 100))
y = x + x.T
z = y.sum()

# Visualize graph (requires graphviz)
z.visualize(filename='task-graph.png')

# Visualize with optimization
z.visualize(filename='task-graph-optimized.png', optimize_graph=True)
```

### Inspect Task Graph
```python
import dask

x = da.random.random((1000, 1000), chunks=(100, 100))
y = x + x.T

# Get task graph
graph = y.__dask_graph__()

# Print graph info
print(f"Number of tasks: {len(graph)}")
print(f"Keys: {list(graph.keys())[:5]}")
```

## Schedulers

### Single-Threaded Scheduler
```python
import dask
import dask.array as da

# Use single-threaded scheduler (good for debugging)
with dask.config.set(scheduler='synchronous'):
    x = da.random.random((1000, 1000), chunks=(100, 100))
    result = x.sum().compute()
```

### Threaded Scheduler
```python
import dask
import dask.array as da

# Use threaded scheduler (default for arrays/delayed)
with dask.config.set(scheduler='threads'):
    x = da.random.random((1000, 1000), chunks=(100, 100))
    result = x.sum().compute()

# Set number of threads
with dask.config.set(scheduler='threads', num_workers=4):
    result = x.sum().compute()
```

### Multiprocessing Scheduler
```python
import dask
import dask.array as da

# Use multiprocessing scheduler
with dask.config.set(scheduler='processes'):
    x = da.random.random((1000, 1000), chunks=(100, 100))
    result = x.sum().compute()
```

## Distributed Computing

### Start Distributed Client
```python
from dask.distributed import Client

# Start local cluster
client = Client()
print(client)

# Start with specific resources
client = Client(n_workers=4, threads_per_worker=2, memory_limit='4GB')

# Connect to existing cluster
client = Client('scheduler-address:8786')

# View dashboard
print(client.dashboard_link)
```

### Submit Tasks
```python
from dask.distributed import Client

client = Client()

# Submit function
def square(x):
    return x ** 2

future = client.submit(square, 10)
result = future.result()

# Submit multiple tasks
futures = client.map(square, range(10))
results = client.gather(futures)
```

### Distributed Arrays and DataFrames
```python
from dask.distributed import Client
import dask.array as da
import dask.dataframe as dd

client = Client()

# Use distributed scheduler automatically
x = da.random.random((10000, 10000), chunks=(1000, 1000))
result = x.sum().compute()

# Read CSV with distributed scheduler
df = dd.read_csv('data/*.csv')
result = df.groupby('category')['amount'].sum().compute()
```

### Persist and Scatter
```python
from dask.distributed import Client
import dask.array as da

client = Client()

x = da.random.random((10000, 10000), chunks=(1000, 1000))

# Persist in distributed memory
x_persisted = client.persist(x)

# Use persisted data multiple times
result1 = (x_persisted + 1).sum().compute()
result2 = (x_persisted * 2).sum().compute()

# Scatter data to workers
data = list(range(1000))
futures = client.scatter(data)
```

### Progress Tracking
```python
from dask.distributed import Client, progress
import dask.array as da

client = Client()

x = da.random.random((10000, 10000), chunks=(1000, 1000))
y = x + x.T

# Track progress
future = client.compute(y.sum())
progress(future)
result = future.result()
```

## Performance Optimization

### Chunk Size Optimization
```python
import dask.array as da

# Rule of thumb: 10-100 MB per chunk

# Bad: too small chunks (too much overhead)
x = da.ones((10000, 10000), chunks=(10, 10))

# Good: reasonable chunk size
x = da.ones((10000, 10000), chunks=(1000, 1000))

# Auto chunks
x = da.ones((10000, 10000), chunks='auto')

# Check chunk size
print(x.chunksize)
print(f"Number of chunks: {x.npartitions}")
```

### Rechunking
```python
import dask.array as da

x = da.random.random((10000, 10000), chunks=(100, 100))

# Rechunk for better performance
x = x.rechunk((1000, 1000))

# Rechunk along specific axis
x = x.rechunk({0: 1000, 1: -1})  # -1 means single chunk
```

### Persist vs Compute
```python
import dask.array as da

x = da.random.random((10000, 10000), chunks=(1000, 1000))
y = x + 1

# Use persist when reusing intermediate results
y_persisted = y.persist()

result1 = (y_persisted * 2).sum().compute()
result2 = (y_persisted ** 2).sum().compute()

# Use compute for final results
final_result = y.sum().compute()
```

### Avoiding Full Sorts
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Avoid: expensive full sort
sorted_df = df.sort_values('date')

# Better: set index if you need sorted operations
df = df.set_index('date')
subset = df.loc['2023-01-01':'2023-12-31']
```

### Map Partitions
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Inefficient: apply row by row
df['new_col'] = df.apply(lambda row: row['x'] + row['y'], axis=1, meta=('new_col', 'f8'))

# Efficient: map partitions
def process_partition(partition):
    partition['new_col'] = partition['x'] + partition['y']
    return partition

df = df.map_partitions(process_partition)
```

## Machine Learning with Dask

### Dask-ML
```python
from dask_ml.model_selection import train_test_split
from dask_ml.linear_model import LogisticRegression
import dask.dataframe as dd

# Load data
df = dd.read_csv('data.csv')
X = df[['feature1', 'feature2', 'feature3']]
y = df['target']

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train model
model = LogisticRegression()
model.fit(X_train, y_train)

# Predict
predictions = model.predict(X_test)
score = model.score(X_test, y_test)
```

### Scikit-Learn with Joblib
```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
import dask.dataframe as dd
import joblib

# Load data
df = dd.read_csv('data.csv')
X = df[['feature1', 'feature2']].compute()
y = df['target'].compute()

# Use Dask as joblib backend
with joblib.parallel_backend('dask'):
    model = RandomForestClassifier()
    params = {'n_estimators': [10, 50, 100], 'max_depth': [3, 5, 7]}
    grid_search = GridSearchCV(model, params, cv=5)
    grid_search.fit(X, y)
```

### XGBoost with Dask
```python
import dask.dataframe as dd
import xgboost as xgb
from dask.distributed import Client

client = Client()

# Load data
df = dd.read_csv('data.csv')
X = df[['feature1', 'feature2', 'feature3']]
y = df['target']

# Create DMatrix
dtrain = xgb.dask.DaskDMatrix(client, X, y)

# Train model
params = {'max_depth': 5, 'eta': 0.1, 'objective': 'binary:logistic'}
model = xgb.dask.train(client, params, dtrain, num_boost_round=100)

# Predict
predictions = xgb.dask.predict(client, model, dtrain)
```

## Best Practices

### Use Appropriate Collections
```python
# Use Dask Arrays for NumPy-like operations
import dask.array as da
x = da.random.random((10000, 10000), chunks=(1000, 1000))

# Use Dask DataFrames for tabular data
import dask.dataframe as dd
df = dd.read_csv('data.csv')

# Use Dask Bags for unstructured/semi-structured data
import dask.bag as db
bag = db.read_text('logs/*.txt')

# Use Dask Delayed for custom workflows
import dask.delayed as delayed
@delayed
def process(x):
    return x * 2
```

### Set Index for DataFrames
```python
import dask.dataframe as dd

df = dd.read_csv('data.csv')

# Set index for efficient filtering and joins
df = df.set_index('date')

# Now filtering is efficient
subset = df.loc['2023-01-01':'2023-12-31']

# Joins are also more efficient
df2 = df2.set_index('date')
merged = df.join(df2)
```

### Avoid Small Partitions
```python
import dask.dataframe as dd

# Bad: too many small partitions
df = dd.read_csv('data.csv', blocksize='1MB')  # Many small partitions

# Good: reasonable partition size (25-100 MB)
df = dd.read_csv('data.csv', blocksize='64MB')

# Repartition if needed
df = df.repartition(npartitions=10)
```

### Use Parquet for Storage
```python
import dask.dataframe as dd

# Read CSV (slow)
df = dd.read_csv('data.csv')

# Convert to Parquet (columnar, compressed)
df.to_parquet('data.parquet')

# Read Parquet (fast)
df = dd.read_parquet('data.parquet')

# Parquet supports column projection
df = dd.read_parquet('data.parquet', columns=['col1', 'col2'])
```

### Monitor with Dashboard
```python
from dask.distributed import Client

# Start client with dashboard
client = Client()
print(f"Dashboard: {client.dashboard_link}")

# Monitor task execution, memory usage, and performance
```

## Common Patterns

### ETL Pipeline
```python
import dask.dataframe as dd

# Extract
df = dd.read_csv('raw_data/*.csv')

# Transform
df = df[df['amount'] > 0]  # Filter
df['date'] = dd.to_datetime(df['date'])  # Convert types
df = df.groupby('category')['amount'].sum().reset_index()  # Aggregate

# Load
df.to_parquet('processed_data.parquet')
```

### Time Series Processing
```python
import dask.dataframe as dd

df = dd.read_parquet('timeseries.parquet')
df['timestamp'] = dd.to_datetime(df['timestamp'])
df = df.set_index('timestamp')

# Resample
daily = df.resample('1D').mean()

# Rolling window
rolling = df.rolling('7D').mean()

# Compute
result = daily.compute()
```

### Large-Scale Joins
```python
import dask.dataframe as dd

# Read data
df1 = dd.read_parquet('dataset1.parquet')
df2 = dd.read_parquet('dataset2.parquet')

# Set index for efficient join
df1 = df1.set_index('id')
df2 = df2.set_index('id')

# Join
merged = df1.join(df2, how='inner')

# Write result
merged.to_parquet('merged.parquet')
```

### Parallel File Processing
```python
import dask.bag as db
import dask.delayed as delayed

# Read text files
bag = db.read_text('data/*.txt')

# Process each line
processed = bag.map(lambda line: line.strip().upper())

# Filter
filtered = processed.filter(lambda line: 'ERROR' in line)

# Write to file
result = filtered.compute()
with open('errors.txt', 'w') as f:
    for line in result:
        f.write(line + '\n')
```

## Troubleshooting

### Memory Issues
```python
import dask
import dask.dataframe as dd

# Check partition sizes
df = dd.read_csv('data.csv')
print(df.npartitions)
print(df.memory_usage(deep=True).compute())

# Increase partition size to reduce memory per partition
df = dd.read_csv('data.csv', blocksize='128MB')

# Use chunking for arrays
import dask.array as da
x = da.random.random((10000, 10000), chunks='auto')
```

### Performance Debugging
```python
from dask.distributed import Client, performance_report

client = Client()

# Generate performance report
with performance_report(filename="dask-report.html"):
    df = dd.read_csv('data.csv')
    result = df.groupby('category')['amount'].sum().compute()

# View report in browser
# Open dask-report.html
```

### Task Graph Too Large
```python
import dask
import dask.array as da

# Optimize task graph
with dask.config.set(optimize_graph=True):
    x = da.random.random((10000, 10000), chunks=(1000, 1000))
    result = x.sum().compute()

# Fuse operations
with dask.config.set(fuse_ave_width=10):
    result = x.sum().compute()
```

### Scheduler Issues
```python
from dask.distributed import Client

# Restart client
client = Client()
client.restart()

# Check cluster status
print(client.status)

# View worker info
print(client.scheduler_info())
```

### Debug Mode
```python
import dask

# Use single-threaded scheduler for debugging
with dask.config.set(scheduler='synchronous'):
    df = dd.read_csv('data.csv')
    result = df.compute()

# Enable warnings
import warnings
warnings.simplefilter('always')
```

## References

- [Dask Documentation](https://docs.dask.org/)
- [Dask Tutorial](https://tutorial.dask.org/)
- [Dask Examples](https://examples.dask.org/)
- [Dask Best Practices](https://docs.dask.org/en/latest/best-practices.html)
- [Dask API Reference](https://docs.dask.org/en/latest/api.html)
- [Dask Distributed](https://distributed.dask.org/)
- [Dask-ML Documentation](https://ml.dask.org/)
