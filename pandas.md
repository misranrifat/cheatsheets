# Pandas Cheatsheet

## Table of Contents
- [Importing Pandas](#importing-pandas)
- [Creating Data Structures](#creating-data-structures)
- [Reading and Writing Data](#reading-and-writing-data)
- [Basic Data Inspection](#basic-data-inspection)
- [Selection and Indexing](#selection-and-indexing)
- [Data Cleaning](#data-cleaning)
- [Data Transformation](#data-transformation)
- [Sorting and Ranking](#sorting-and-ranking)
- [Grouping and Aggregation](#grouping-and-aggregation)
- [Merging and Joining](#merging-and-joining)
- [Time Series](#time-series)
- [String Operations](#string-operations)
- [Window Functions](#window-functions)
- [Plotting](#plotting)
- [Performance Tips](#performance-tips)
- [Configuration](#configuration)

## Importing Pandas

```python
import pandas as pd
import numpy as np  # Often used alongside pandas
```

## Creating Data Structures

### Series

```python
# From list
s = pd.Series([1, 2, 3, 4])

# With custom index
s = pd.Series([1, 2, 3, 4], index=['a', 'b', 'c', 'd'])

# From dictionary
s = pd.Series({'a': 1, 'b': 2, 'c': 3})

# With specific data type
s = pd.Series([1, 2, 3], dtype=np.float64)
```

### DataFrame

```python
# From dictionary of lists/arrays
df = pd.DataFrame({
    'A': [1, 2, 3],
    'B': ['a', 'b', 'c'],
    'C': [True, False, True]
})

# From list of dictionaries
df = pd.DataFrame([
    {'A': 1, 'B': 'a'},
    {'A': 2, 'B': 'b'}
])

# From arrays with column and index labels
df = pd.DataFrame(
    np.random.randn(3, 2),
    columns=['A', 'B'],
    index=['x', 'y', 'z']
)

# From another DataFrame
df2 = pd.DataFrame(df)
```

## Reading and Writing Data

### Reading Data

```python
# CSV
df = pd.read_csv('file.csv')
df = pd.read_csv('file.csv', index_col=0)  # Set first column as index
df = pd.read_csv('file.csv', header=None)  # No header
df = pd.read_csv('file.csv', names=['A', 'B'])  # Custom column names
df = pd.read_csv('file.csv', skiprows=2)  # Skip first 2 rows
df = pd.read_csv('file.csv', nrows=10)  # Read only 10 rows
df = pd.read_csv('file.csv', sep='\t')  # Tab-separated
df = pd.read_csv('file.csv', na_values=['NA', 'Missing'])  # Custom NA values

# Excel
df = pd.read_excel('file.xlsx')
df = pd.read_excel('file.xlsx', sheet_name='Sheet1')
df = pd.read_excel('file.xlsx', sheet_name=[0, 1])  # Multiple sheets

# JSON
df = pd.read_json('file.json')
df = pd.read_json('file.json', orient='records')

# SQL
from sqlalchemy import create_engine
engine = create_engine('sqlite:///database.db')
df = pd.read_sql('SELECT * FROM table', engine)
df = pd.read_sql_table('table_name', engine)
df = pd.read_sql_query('SELECT * FROM table', engine)

# HTML
dfs = pd.read_html('http://example.com/table.html')  # Returns list of DataFrames

# Parquet
df = pd.read_parquet('file.parquet')

# HDF5
df = pd.read_hdf('file.h5', 'key')

# Clipboard
df = pd.read_clipboard()
```

### Writing Data

```python
# CSV
df.to_csv('file.csv')
df.to_csv('file.csv', index=False)  # Don't write index
df.to_csv('file.csv', columns=['A', 'B'])  # Only specific columns
df.to_csv('file.csv', sep='\t')  # Tab-separated

# Excel
df.to_excel('file.xlsx', sheet_name='Sheet1')
df.to_excel('file.xlsx', index=False)

# With multiple sheets
with pd.ExcelWriter('file.xlsx') as writer:
    df1.to_excel(writer, sheet_name='Sheet1')
    df2.to_excel(writer, sheet_name='Sheet2')

# JSON
df.to_json('file.json')
df.to_json('file.json', orient='records')

# SQL
df.to_sql('table_name', engine, if_exists='replace')

# Parquet
df.to_parquet('file.parquet')

# HDF5
df.to_hdf('file.h5', 'key')

# Clipboard
df.to_clipboard()
```

## Basic Data Inspection

```python
# Basic info
df.shape  # (rows, columns)
df.size  # Total number of elements
df.info()  # Summary including dtypes and non-null values
df.describe()  # Statistical summary of numeric columns
df.dtypes  # Data types of each column

# First/last rows
df.head()  # First 5 rows
df.head(10)  # First 10 rows
df.tail()  # Last 5 rows
df.tail(10)  # Last 10 rows

# Sample rows
df.sample(n=5)  # 5 random rows
df.sample(frac=0.1)  # 10% of rows

# Column and index names
df.columns  # Column labels
df.index  # Index labels

# Value counts
df['col'].value_counts()  # Counts of unique values
df['col'].value_counts(normalize=True)  # Proportions
df['col'].nunique()  # Number of unique values
df['col'].unique()  # Array of unique values

# Check for missing values
df.isna()  # Boolean mask where True indicates NA/NaN
df.isna().sum()  # Count of missing values per column
df.isna().any()  # Whether each column has any missing values
```

## Selection and Indexing

### Basic Selection

```python
# Single column (returns Series)
df['A']
df.A  # Attribute access (only for valid Python identifiers)

# Multiple columns (returns DataFrame)
df[['A', 'B']]

# Row slicing (label-based if index is not default)
df[0:5]  # First 5 rows

# Boolean indexing
df[df['A'] > 0]  # Rows where A > 0
df[(df['A'] > 0) & (df['B'] < 0)]  # Combine with & (and), | (or)
```

### .loc (Label-based)

```python
# Single value
df.loc['row_label', 'col_label']

# Multiple rows and columns
df.loc[['row1', 'row2'], ['A', 'B']]

# Slicing
df.loc['row1':'row3', 'A':'C']

# All rows or columns
df.loc[:, 'A']  # All rows, column A
df.loc['row1', :]  # Row 'row1', all columns

# Boolean indexing
df.loc[df['A'] > 0, 'B']  # B values where A > 0
```

### .iloc (Position-based)

```python
# Single value
df.iloc[0, 0]  # First element

# Multiple rows and columns
df.iloc[[0, 2], [1, 3]]  # Rows 0 & 2, columns 1 & 3

# Slicing
df.iloc[0:3, 0:2]  # First 3 rows, first 2 columns

# All rows or columns
df.iloc[:, 0]  # All rows, first column
df.iloc[0, :]  # First row, all columns
```

### Other Selection Methods

```python
# Query method (string expressions)
df.query('A > 0 and B < 0')

# Get values
df['A'].values  # NumPy array of values
df[['A', 'B']].to_numpy()  # Multi-column NumPy array

# Selecting by data types
df.select_dtypes(include=['int64', 'float64'])
df.select_dtypes(exclude=['object'])

# First/last rows with .at
df.at[df.index[0], 'A']  # First row, column A
df.at[df.index[-1], 'A']  # Last row, column A

# Get using callable
df.loc[lambda x: x['A'] > 0]
```

## Data Cleaning

### Handling Missing Values

```python
# Check for missing values
df.isna()  # or df.isnull()
df.notna()  # or df.notnull()

# Drop missing values
df.dropna()  # Drop rows with any NA
df.dropna(axis=1)  # Drop columns with any NA
df.dropna(how='all')  # Drop rows where all values are NA
df.dropna(thresh=2)  # Keep rows with at least 2 non-NA values
df.dropna(subset=['A', 'B'])  # Drop rows with NA in specified columns

# Fill missing values
df.fillna(0)  # Replace all NA with 0
df['A'].fillna(df['A'].mean())  # Replace NA with mean
df.fillna(method='ffill')  # Forward fill
df.fillna(method='bfill')  # Backward fill
df.fillna({'A': 0, 'B': 1})  # Different values for different columns
```

### Duplicates

```python
# Check for duplicates
df.duplicated()  # Boolean Series, True for duplicate rows
df.duplicated(subset=['A', 'B'])  # Check only specific columns

# Drop duplicates
df.drop_duplicates()  # Keep first occurrence
df.drop_duplicates(keep='last')  # Keep last occurrence
df.drop_duplicates(keep=False)  # Drop all duplicates
df.drop_duplicates(subset=['A', 'B'])  # Based on specific columns
```

### Data Type Conversion

```python
# Convert types
df['A'] = df['A'].astype('int64')
df['B'] = df['B'].astype('float')
df['C'] = df['C'].astype('str')

# Convert to numeric
pd.to_numeric(df['A'])
pd.to_numeric(df['A'], errors='coerce')  # Invalid values become NaN

# Convert to datetime
pd.to_datetime(df['date'])
pd.to_datetime(df['date'], format='%Y-%m-%d')
pd.to_datetime(df['date'], errors='coerce')  # Invalid dates become NaT

# Convert categorical
df['category'] = df['category'].astype('category')
```

### String Cleaning

```python
# Remove whitespace
df['text'] = df['text'].str.strip()

# Case conversion
df['text'] = df['text'].str.lower()
df['text'] = df['text'].str.upper()

# Replace
df['text'] = df['text'].str.replace('old', 'new')
df['text'] = df['text'].str.replace(r'^prefix', '', regex=True)
```

## Data Transformation

### Adding/Removing Columns

```python
# Add column
df['new_col'] = values_list
df['derived'] = df['A'] + df['B']
df = df.assign(new_col=values_list, derived=lambda x: x['A'] + x['B'])

# Insert column at specific position
df.insert(1, 'new_col', values_list)

# Remove columns
df = df.drop('col_name', axis=1)
df = df.drop(['col1', 'col2'], axis=1)
del df['col_name']
```

### Adding/Removing Rows

```python
# Append row
df = df.append({'A': 1, 'B': 2}, ignore_index=True)  # As dictionary
df = df.append(pd.Series([1, 2], index=['A', 'B']), ignore_index=True)  # As Series

# Concatenate DataFrames
df = pd.concat([df1, df2], ignore_index=True)

# Remove rows
df = df.drop([0, 1])  # Drop by index
df = df.drop(df[df['A'] < 0].index)  # Drop by condition
```

### Apply Operations

```python
# Apply to single column
df['A'] = df['A'] * 2
df['A'] = df['A'].apply(lambda x: x * 2)

# Apply to multiple columns
df[['A', 'B']] = df[['A', 'B']] * 2
df[['A', 'B']] = df[['A', 'B']].apply(lambda x: x * 2)

# Apply row-wise
df['sum'] = df.sum(axis=1)
df = df.apply(lambda row: row['A'] + row['B'], axis=1)

# Apply element-wise with NumPy
df['log'] = np.log(df['A'])
```

### Map Values

```python
# Map values in a column
mapping = {1: 'one', 2: 'two', 3: 'three'}
df['mapped'] = df['A'].map(mapping)

# Replace values
df['A'] = df['A'].replace({1: 100, 2: 200})

# Map with function
df['A'] = df['A'].map(lambda x: x * 2)
```

### Binning and Discretization

```python
# Cut into equal-sized bins
df['binned'] = pd.cut(df['A'], bins=3)
df['binned'] = pd.cut(df['A'], bins=[0, 18, 65, 100], labels=['child', 'adult', 'senior'])

# Quantile-based discretization
df['quantile'] = pd.qcut(df['A'], q=4)  # Quartiles
df['quantile'] = pd.qcut(df['A'], q=[0, 0.25, 0.5, 0.75, 1.0], labels=['Q1', 'Q2', 'Q3', 'Q4'])
```

### Pivot and Reshape

```python
# Pivot (reshape from long to wide format)
pivot_df = df.pivot(index='date', columns='category', values='value')

# Pivot table (with aggregation)
pivot_df = df.pivot_table(index='date', columns='category', values='value', aggfunc='mean')
pivot_df = df.pivot_table(index=['date', 'store'], columns='product', values='sales', aggfunc=['sum', 'mean'])

# Melt (reshape from wide to long format)
melted_df = pd.melt(df, id_vars=['date', 'store'], value_vars=['product1', 'product2'], var_name='product', value_name='sales')

# Stack / Unstack
stacked = df.stack()  # Pivot columns to rows
unstacked = stacked.unstack()  # Pivot rows to columns
```

## Sorting and Ranking

```python
# Sort by values
df = df.sort_values('A')  # Sort by column A
df = df.sort_values(['A', 'B'])  # Sort by multiple columns
df = df.sort_values('A', ascending=False)  # Descending order
df = df.sort_values(['A', 'B'], ascending=[True, False])  # Mixed order

# Sort by index
df = df.sort_index()
df = df.sort_index(ascending=False)

# Ranking
df['rank'] = df['A'].rank()  # Default: average method
df['rank'] = df['A'].rank(method='first')  # First occurrence breaks ties
df['rank'] = df['A'].rank(method='dense')  # No gaps in ranks
df['rank'] = df['A'].rank(ascending=False)  # Descending rank
```

## Grouping and Aggregation

### Basic Grouping

```python
# Group by single column
grouped = df.groupby('category')

# Group by multiple columns
grouped = df.groupby(['category', 'subcategory'])

# Iterate through groups
for name, group in grouped:
    print(name)
    print(group)

# Get specific group
grouped.get_group('specific_category')
```

### Aggregation

```python
# Single aggregation
result = df.groupby('category').sum()
result = df.groupby('category')['value'].sum()

# Multiple aggregations on one column
result = df.groupby('category')['value'].agg(['sum', 'mean', 'count'])

# Different aggregations for different columns
result = df.groupby('category').agg({
    'value1': 'sum',
    'value2': 'mean',
    'value3': ['min', 'max']
})

# Named aggregations (pandas >= 0.25)
result = df.groupby('category').agg(
    total=('value', 'sum'),
    average=('value', 'mean'),
    count=('value', 'count')
)

# Transform (same size as original)
df['group_avg'] = df.groupby('category')['value'].transform('mean')
```

### Grouped Operations

```python
# Apply function to groups
result = df.groupby('category')['value'].apply(lambda x: x - x.mean())

# Filter groups
result = df.groupby('category').filter(lambda x: x['value'].mean() > 10)

# First/last n rows per group
result = df.groupby('category').head(2)  # First 2 rows of each group
result = df.groupby('category').tail(2)  # Last 2 rows of each group

# Size of groups
result = df.groupby('category').size()
```

## Merging and Joining

### Merge DataFrames

```python
# Inner join
result = pd.merge(df1, df2, on='key')
result = df1.merge(df2, on='key')

# Different key names
result = pd.merge(df1, df2, left_on='key1', right_on='key2')

# Multiple keys
result = pd.merge(df1, df2, on=['key1', 'key2'])

# Different join types
result = pd.merge(df1, df2, on='key', how='left')  # Left join
result = pd.merge(df1, df2, on='key', how='right')  # Right join
result = pd.merge(df1, df2, on='key', how='outer')  # Full outer join

# Suffix for overlapping columns
result = pd.merge(df1, df2, on='key', suffixes=('_x', '_y'))
```

### Join DataFrames

```python
# Join on index
result = df1.join(df2)  # Left join by default
result = df1.join(df2, how='inner')  # Inner join

# Join using specific columns
result = df1.join(df2.set_index('key'), on='key')

# Join with different column names
result = df1.join(df2.set_index('key2'), on='key1')
```

### Concatenate DataFrames

```python
# Vertically (stack)
result = pd.concat([df1, df2])
result = pd.concat([df1, df2], axis=0, ignore_index=True)  # Reset index

# Horizontally (side by side)
result = pd.concat([df1, df2], axis=1)

# Join types
result = pd.concat([df1, df2], join='inner')  # Only common columns
result = pd.concat([df1, df2], join='outer')  # All columns (default)

# With keys to create hierarchical index
result = pd.concat([df1, df2], keys=['df1', 'df2'])
```

### Combining Data

```python
# Combine first non-NA values
result = df1.combine_first(df2)

# Update values
result = df1.update(df2)  # Modifies df1 in-place

# Append rows
result = df1.append(df2)
result = df1.append([df2, df3])  # Multiple frames
```

## Time Series

### Creating Time Series

```python
# Date range
dates = pd.date_range(start='2023-01-01', end='2023-01-31')
dates = pd.date_range(start='2023-01-01', periods=31)
dates = pd.date_range(start='2023-01-01', periods=12, freq='M')  # Monthly

# Time range
times = pd.date_range(start='2023-01-01 00:00:00', periods=24, freq='H')

# Periods
periods = pd.period_range(start='2023-01', end='2023-12', freq='M')
```

### Date/Time Components

```python
# Extract components
df['year'] = df['date'].dt.year
df['month'] = df['date'].dt.month
df['day'] = df['date'].dt.day
df['weekday'] = df['date'].dt.weekday  # 0=Monday, 6=Sunday
df['hour'] = df['date'].dt.hour
df['week'] = df['date'].dt.isocalendar().week  # ISO week number

# Boolean properties
df['is_month_end'] = df['date'].dt.is_month_end
df['is_quarter_end'] = df['date'].dt.is_quarter_end
df['is_leap_year'] = df['date'].dt.is_leap_year
```

### Resampling and Frequency Conversion

```python
# Upsample (to higher frequency)
df_daily = df_monthly.resample('D').asfreq()  # No filling
df_daily = df_monthly.resample('D').ffill()  # Forward fill
df_daily = df_monthly.resample('D').bfill()  # Backward fill
df_daily = df_monthly.resample('D').interpolate()  # Interpolate

# Downsample (to lower frequency)
df_monthly = df_daily.resample('M').mean()  # Mean for each month
df_monthly = df_daily.resample('M').agg(['min', 'max', 'mean'])  # Multiple aggregations
```

### Shifting and Lagging

```python
# Shift values
df['previous'] = df['value'].shift(1)  # Shift 1 period back
df['next'] = df['value'].shift(-1)  # Shift 1 period forward

# Percent change
df['pct_change'] = df['value'].pct_change()  # Period-over-period percentage change
df['pct_change_annual'] = df['value'].pct_change(12)  # Year-over-year for monthly data

# Rolling windows
df['rolling_mean'] = df['value'].rolling(window=7).mean()  # 7-day rolling average
df['rolling_std'] = df['value'].rolling(window=7).std()  # 7-day rolling std dev

# Expanding windows
df['cumulative_mean'] = df['value'].expanding().mean()  # Cumulative mean
```

### Time Zone Handling

```python
# Convert time zones
df['date_utc'] = df['date'].dt.tz_localize('UTC')
df['date_ny'] = df['date_utc'].dt.tz_convert('America/New_York')

# Remove time zone
df['date_naive'] = df['date_utc'].dt.tz_localize(None)
```

## String Operations

```python
# Access string methods
df['text'].str.lower()
df['text'].str.upper()
df['text'].str.title()

# String matching
df['text'].str.contains('pattern')
df['text'].str.contains('pattern', case=False)  # Case-insensitive
df['text'].str.startswith('prefix')
df['text'].str.endswith('suffix')
df['text'].str.match(r'^pattern$')  # Regex full match

# Extract and replace
df['text'].str.extract(r'(\d+)')  # Extract first match
df['text'].str.extractall(r'(\d+)')  # Extract all matches
df['text'].str.replace('old', 'new')
df['text'].str.replace(r'pattern', 'repl', regex=True)

# Split and get
df['text'].str.split(',')  # Returns list-like
df['text'].str.split(',', expand=True)  # Returns DataFrame
df['text'].str.get(0)  # Get first element after split
df['text'].str[0]  # Get first character

# Count and find
df['text'].str.count('pattern')
df['text'].str.find('pattern')  # -1 if not found
df['text'].str.len()  # String length

# Pad and strip
df['text'].str.pad(10, side='left', fillchar='0')
df['text'].str.strip()
df['text'].str.lstrip()
df['text'].str.rstrip()
```

## Window Functions

```python
# Rolling window
df['rolling_mean'] = df['value'].rolling(window=3).mean()
df['rolling_sum'] = df['value'].rolling(window=3, min_periods=1).sum()
df['rolling_max'] = df['value'].rolling(window=3, center=True).max()  # Center window

# Expanding window
df['cum_sum'] = df['value'].expanding().sum()
df['cum_max'] = df['value'].expanding().max()

# Exponentially weighted window
df['ewm_mean'] = df['value'].ewm(alpha=0.3).mean()
df['ewm_mean'] = df['value'].ewm(span=10).mean()  # alpha = 2/(span+1)

# Rolling window with group by
df['group_rolling'] = df.groupby('category')['value'].rolling(window=3).mean().reset_index(0, drop=True)
```

## Plotting

```python
# Line plot
df.plot()
df.plot(x='date', y='value')

# Multiple columns
df.plot(y=['A', 'B', 'C'])

# Plot types
df.plot.line()
df.plot.bar()
df.plot.barh()
df.plot.hist()
df.plot.box()
df.plot.scatter(x='A', y='B')
df.plot.density()
df.plot.area()
df.plot.pie(y='value')

# Customization
df.plot(figsize=(10, 6), title='Plot Title', grid=True)
df.plot(color=['r', 'g', 'b'], style=['-', '--', '-.'])

# Subplots
df.plot(subplots=True, layout=(2, 2), figsize=(10, 8))

# Save plot
fig = df.plot().get_figure()
fig.savefig('plot.png')
```

## Performance Tips

```python
# Use efficient data types
df['category'] = df['category'].astype('category')  # For strings with limited unique values
df['int_col'] = df['int_col'].astype('int32')  # Smaller integer type
df['float_col'] = df['float_col'].astype('float32')  # Smaller float type

# Avoid copies
df.loc[:, 'A'] = value  # Doesn't create intermediate copy
df.loc[:, ['A', 'B']] = values  # Better than df[['A', 'B']] = values

# Use vectorized operations
df['sum'] = df['A'] + df['B']  # Better than apply(lambda row: row['A'] + row['B'], axis=1)
df['log'] = np.log(df['A'])  # Better than df['A'].apply(np.log)

# Use evaluation expressions
df.eval('C = A + B')  # Compute new column
df.query('A > 0 and B < 0')  # Filter rows

# Use inplace where appropriate
df.fillna(0, inplace=True)
df.drop('col', axis=1, inplace=True)

# Iterate efficiently
for col in df:  # Iterate column names
    print(col)

for col, series in df.items():  # Iterate columns
    print(col, series.mean())

# Process in chunks
for chunk in pd.read_csv('large_file.csv', chunksize=10000):
    process(chunk)
```

## Configuration

```python
# Display options
pd.set_option('display.max_rows', 100)  # Show more rows
pd.set_option('display.max_columns', 50)  # Show more columns
pd.set_option('display.width', 120)  # Wider display
pd.set_option('display.precision', 2)  # Float precision
pd.set_option('display.max_colwidth', 100)  # Max column width

# Restore defaults
pd.reset_option('display.max_rows')
pd.reset_option('all')  # Reset all options

# Computation options
pd.set_option('compute.use_bottleneck', True)  # Use bottleneck
pd.set_option('compute.use_numexpr', True)  # Use numexpr

# Show options
pd.describe_option('display')  # All display options
```
