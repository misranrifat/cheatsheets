# Java Collections Framework Cheatsheet

## Table of Contents
- [Collection Hierarchy](#collection-hierarchy)
- [List Implementations](#list-implementations)
- [Set Implementations](#set-implementations)
- [Queue Implementations](#queue-implementations)
- [Map Implementations](#map-implementations)
- [Utility Classes](#utility-classes)
- [Common Operations](#common-operations)
- [Iteration Techniques](#iteration-techniques)
- [Algorithms](#algorithms)
- [Concurrent Collections](#concurrent-collections)
- [Java 8+ Enhancements](#java-8-enhancements)

## Collection Hierarchy

```
java.util.Collection (interface)
├── List (interface) - Ordered collection, allows duplicates
│   ├── ArrayList - Dynamic array implementation
│   ├── LinkedList - Doubly-linked list implementation
│   └── Vector - Thread-safe dynamic array (legacy)
│       └── Stack - LIFO stack (legacy)
├── Set (interface) - No duplicates allowed
│   ├── HashSet - Uses HashMap, no ordering guarantees
│   ├── LinkedHashSet - HashSet with insertion order
│   └── SortedSet (interface)
│       └── NavigableSet (interface)
│           └── TreeSet - Red-black tree implementation
└── Queue (interface) - Typically FIFO (except for priority queues)
    ├── PriorityQueue - Heap implementation
    ├── LinkedList - Also implements List
    └── Deque (interface) - Double-ended queue
        ├── ArrayDeque - Resizable array implementation
        └── LinkedList - Also implements List
```

```
java.util.Map (interface) - Key-value pairs, no duplicate keys
├── HashMap - General purpose hash table
├── LinkedHashMap - HashMap with insertion order
├── Hashtable - Thread-safe hash table (legacy)
│   └── Properties - Maps strings to strings (legacy)
└── SortedMap (interface)
    └── NavigableMap (interface)
        └── TreeMap - Red-black tree implementation
```

## List Implementations

### ArrayList
```java
List<String> list = new ArrayList<>();  // Initial capacity 10
List<String> list = new ArrayList<>(20);  // Initial capacity 20
```

- **Characteristics**: 
  - Fast random access: O(1)
  - Slow insertions/deletions in the middle: O(n)
  - Dynamic resizing
  - Not synchronized

### LinkedList
```java
List<String> list = new LinkedList<>();
Deque<String> deque = new LinkedList<>();
```

- **Characteristics**: 
  - Fast insertions/deletions: O(1) if position is known
  - Slow random access: O(n)
  - Implements both List and Deque interfaces
  - Not synchronized

### Vector (Legacy)
```java
List<String> vector = new Vector<>();
```

- **Characteristics**: 
  - Synchronized (thread-safe)
  - Otherwise similar to ArrayList
  - Considered legacy; prefer ArrayList with explicit synchronization

### Stack (Legacy)
```java
Stack<String> stack = new Stack<>();
```

- **Characteristics**: 
  - LIFO (Last-In-First-Out)
  - Extends Vector
  - Consider using ArrayDeque instead

## Set Implementations

### HashSet
```java
Set<String> set = new HashSet<>();
Set<String> set = new HashSet<>(collection);  // Initialize with elements
```

- **Characteristics**: 
  - Fast operations: O(1) average
  - No order guarantees
  - Allows null element
  - Not synchronized

### LinkedHashSet
```java
Set<String> set = new LinkedHashSet<>();
```

- **Characteristics**: 
  - Preserves insertion order
  - Slightly slower than HashSet
  - Allows null element
  - Not synchronized

### TreeSet
```java
Set<String> set = new TreeSet<>();  // Natural ordering
Set<String> set = new TreeSet<>(comparator);  // Custom ordering
```

- **Characteristics**: 
  - Elements stored in sorted order
  - Operations: O(log n)
  - Does not allow null
  - Not synchronized
  - Implements NavigableSet interface

## Queue Implementations

### PriorityQueue
```java
Queue<String> queue = new PriorityQueue<>();  // Natural ordering
Queue<Task> queue = new PriorityQueue<>(comparator);  // Custom ordering
```

- **Characteristics**: 
  - Heap-based priority queue
  - Head is the smallest element (by default)
  - O(log n) for insertion/deletion
  - O(1) for inspection
  - Not synchronized

### ArrayDeque
```java
Deque<String> deque = new ArrayDeque<>();
Queue<String> queue = new ArrayDeque<>();  // Used as a queue
Deque<String> stack = new ArrayDeque<>();  // Used as a stack
```

- **Characteristics**: 
  - Faster than Stack and LinkedList
  - Resizable array implementation
  - Not synchronized
  - Null elements not allowed

## Map Implementations

### HashMap
```java
Map<String, Integer> map = new HashMap<>();
Map<String, Integer> map = new HashMap<>(capacity, loadFactor);
```

- **Characteristics**: 
  - O(1) average time for get/put
  - No ordering guarantees
  - Allows one null key and multiple null values
  - Not synchronized

### LinkedHashMap
```java
Map<String, Integer> map = new LinkedHashMap<>();  // Insertion-order
Map<String, Integer> map = new LinkedHashMap<>(16, 0.75f, true);  // Access-order (LRU)
```

- **Characteristics**: 
  - Preserves insertion order (by default)
  - Can be configured to maintain access order (LRU cache)
  - Slightly slower than HashMap
  - Not synchronized

### TreeMap
```java
Map<String, Integer> map = new TreeMap<>();  // Natural key ordering
Map<CustomKey, Integer> map = new TreeMap<>(comparator);  // Custom key ordering
```

- **Characteristics**: 
  - Red-black tree implementation
  - Keys stored in sorted order
  - O(log n) operations
  - No null keys (null values OK)
  - Not synchronized
  - Implements NavigableMap interface

### Hashtable (Legacy)
```java
Map<String, Integer> map = new Hashtable<>();
```

- **Characteristics**: 
  - Synchronized (thread-safe)
  - No null keys or values
  - Considered legacy; prefer HashMap with explicit synchronization

## Utility Classes

### Collections
```java
// Create immutable collections
List<String> list = Collections.unmodifiableList(originalList);
Set<String> set = Collections.unmodifiableSet(originalSet);
Map<String, Integer> map = Collections.unmodifiableMap(originalMap);

// Synchronized wrappers
List<String> syncList = Collections.synchronizedList(list);
Set<String> syncSet = Collections.synchronizedSet(set);
Map<String, Integer> syncMap = Collections.synchronizedMap(map);

// Singleton collections
Set<String> singletonSet = Collections.singleton("element");
List<String> singletonList = Collections.singletonList("element");
Map<String, Integer> singletonMap = Collections.singletonMap("key", 1);

// Empty collections
List<String> emptyList = Collections.emptyList();
Set<String> emptySet = Collections.emptySet();
Map<String, Integer> emptyMap = Collections.emptyMap();

// Binary search (list must be sorted)
int index = Collections.binarySearch(sortedList, key);

// Other utilities
Collections.sort(list);  // Natural ordering
Collections.sort(list, comparator);  // Custom ordering
Collections.shuffle(list);  // Random order
Collections.reverse(list);  // Reverse order
Collections.swap(list, i, j);  // Swap elements
Collections.fill(list, obj);  // Replace all elements
Collections.copy(dest, src);  // Copy elements
Collections.min(collection);  // Smallest element
Collections.max(collection);  // Largest element
Collections.disjoint(c1, c2);  // Test for no common elements
Collections.frequency(collection, obj);  // Count occurrences
```

### Arrays
```java
// Sort
Arrays.sort(array);  // Natural ordering
Arrays.sort(array, comparator);  // Custom ordering
Arrays.parallelSort(array);  // Java 8+, parallel sorting

// Search
int index = Arrays.binarySearch(sortedArray, key);

// Fill and Copy
Arrays.fill(array, value);
T[] copy = Arrays.copyOf(original, newLength);
T[] copy = Arrays.copyOfRange(original, from, to);

// Compare
boolean equal = Arrays.equals(array1, array2);
int result = Arrays.compare(array1, array2);  // Java 9+

// Convert
List<String> list = Arrays.asList(array);  // Fixed-size list view
Stream<String> stream = Arrays.stream(array);  // Java 8+

// To String
String str = Arrays.toString(array);
String deepStr = Arrays.deepToString(multiDimensionalArray);

// Parallel operations (Java 8+)
Arrays.parallelPrefix(array, BinaryOperator)
Arrays.parallelSetAll(array, IntFunction)
```

## Common Operations

### Collection Operations
```java
// Basic Operations
collection.add(element);
collection.remove(element);
collection.contains(element);
collection.size();
collection.isEmpty();
collection.clear();

// Bulk Operations
collection.addAll(otherCollection);
collection.removeAll(otherCollection);
collection.retainAll(otherCollection);
collection.containsAll(otherCollection);

// Array Conversion
Object[] array = collection.toArray();
String[] strArray = collection.toArray(new String[0]);  // Type-safe

// Stream API (Java 8+)
Stream<E> stream = collection.stream();
Stream<E> parallelStream = collection.parallelStream();
```

### List Operations
```java
// Positional Access
element = list.get(index);
list.set(index, element);
list.add(index, element);
list.remove(index);

// Search
int index = list.indexOf(element);
int lastIndex = list.lastIndexOf(element);

// Range View
List<E> subList = list.subList(fromIndex, toIndex);

// List Iterator
ListIterator<E> iter = list.listIterator();
ListIterator<E> iter = list.listIterator(startIndex);
```

### Set Operations
```java
// Basic Set Operations
boolean added = set.add(element);  // Returns false if already present
boolean removed = set.remove(element);
boolean contains = set.contains(element);
```

### Queue/Deque Operations
```java
// Queue Operations
queue.offer(element);  // Add, returns false if full
element = queue.poll();  // Remove and return head, null if empty
element = queue.peek();  // Examine head, null if empty

// Equivalent throwing operations
queue.add(element);  // Throws if full
element = queue.remove();  // Throws if empty
element = queue.element();  // Throws if empty

// Deque Operations
deque.offerFirst(element);
deque.offerLast(element);
element = deque.pollFirst();
element = deque.pollLast();
element = deque.peekFirst();
element = deque.peekLast();

// Stack Operations with Deque
deque.push(element);  // Add to front
element = deque.pop();  // Remove from front
element = deque.peek();  // Examine front
```

### Map Operations
```java
// Basic Operations
map.put(key, value);
value = map.get(key);  // Returns null if key not present
value = map.getOrDefault(key, defaultValue);  // Java 8+
map.remove(key);
boolean contains = map.containsKey(key);
boolean contains = map.containsValue(value);
map.size();
map.isEmpty();
map.clear();

// Bulk Operations
map.putAll(otherMap);

// Collection Views
Set<K> keySet = map.keySet();
Collection<V> values = map.values();
Set<Map.Entry<K, V>> entrySet = map.entrySet();

// Java 8+ Operations
map.forEach((key, value) -> System.out.println(key + " = " + value));
value = map.computeIfAbsent(key, k -> generateValue(k));
value = map.computeIfPresent(key, (k, v) -> updateValue(k, v));
value = map.compute(key, (k, v) -> computeValue(k, v));
value = map.merge(key, value, (oldVal, newVal) -> mergeValues(oldVal, newVal));
map.replaceAll((key, value) -> transformValue(key, value));
```

## Iteration Techniques

### Traditional For Loop (for indexed collections)
```java
for (int i = 0; i < list.size(); i++) {
    String element = list.get(i);
    // Process element
}
```

### Enhanced For Loop (for-each)
```java
for (String element : collection) {
    // Process element
}
```

### Iterator
```java
Iterator<String> iterator = collection.iterator();
while (iterator.hasNext()) {
    String element = iterator.next();
    // Process element
    
    // Safe removal during iteration
    iterator.remove();  // Removes the last element returned by next()
}
```

### List Iterator
```java
ListIterator<String> listIterator = list.listIterator();
while (listIterator.hasNext()) {
    int index = listIterator.nextIndex();
    String element = listIterator.next();
    
    // Modifications
    listIterator.set("new value");  // Replace last returned element
    listIterator.add("new element");  // Add after the current position
    listIterator.remove();  // Remove last returned element
}

// Backward iteration
while (listIterator.hasPrevious()) {
    String element = listIterator.previous();
    // Process element
}
```

### Map Iteration
```java
// Iterate over keys
for (String key : map.keySet()) {
    // Process key
}

// Iterate over values
for (Integer value : map.values()) {
    // Process value
}

// Iterate over entries
for (Map.Entry<String, Integer> entry : map.entrySet()) {
    String key = entry.getKey();
    Integer value = entry.getValue();
    
    // Modify value
    entry.setValue(newValue);
}
```

### Java 8+ Stream API
```java
// Process elements
collection.stream().forEach(element -> process(element));

// Filter elements
List<String> filtered = collection.stream()
    .filter(element -> element.startsWith("A"))
    .collect(Collectors.toList());

// Transform elements
List<Integer> lengths = collection.stream()
    .map(String::length)
    .collect(Collectors.toList());

// Sorting
List<String> sorted = collection.stream()
    .sorted()  // Natural ordering
    .collect(Collectors.toList());

List<String> customSorted = collection.stream()
    .sorted(Comparator.comparing(String::length))
    .collect(Collectors.toList());
```

## Algorithms

### Sorting
```java 
// Collections.sort() - Uses merge sort (stable)
Collections.sort(list);  // Natural ordering
Collections.sort(list, comparator);  // Custom ordering

// Arrays.sort()
Arrays.sort(array);  // Natural ordering
Arrays.sort(array, comparator);  // Custom ordering
Arrays.sort(array, fromIndex, toIndex);  // Range

// Parallel sorting (Java 8+)
Arrays.parallelSort(array);
```

### Searching
```java
// Binary search (collections must be sorted)
int index = Collections.binarySearch(sortedList, key);
int index = Collections.binarySearch(sortedList, key, comparator);

// Array binary search
int index = Arrays.binarySearch(sortedArray, key);
int index = Arrays.binarySearch(sortedArray, fromIndex, toIndex, key);
```

### Shuffling
```java
Collections.shuffle(list);  // Random ordering
Collections.shuffle(list, random);  // Using specific Random instance
```

### Other Algorithms
```java
Collections.reverse(list);  // Reverse order
Collections.rotate(list, distance);  // Rotate elements
Collections.swap(list, i, j);  // Swap elements
Collections.fill(list, obj);  // Replace all elements
Collections.copy(dest, src);  // Copy elements
int frequency = Collections.frequency(collection, obj);  // Count occurrences
boolean disjoint = Collections.disjoint(c1, c2);  // Test for no common elements
```

## Concurrent Collections

### ConcurrentHashMap
```java
Map<String, Integer> map = new ConcurrentHashMap<>();
```

- **Characteristics**:
  - Thread-safe without blocking reads
  - High concurrency for reads and updates
  - No locking for retrieval operations
  - Does not allow null keys or values

### CopyOnWriteArrayList
```java
List<String> list = new CopyOnWriteArrayList<>();
```

- **Characteristics**:
  - Thread-safe variant of ArrayList
  - All mutative operations create a fresh copy
  - Ideal for read-heavy, write-rare scenarios
  - Thread-safe iterators that don't throw ConcurrentModificationException

### CopyOnWriteArraySet
```java
Set<String> set = new CopyOnWriteArraySet<>();
```

- **Characteristics**:
  - Thread-safe variant of Set
  - Uses CopyOnWriteArrayList internally
  - Ideal for read-heavy, write-rare scenarios

### ConcurrentSkipListMap/Set
```java
NavigableMap<String, Integer> map = new ConcurrentSkipListMap<>();
NavigableSet<String> set = new ConcurrentSkipListSet<>();
```

- **Characteristics**:
  - Thread-safe sorted collections
  - Based on skip lists data structure
  - Expected O(log n) operations
  - Concurrent alternatives to TreeMap/TreeSet

### BlockingQueue Implementations
```java
BlockingQueue<String> queue = new ArrayBlockingQueue<>(capacity);
BlockingQueue<String> queue = new LinkedBlockingQueue<>();
BlockingQueue<String> queue = new PriorityBlockingQueue<>();
BlockingQueue<String> queue = new DelayQueue<>();
BlockingQueue<String> queue = new SynchronousQueue<>();
BlockingQueue<String> queue = new LinkedTransferQueue<>();  // Java 7+
```

- **Key Methods**:
  - `put(element)` - Blocks if queue is full
  - `take()` - Blocks if queue is empty
  - `offer(element, timeout, unit)` - Time-bounded insertion
  - `poll(timeout, unit)` - Time-bounded retrieval

## Java 8+ Enhancements

### Stream API
```java
// Creating streams
Stream<String> stream = collection.stream();
Stream<String> parallelStream = collection.parallelStream();
Stream<String> arrayStream = Arrays.stream(array);
Stream<Integer> intStream = IntStream.range(1, 101);

// Intermediate operations
Stream<String> filtered = stream.filter(s -> s.startsWith("A"));
Stream<Integer> mapped = stream.map(String::length);
Stream<String> sorted = stream.sorted();
Stream<String> distinct = stream.distinct();
Stream<String> limited = stream.limit(10);
Stream<String> skipped = stream.skip(5);
Stream<String> peeked = stream.peek(System.out::println);

// Terminal operations
long count = stream.count();
Optional<String> min = stream.min(comparator);
Optional<String> max = stream.max(comparator);
boolean anyMatch = stream.anyMatch(predicate);
boolean allMatch = stream.allMatch(predicate);
boolean noneMatch = stream.noneMatch(predicate);
Optional<String> findFirst = stream.findFirst();
Optional<String> findAny = stream.findAny();
String[] array = stream.toArray(String[]::new);
List<String> list = stream.collect(Collectors.toList());
Set<String> set = stream.collect(Collectors.toSet());
Map<K, V> map = stream.collect(Collectors.toMap(keyMapper, valueMapper));
String joined = stream.collect(Collectors.joining(", "));
stream.forEach(System.out::println);

// Reduction
Optional<String> reduced = stream.reduce((a, b) -> a + b);
String identity = stream.reduce("", (a, b) -> a + b);

// Statistics
IntSummaryStatistics stats = stream.mapToInt(String::length).summaryStatistics();
```

### Collection Factory Methods (Java 9+)
```java
// Immutable collections
List<String> list = List.of("one", "two", "three");
Set<String> set = Set.of("one", "two", "three");
Map<String, Integer> map = Map.of("one", 1, "two", 2, "three", 3);
Map<String, Integer> mapEntries = Map.ofEntries(
    Map.entry("one", 1),
    Map.entry("two", 2),
    Map.entry("three", 3)
);
```

### Collection Default Methods (Java 8+)
```java
// Collection default methods
collection.removeIf(element -> element.isEmpty());
list.replaceAll(String::toUpperCase);
list.sort(Comparator.naturalOrder());

// Map default methods
map.forEach((key, value) -> System.out.println(key + "=" + value));
map.getOrDefault(key, defaultValue);
map.putIfAbsent(key, value);
map.computeIfAbsent(key, k -> generateValue(k));
map.computeIfPresent(key, (k, v) -> updateValue(k, v));
map.compute(key, (k, v) -> computeValue(k, v));
map.merge(key, value, (oldVal, newVal) -> mergeValues(oldVal, newVal));
map.replaceAll((key, value) -> transformValue(key, value));
```

### Optional (for collection results)
```java
Optional<String> first = collection.stream().findFirst();
if (first.isPresent()) {
    String value = first.get();
}

// Java 8 methods
first.ifPresent(value -> System.out.println(value));
String value = first.orElse("default");
String value = first.orElseGet(() -> computeDefault());
String value = first.orElseThrow(() -> new NoSuchElementException());

// Java 9+ methods
first.ifPresentOrElse(
    value -> System.out.println(value),
    () -> System.out.println("Not found")
);
Optional<String> filtered = first.filter(s -> s.length() > 3);
Optional<Integer> mapped = first.map(String::length);
Optional<Character> flatMapped = first.flatMap(s -> s.isEmpty() 
    ? Optional.empty() 
    : Optional.of(s.charAt(0)));
Stream<String> stream = first.stream();  // Empty or singleton stream
```
