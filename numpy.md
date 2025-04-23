# NumPy Cheatsheet

## Table of Contents
- [Importing NumPy](#importing-numpy)
- [Array Creation](#array-creation)
- [Array Properties](#array-properties)
- [Array Indexing](#array-indexing)
- [Array Reshaping](#array-reshaping)
- [Array Operations](#array-operations)
- [Mathematical Functions](#mathematical-functions)
- [Statistical Functions](#statistical-functions)
- [Linear Algebra](#linear-algebra)
- [Random Numbers](#random-numbers)
- [Boolean Operations](#boolean-operations)
- [Set Operations](#set-operations)
- [Array Manipulation](#array-manipulation)
- [File I/O](#file-io)
- [Optimization Tips](#optimization-tips)

## Importing NumPy
```python
import numpy as np
```

## Array Creation

### Basic Arrays
```python
# From Python lists
np.array([1, 2, 3])                      # 1D array
np.array([[1, 2, 3], [4, 5, 6]])         # 2D array
np.array([1, 2, 3], dtype=float)         # Specify data type

# Special arrays
np.zeros((3, 4))                         # 3x4 array of zeros
np.ones((2, 3, 4))                       # 2x3x4 array of ones
np.empty((2, 3))                         # Uninitialized array (values from memory)
np.identity(3)                           # 3x3 identity matrix
np.eye(3, 5, k=1)                        # Array with ones on the k-th diagonal
```

### Sequences
```python
np.arange(10)                            # 0 to 9
np.arange(2, 10, 2)                      # 2 to 8 with step 2
np.linspace(0, 1, 5)                     # 5 evenly spaced points between 0 and 1
np.logspace(0, 3, 4)                     # 4 logarithmically spaced points from 10^0 to 10^3
```

### Copying Arrays
```python
a = np.array([1, 2, 3])
b = a                                    # Reference, NOT a copy
c = a.copy()                             # Create a deep copy
d = a.view()                             # Create a shallow copy
```

## Array Properties

```python
arr = np.array([[1, 2, 3], [4, 5, 6]])
arr.shape                                # (2, 3) - dimensions
arr.ndim                                 # 2 - number of dimensions
arr.size                                 # 6 - total number of elements
arr.dtype                                # int64 - data type
arr.itemsize                             # 8 - size in bytes of each element
arr.nbytes                               # 48 - total bytes consumed by elements
```

## Array Indexing

### Basic Indexing
```python
arr = np.array([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]])
arr[0, 0]                                # 1 - first element
arr[2, 3]                                # 12 - last element
arr[0]                                   # [1, 2, 3, 4] - first row
```

### Slicing
```python
arr[0:2]                                 # First 2 rows
arr[:, 1:3]                              # 2nd and 3rd columns
arr[1:, :2]                              # 2nd+ rows and first 2 columns
```

### Advanced Indexing
```python
arr[[0, 2], :]                           # 1st and 3rd rows
arr[:, [1, 3]]                           # 2nd and 4th columns
arr[[0, 2], [1, 3]]                      # Elements at (0,1) and (2,3)

# Boolean indexing
mask = arr > 5
arr[mask]                                # All elements > 5
arr[arr % 2 == 0]                        # All even elements
```

## Array Reshaping

```python
arr = np.arange(12)
arr.reshape(3, 4)                        # Reshape to 3x4 array
arr.reshape(3, -1)                       # Reshape to 3 rows (columns auto)
arr.flatten()                            # Flatten to 1D array (returns copy)
arr.ravel()                              # Flatten to 1D array (view if possible)
arr.transpose()                          # Transpose dimensions
arr.T                                    # Shorthand for transpose
arr.swapaxes(0, 1)                       # Swap axes 0 and 1
```

## Array Operations

### Element-wise Operations
```python
a = np.array([1, 2, 3])
b = np.array([4, 5, 6])

a + b                                    # [5, 7, 9]
a - b                                    # [-3, -3, -3]
a * b                                    # [4, 10, 18]
a / b                                    # [0.25, 0.4, 0.5]
a ** 2                                   # [1, 4, 9]
a > 2                                    # [False, False, True]
```

### Broadcasting
```python
a = np.array([[1, 2, 3], [4, 5, 6]])
a + 1                                    # Add 1 to each element
a * 2                                    # Multiply each element by 2
a + np.array([10, 20, 30])               # Add vector to each row
```

### Universal Functions (ufuncs)
```python
np.add(a, b)                             # a + b
np.subtract(a, b)                        # a - b
np.multiply(a, b)                        # a * b
np.divide(a, b)                          # a / b
np.power(a, 2)                           # a ** 2
np.mod(a, 2)                             # a % 2
```

## Mathematical Functions

```python
a = np.array([0, np.pi/2, np.pi])
np.sin(a)                                # [0.0, 1.0, 0.0]
np.cos(a)                                # [1.0, 0.0, -1.0]
np.tan(a)                                # [0.0, 16331239353195370.0, 0.0]
np.exp(a)                                # Exponential: e^x
np.log(a)                                # Natural logarithm (excludes 0 element - will be nan)
np.log10(a)                              # Base-10 logarithm
np.sqrt(a)                               # Square root

# Ceil, floor, round
np.ceil(np.array([1.1, 2.5, 3.9]))       # [2., 3., 4.]
np.floor(np.array([1.1, 2.5, 3.9]))      # [1., 2., 3.]
np.round(np.array([1.1, 2.5, 3.9]))      # [1., 2., 4.]
```

## Statistical Functions

```python
a = np.array([1, 2, 3, 4])
np.min(a)                                # 1
np.max(a)                                # 4
np.mean(a)                               # 2.5
np.median(a)                             # 2.5
np.std(a)                                # Standard deviation
np.var(a)                                # Variance
np.sum(a)                                # 10 - Sum of all elements
np.sum(a, axis=0)                        # Sum along first axis
np.cumsum(a)                             # [1, 3, 6, 10] - Cumulative sum
np.percentile(a, 50)                     # 50th percentile (median)

# For 2D arrays
b = np.array([[1, 2], [3, 4]])
np.min(b, axis=0)                        # [1, 2] - Min of each column
np.max(b, axis=1)                        # [2, 4] - Max of each row
```

## Linear Algebra

```python
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])

# Matrix multiplication
np.dot(a, b)                             # Standard dot product
a @ b                                    # Matrix multiplication (Python 3.5+)
np.matmul(a, b)                          # Matrix multiplication

# Other operations
np.linalg.det(a)                         # Determinant
np.linalg.inv(a)                         # Inverse
np.linalg.eig(a)                         # Eigenvalues and eigenvectors
np.linalg.svd(a)                         # Singular Value Decomposition
np.linalg.norm(a)                        # Frobenius norm

# Solving linear equations: Ax = b
A = np.array([[1, 2], [3, 4]])
b = np.array([5, 6])
x = np.linalg.solve(A, b)                # Solution to Ax = b
```

## Random Numbers

```python
# Set seed for reproducibility
np.random.seed(42)

# Basic random distributions
np.random.rand(3, 2)                     # 3x2 array of random floats from [0,1)
np.random.randn(3, 2)                    # 3x2 array from standard normal distribution
np.random.randint(1, 10, size=(3, 2))    # 3x2 array of random integers from [1,10)

# Other distributions
np.random.normal(0, 1, size=(3, 2))      # Normal/Gaussian distribution with mean=0, std=1
np.random.uniform(0, 1, size=(3, 2))     # Uniform distribution
np.random.binomial(10, 0.5, size=(3, 2)) # Binomial distribution

# Random sampling
a = np.arange(10)
np.random.shuffle(a)                     # Shuffle array in-place
np.random.choice(a, size=5)              # Random sample without replacement
np.random.choice(a, size=5, replace=True)# Random sample with replacement
```

## Boolean Operations

```python
a = np.array([True, False, True])
b = np.array([False, False, True])

np.logical_and(a, b)                     # Element-wise AND: [False, False, True]
np.logical_or(a, b)                      # Element-wise OR: [True, False, True]
np.logical_not(a)                        # Element-wise NOT: [False, True, False]
np.logical_xor(a, b)                     # Element-wise XOR: [True, False, False]

# All and any
np.all(a)                                # False (are all elements True?)
np.any(a)                                # True (are any elements True?)
np.all(a, axis=0)                        # For multi-dimensional arrays along axis
```

## Set Operations

```python
a = np.array([1, 2, 3, 4])
b = np.array([3, 4, 5, 6])

np.unique(a)                             # Unique elements in a: [1, 2, 3, 4]
np.intersect1d(a, b)                     # Intersection: [3, 4]
np.union1d(a, b)                         # Union: [1, 2, 3, 4, 5, 6]
np.setdiff1d(a, b)                       # Set difference: [1, 2]
np.in1d(a, b)                            # Test if elements in a are also in b: [F, F, T, T]
```

## Array Manipulation

### Joining Arrays
```python
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])

np.concatenate((a, b), axis=0)           # Vertical concatenation
np.concatenate((a, b), axis=1)           # Horizontal concatenation
np.vstack((a, b))                        # Same as concatenate with axis=0
np.hstack((a, b))                        # Same as concatenate with axis=1
np.column_stack((a, b))                  # Stack 1D arrays as columns
np.row_stack((a, b))                     # Same as vstack
```

### Splitting Arrays
```python
a = np.arange(9)
np.split(a, 3)                           # Split into 3 equal parts
np.split(a, [3, 6])                      # Split at indices 3 and 6

a = np.arange(16).reshape(4, 4)
np.hsplit(a, 2)                          # Split horizontally into 2
np.vsplit(a, 2)                          # Split vertically into 2
```

### Other Manipulation
```python
a = np.array([1, 2, 3, 4, 5])
np.insert(a, 2, 10)                      # Insert 10 at position 2
np.delete(a, 2)                          # Delete element at position 2
np.append(a, [6, 7])                     # Append elements
np.resize(a, (2, 3))                     # Resize to shape (2, 3)
np.sort(a)                               # Sort array
np.argsort(a)                            # Indices that would sort the array
np.flip(a)                               # Reverse the array
```

## File I/O

```python
# Save and load arrays in NumPy's .npy format
a = np.array([1, 2, 3, 4])
np.save('array.npy', a)                  # Save array to file
b = np.load('array.npy')                 # Load array from file

# Save and load multiple arrays in .npz format
np.savez('arrays.npz', a=a, b=b)         # Save multiple arrays
data = np.load('arrays.npz')             # Load .npz file
data['a']                                # Access array 'a'

# Text files
np.savetxt('array.txt', a, delimiter=',')# Save as CSV
c = np.loadtxt('array.txt', delimiter=',')# Load CSV
```

## Optimization Tips

- Use vectorized operations instead of loops
- Use broadcasting instead of explicit loops
- Use `np.where` for conditional operations
- Use `numexpr` for complex expressions
- Use proper dtype to save memory
- Consider using `numba` for JIT compilation
- Use memory-mapped files (`np.memmap`) for large datasets

```python
# Example: conditional operation with np.where
a = np.array([1, 2, 3, 4])
np.where(a > 2, a, 0)                    # [0, 0, 3, 4]

# Example: using appropriate dtype
np.array([1, 2, 3], dtype=np.int8)       # Uses 1 byte per element
```
