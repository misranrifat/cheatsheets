# Java Stream API Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Creating Streams](#creating-streams)
- [Intermediate Operations](#intermediate-operations)
- [Terminal Operations](#terminal-operations)
- [Collectors](#collectors)
- [Parallel Streams](#parallel-streams)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)
- [Common Pitfalls](#common-pitfalls)

## Introduction

The Stream API, introduced in Java 8, provides a functional approach to processing collections of objects. Streams don't store data; they operate on a source, performing operations in a pipeline manner.

```java
// Basic Stream pattern
sourceCollection.stream()
    .intermediateOperation1()
    .intermediateOperation2()
    .terminalOperation();
```

## Creating Streams

### From Collections
```java
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream = list.stream();
Stream<String> parallelStream = list.parallelStream();
```

### From Arrays
```java
String[] array = {"a", "b", "c"};
Stream<String> stream = Arrays.stream(array);
Stream<String> streamOfPart = Arrays.stream(array, 1, 3); // elements at index 1,2
```

### From Static Factory Methods
```java
Stream<String> stream = Stream.of("a", "b", "c");
Stream<String> emptyStream = Stream.empty();
```

### Infinite Streams
```java
// Generate infinite stream with supplier
Stream<Double> randomNumbers = Stream.generate(Math::random);

// Generate infinite stream with unary operator
Stream<Integer> evenNumbers = Stream.iterate(0, n -> n + 2);

// Java 9: iterate with predicate
Stream<Integer> numbersUnder100 = Stream.iterate(0, n -> n < 100, n -> n + 1);
```

### Primitive Streams
```java
IntStream intStream = IntStream.range(1, 5);        // 1, 2, 3, 4
IntStream intStream2 = IntStream.rangeClosed(1, 5); // 1, 2, 3, 4, 5
LongStream longStream = LongStream.rangeClosed(1, 5);
DoubleStream doubleStream = DoubleStream.of(1.1, 2.2, 3.3);

// Convert to/from object streams
Stream<Integer> boxedStream = intStream.boxed();
IntStream unboxedStream = Stream.of(1, 2, 3).mapToInt(Integer::intValue);
```

### From Other Sources
```java
// From Stream of Strings to Stream of chars
Stream<String> words = Stream.of("hello", "world");
IntStream chars = words.flatMapToInt(s -> s.chars());

// From File
Stream<String> lines = Files.lines(Paths.get("file.txt"));

// From regex pattern
Stream<String> words = Pattern.compile("\\W").splitAsStream("hello world");
```

## Intermediate Operations
These operations transform a stream into another stream. They are lazy and only executed when a terminal operation is invoked.

### Filtering
```java
// Keep elements matching the predicate
Stream<T> filtered = stream.filter(predicate);

// Example: numbers greater than 5
List<Integer> result = Stream.of(1, 6, 3, 8, 2)
    .filter(num -> num > 5)
    .collect(Collectors.toList()); // [6, 8]
```

### Mapping
```java
// Transform elements
Stream<R> mapped = stream.map(function);
IntStream mappedInt = stream.mapToInt(toIntFunction);
LongStream mappedLong = stream.mapToLong(toLongFunction);
DoubleStream mappedDouble = stream.mapToDouble(toDoubleFunction);

// Example: convert strings to uppercase
List<String> result = Stream.of("hello", "world")
    .map(String::toUpperCase)
    .collect(Collectors.toList()); // ["HELLO", "WORLD"]
```

### FlatMapping
```java
// Map elements to streams and flatten the result
Stream<R> flatMapped = stream.flatMap(functionReturningStream);

// Example: flatten nested lists
List<List<Integer>> nestedList = Arrays.asList(
    Arrays.asList(1, 2), 
    Arrays.asList(3, 4)
);
List<Integer> result = nestedList.stream()
    .flatMap(Collection::stream)
    .collect(Collectors.toList()); // [1, 2, 3, 4]
```

### Distinct
```java
// Remove duplicates (uses equals())
Stream<T> distinct = stream.distinct();

// Example
List<Integer> result = Stream.of(1, 2, 2, 3, 1)
    .distinct()
    .collect(Collectors.toList()); // [1, 2, 3]
```

### Sorting
```java
// Sort elements (must be Comparable)
Stream<T> sorted = stream.sorted();

// Sort using custom comparator
Stream<T> sorted = stream.sorted(comparator);

// Example: sort by string length
List<String> result = Stream.of("banana", "apple", "cherry")
    .sorted(Comparator.comparing(String::length))
    .collect(Collectors.toList()); // ["apple", "banana", "cherry"]
```

### Peeking (Debugging)
```java
// Perform action on each element without modifying stream
Stream<T> peeked = stream.peek(action);

// Example: log elements
List<Integer> result = Stream.of(1, 2, 3)
    .peek(e -> System.out.println("Processing: " + e))
    .map(e -> e * 2)
    .collect(Collectors.toList()); // [2, 4, 6]
```

### Limiting
```java
// Limit to first n elements
Stream<T> limited = stream.limit(n);

// Example
List<Integer> result = Stream.of(1, 2, 3, 4, 5)
    .limit(3)
    .collect(Collectors.toList()); // [1, 2, 3]
```

### Skipping
```java
// Skip first n elements
Stream<T> skipped = stream.skip(n);

// Example
List<Integer> result = Stream.of(1, 2, 3, 4, 5)
    .skip(2)
    .collect(Collectors.toList()); // [3, 4, 5]
```

### dropWhile and takeWhile (Java 9+)
```java
// Take elements while predicate is true (stops at first false)
Stream<T> taken = stream.takeWhile(predicate);

// Drop elements while predicate is true (starts at first false)
Stream<T> dropped = stream.dropWhile(predicate);

// Example
List<Integer> result = Stream.of(2, 4, 6, 7, 8, 10)
    .takeWhile(n -> n % 2 == 0)
    .collect(Collectors.toList()); // [2, 4, 6]

List<Integer> result2 = Stream.of(2, 4, 6, 7, 8, 10)
    .dropWhile(n -> n % 2 == 0)
    .collect(Collectors.toList()); // [7, 8, 10]
```

## Terminal Operations
These operations produce a result or side-effect and terminate the stream pipeline.

### forEach
```java
// Execute action for each element
stream.forEach(action);

// Example
Stream.of(1, 2, 3).forEach(System.out::println);

// Ordered version (respects encounter order)
stream.forEachOrdered(action);
```

### Collectors (toList, toSet, etc.)
```java
// Collect elements into a collection
List<T> list = stream.collect(Collectors.toList());
Set<T> set = stream.collect(Collectors.toSet());
Collection<T> collection = stream.collect(Collectors.toCollection(ArrayList::new));
```

### reduce
```java
// Reduce to a single value
Optional<T> reduced = stream.reduce(binaryOperator);
T reduced = stream.reduce(identity, binaryOperator);
U reduced = stream.reduce(identity, accumulator, combiner); // For parallel streams

// Example: sum integers
int sum = Stream.of(1, 2, 3, 4)
    .reduce(0, Integer::sum); // 10
```

### min/max
```java
// Find minimum element
Optional<T> min = stream.min(comparator);

// Find maximum element
Optional<T> max = stream.max(comparator);

// Example
Optional<Integer> min = Stream.of(5, 2, 8, 1)
    .min(Integer::compare); // Optional[1]

Optional<String> longest = Stream.of("apple", "banana", "cherry")
    .max(Comparator.comparing(String::length)); // Optional[banana]
```

### count
```java
// Count elements
long count = stream.count();

// Example
long count = Stream.of(1, 2, 3).count(); // 3
```

### anyMatch, allMatch, noneMatch
```java
// Check if any element matches the predicate
boolean any = stream.anyMatch(predicate);

// Check if all elements match the predicate
boolean all = stream.allMatch(predicate);

// Check if no element matches the predicate
boolean none = stream.noneMatch(predicate);

// Examples
boolean hasEven = Stream.of(1, 2, 3).anyMatch(n -> n % 2 == 0); // true
boolean allEven = Stream.of(1, 2, 3).allMatch(n -> n % 2 == 0); // false
boolean noNegatives = Stream.of(1, 2, 3).noneMatch(n -> n < 0); // true
```

### findFirst, findAny
```java
// Find first element
Optional<T> first = stream.findFirst();

// Find any element (useful for parallel streams)
Optional<T> any = stream.findAny();

// Examples
Optional<Integer> first = Stream.of(1, 2, 3).findFirst(); // Optional[1]
Optional<Integer> any = Stream.of(1, 2, 3).findAny(); // Usually Optional[1], but no guarantee
```

### toArray
```java
// Convert to array
Object[] array = stream.toArray();

// Specify array type
T[] array = stream.toArray(size -> (T[]) new Object[size]);
T[] array = stream.toArray(ArrayType[]::new); // Java 8+

// Example
String[] array = Stream.of("a", "b", "c").toArray(String[]::new);
```

## Collectors
The `Collectors` utility class provides methods for common reduction operations.

### Basic Collectors
```java
// To Collection
List<T> list = stream.collect(Collectors.toList());
Set<T> set = stream.collect(Collectors.toSet());
LinkedList<T> linkedList = stream.collect(Collectors.toCollection(LinkedList::new));

// To Map
Map<K, V> map = stream.collect(Collectors.toMap(
    keyMapper,    // Function to extract key
    valueMapper,  // Function to extract value
    mergeFunction // Optional: how to handle duplicate keys
));

// Example: create a map of names to their lengths
Map<String, Integer> nameToLength = Stream.of("Alice", "Bob", "Charlie")
    .collect(Collectors.toMap(
        name -> name,
        String::length
    )); // {"Alice"=5, "Bob"=3, "Charlie"=7}

// With duplicate key resolution
Map<Integer, String> lengthToName = Stream.of("Alice", "Bob", "David")
    .collect(Collectors.toMap(
        String::length,
        name -> name,
        (existing, replacement) -> existing + ", " + replacement
    )); // {5="Alice, David", 3="Bob"}
```

### Joining
```java
// Join strings
String joined = stream.collect(Collectors.joining());
String joinedWithDelimiter = stream.collect(Collectors.joining(", "));
String joinedWithDelimiterAndPrefixSuffix = stream.collect(Collectors.joining(", ", "[", "]"));

// Example
String result = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.joining(", ")); // "apple, banana, cherry"
```

### Counting
```java
// Count elements
long count = stream.collect(Collectors.counting());
```

### Summing
```java
// Sum numeric values
int sum = stream.collect(Collectors.summingInt(valueExtractor));
long sum = stream.collect(Collectors.summingLong(valueExtractor));
double sum = stream.collect(Collectors.summingDouble(valueExtractor));

// Example
int totalLength = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.summingInt(String::length)); // 17
```

### Averaging
```java
// Calculate average of numeric values
double avg = stream.collect(Collectors.averagingInt(valueExtractor));
double avg = stream.collect(Collectors.averagingLong(valueExtractor));
double avg = stream.collect(Collectors.averagingDouble(valueExtractor));

// Example
double avgLength = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.averagingInt(String::length)); // 5.666...
```

### Min/Max
```java
// Find minimum or maximum by comparator
Optional<T> min = stream.collect(Collectors.minBy(comparator));
Optional<T> max = stream.collect(Collectors.maxBy(comparator));

// Example
Optional<String> shortest = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.minBy(Comparator.comparing(String::length))); // Optional[apple]
```

### Summarizing
```java
// Get statistics (count, sum, min, average, max)
IntSummaryStatistics stats = stream.collect(Collectors.summarizingInt(valueExtractor));
LongSummaryStatistics stats = stream.collect(Collectors.summarizingLong(valueExtractor));
DoubleSummaryStatistics stats = stream.collect(Collectors.summarizingDouble(valueExtractor));

// Example
IntSummaryStatistics stats = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.summarizingInt(String::length));
// stats.getCount() = 3
// stats.getSum() = 17
// stats.getMin() = 5
// stats.getMax() = 6
// stats.getAverage() = 5.666...
```

### Grouping
```java
// Group elements by key
Map<K, List<T>> groups = stream.collect(Collectors.groupingBy(classifier));

// Group with custom collector
Map<K, D> groups = stream.collect(Collectors.groupingBy(
    classifier,
    downstream
));

// Group with custom map factory and collector
Map<K, D> groups = stream.collect(Collectors.groupingBy(
    classifier,
    mapFactory,
    downstream
));

// Examples
Map<Integer, List<String>> byLength = Stream.of("apple", "banana", "cherry", "date")
    .collect(Collectors.groupingBy(String::length));
// {4=[date], 5=[apple], 6=[banana, cherry]}

// Group by length and count occurrences
Map<Integer, Long> lengthCounts = Stream.of("apple", "banana", "cherry", "date")
    .collect(Collectors.groupingBy(
        String::length,
        Collectors.counting()
    ));
// {4=1, 5=1, 6=2}
```

### Partitioning
```java
// Partition elements into true/false groups
Map<Boolean, List<T>> partition = stream.collect(Collectors.partitioningBy(predicate));

// With downstream collector
Map<Boolean, D> partition = stream.collect(Collectors.partitioningBy(
    predicate,
    downstream
));

// Example
Map<Boolean, List<String>> evenLengthPartition = Stream.of("apple", "banana", "cherry")
    .collect(Collectors.partitioningBy(s -> s.length() % 2 == 0));
// {false=[apple], true=[banana, cherry]}
```

### Teeing (Java 12+)
```java
// Apply two collectors and combine their results
R result = stream.collect(Collectors.teeing(
    collector1,
    collector2,
    biFunction
));

// Example: calculate average directly
double average = Stream.of(1, 2, 3, 4)
    .collect(Collectors.teeing(
        Collectors.summingDouble(i -> i),
        Collectors.counting(),
        (sum, count) -> sum / count
    )); // 2.5
```

## Parallel Streams
Parallel streams leverage the multicore architecture by splitting the work across multiple threads.

```java
// Create parallel stream from collection
Stream<T> parallel = collection.parallelStream();

// Convert sequential stream to parallel
Stream<T> parallel = stream.parallel();

// Check if stream is parallel
boolean isParallel = stream.isParallel();

// Convert parallel stream to sequential
Stream<T> sequential = parallel.sequential();
```

### Parallel Considerations
- Use for CPU-intensive operations on large data sets
- Operations should be stateless and non-interfering
- Watch for thread safety with shared state or mutable reductions
- Some operations may perform worse in parallel (e.g., small data sets, IO-bound work)
- Order matters: `filter` before `map` to reduce workload

## Best Practices

### Do's
- Use meaningful variable names for streams
- Keep the pipeline readable with line breaks
- Filter early to reduce processing downstream
- Close streams that use IO resources (try-with-resources)
- Use primitive streams for numeric operations
- Prefer method references over lambda expressions when possible

### Don'ts
- Don't use streams for simple iterations
- Don't modify source collection while streaming
- Don't reuse a stream after terminal operation
- Don't overuse parallel streams
- Don't use parallel streams with ordered operations that require communication

## Common Patterns

### Filter-Map-Collect
```java
List<String> result = persons.stream()
    .filter(person -> person.getAge() > 21)
    .map(Person::getName)
    .collect(Collectors.toList());
```

### Grouping and Aggregating
```java
Map<Department, Double> avgSalaryByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.averagingDouble(Employee::getSalary)
    ));
```

### Finding Elements
```java
Optional<Person> person = persons.stream()
    .filter(p -> p.getName().equals("John"))
    .findFirst();
```

### Processing in Batches
```java
List<List<T>> batches = IntStream.range(0, (items.size() + batchSize - 1) / batchSize)
    .mapToObj(i -> items.stream()
        .skip(i * batchSize)
        .limit(batchSize)
        .collect(Collectors.toList()))
    .collect(Collectors.toList());
```

### Zipping Two Lists
```java
List<C> result = IntStream.range(0, Math.min(list1.size(), list2.size()))
    .mapToObj(i -> combiner.apply(list1.get(i), list2.get(i)))
    .collect(Collectors.toList());
```

## Common Pitfalls

### Reusing Streams
```java
// WRONG - Stream has already been operated upon or closed
Stream<String> stream = list.stream();
stream.forEach(System.out::println);
long count = stream.count(); // IllegalStateException

// CORRECT - Create a new stream for each pipeline
list.stream().forEach(System.out::println);
long count = list.stream().count();
```

### Stream in a Loop
```java
// WRONG - Creating new streams in loops
for (int i = 0; i < 10; i++) {
    long count = list.stream().filter(predicate).count();
}

// CORRECT - Create stream once, outside the loop
Stream<T> stream = list.stream().filter(predicate);
for (int i = 0; i < 10; i++) {
    long count = stream.collect(Collectors.counting());
    // But this still won't work! Stream is consumed after terminal operation
}

// BETTER - Do the looping in the stream
Map<Integer, Long> countsByIteration = IntStream.range(0, 10)
    .boxed()
    .collect(Collectors.toMap(
        i -> i,
        i -> list.stream().filter(predicate).count()
    ));
```

### Unintended Side Effects
```java
// WRONG - Side effects in streams can lead to inconsistent results
List<String> result = new ArrayList<>();
stream.forEach(item -> result.add(item.toUpperCase())); // Side-effect!

// CORRECT - Use collectors instead
List<String> result = stream
    .map(String::toUpperCase)
    .collect(Collectors.toList());
```

### Neglecting Stream Closure
```java
// WRONG - Resource leak
Stream<String> lines = Files.lines(Paths.get("file.txt"));
lines.forEach(System.out::println);

// CORRECT - Use try-with-resources
try (Stream<String> lines = Files.lines(Paths.get("file.txt"))) {
    lines.forEach(System.out::println);
}
```

### Misunderstanding Short-Circuiting
```java
// WRONG - Expensive operation performed on all elements
boolean hasNegative = numbers.stream()
    .map(expensiveOperation::apply)
    .anyMatch(n -> n < 0);

// CORRECT - Filter first, then transform
boolean hasNegative = numbers.stream()
    .filter(n -> n < 0)
    .map(expensiveOperation::apply)
    .findAny()
    .isPresent();
```
