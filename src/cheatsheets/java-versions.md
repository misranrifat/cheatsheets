# Java Versions Cheatsheet

## Table of Contents
- [Java 1.0 (1996)](#java-10-1996)
- [Java 1.1 (1997)](#java-11-1997)
- [Java 1.2 (1998)](#java-12-1998)
- [Java 1.3 (2000)](#java-13-2000)
- [Java 1.4 (2002)](#java-14-2002)
- [Java 5.0 (2004)](#java-50-2004)
- [Java 6 (2006)](#java-6-2006)
- [Java 7 (2011)](#java-7-2011)
- [Java 8 (2014)](#java-8-2014)
- [Java 9 (2017)](#java-9-2017)
- [Java 10 (2018)](#java-10-2018)
- [Java 11 (2018)](#java-11-2018)
- [Java 12 (2019)](#java-12-2019)
- [Java 13 (2019)](#java-13-2019)
- [Java 14 (2020)](#java-14-2020)
- [Java 15 (2020)](#java-15-2020)
- [Java 16 (2021)](#java-16-2021)
- [Java 17 (2021)](#java-17-2021)
- [Java 18 (2022)](#java-18-2022)
- [Java 19 (2022)](#java-19-2022)
- [Java 20 (2023)](#java-20-2023)
- [Java 21 (2023)](#java-21-2023)
- [Java 22 (2024)](#java-22-2024)
- [Java 23 (2024)](#java-23-2024)
- [Java 24 (2025)](#java-24-2025)
- [Java 25 (2025)](#java-25-2025)
- [Release Pattern](#release-pattern)

## Java 1.0 (1996)

Initial release of Java, codenamed Oak.

**Key Features:**
- Object-oriented programming
- Platform independence (JVM)
- Garbage collection
- Multithreading
- Core APIs (java.lang, java.io, java.util, java.awt, java.applet, java.net)
- Security model with sandboxing

## Java 1.1 (1997)

**Key Features:**
- AWT event model
- Inner classes
- JavaBeans component architecture
- JDBC for database connectivity
- RMI (Remote Method Invocation)
- JIT (Just-In-Time) compiler
- Reflection API

## Java 1.2 (1998)

**Key Features:**
- Collections framework (maps, lists, sets)
- Swing GUI components
- JIT compiler integrated into JVM
- Java IDL (Interface Definition Language) for CORBA
- Java Plugin for browsers
- Strictfp keyword
- Policy-based security model

## Java 1.3 (2000)

**Key Features:**
- Java Sound API
- JavaMail API
- JPDA (Java Platform Debugger Architecture)
- JNDI (Java Naming and Directory Interface)
- Hotspot JVM (improved performance)
- RMI over IIOP (Internet Inter-ORB Protocol)

## Java 1.4 (2002)

**Key Features:**
- Assert keyword
- Regular expressions
- Exception chaining
- Non-blocking IO (NIO)
- Logging API
- XML parsing with DOM and SAX
- JAXP (Java API for XML Processing)
- URLClassLoader improvements
- Image I/O API

## Java 5.0 (2004)

**Key Features:**
- Generics
```java
List<String> list = new ArrayList<String>();
```

- Enhanced for loop
```java
for (String item : list) {
    System.out.println(item);
}
```

- Autoboxing/unboxing
```java
Integer i = 100; // autoboxing
int j = i;       // unboxing
```

- Enumerations
```java
enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }
```

- Varargs
```java
void printAll(String... messages) {
    for (String msg : messages) {
        System.out.println(msg);
    }
}
```

- Static imports
```java
import static java.lang.Math.PI;
```

- Annotations
```java
@Override
public String toString() {
    return "Example";
}
```

- Concurrency utilities (java.util.concurrent)
- Scanner class for parsing input

## Java 6 (2006)

**Key Features:**
- JDBC 4.0
- Support for scripting languages
- Compiler API
- Pluggable annotations
- Performance improvements
- Java Compiler API
- JAXB 2.0 integration
- Web services improvements
- GUI improvements

## Java 7 (2011)

**Key Features:**
- Try-with-resources
```java
try (FileInputStream fis = new FileInputStream("file.txt")) {
    // Use the resource
}  // Resource automatically closed
```

- Diamond operator for generics
```java
List<String> list = new ArrayList<>();
```

- Multi-catch exceptions
```java
try {
    // code
} catch (IOException | SQLException e) {
    e.printStackTrace();
}
```

- String in switch
```java
switch (str) {
    case "A": 
        // code
        break;
    case "B": 
        // code
        break;
}
```

- Binary literals
```java
int binary = 0b1010;
```

- Underscores in numeric literals
```java
int million = 1_000_000;
```

- NIO.2 file API
- Fork/Join framework
- JSR 292 (invokedynamic)

## Java 8 (2014)

**Key Features:**
- Lambda expressions
```java
Collections.sort(list, (a, b) -> a.compareTo(b));
```

- Stream API
```java
list.stream()
    .filter(s -> s.startsWith("A"))
    .map(String::toUpperCase)
    .forEach(System.out::println);
```

- Method references
```java
list.forEach(System.out::println);
```

- Default methods in interfaces
```java
interface Vehicle {
    default void print() {
        System.out.println("Vehicle");
    }
}
```

- Optional class
```java
Optional<String> optional = Optional.of("value");
```

- New Date and Time API (java.time package)
```java
LocalDate today = LocalDate.now();
```

- Nashorn JavaScript engine
- Parallel array sorting
- Base64 encoding/decoding
- Repeating annotations

## Java 9 (2017)

**Key Features:**
- Java Platform Module System (Project Jigsaw)
```java
// module-info.java
module com.example.app {
    requires java.logging;
    exports com.example.api;
}
```

- JShell (REPL for Java)
- Improved Javadoc
- Collection factory methods
```java
List<String> list = List.of("A", "B", "C");
Map<String, Integer> map = Map.of("A", 1, "B", 2);
```

- Private interface methods
- Try-with-resources enhancements
- Diamond operator enhancements
- Stream API improvements
- Process API improvements
- HTTP/2 Client (incubator)
- Multi-release JAR files

## Java 10 (2018)

**Key Features:**
- Local variable type inference (var)
```java
var list = new ArrayList<String>();
var stream = list.stream();
```

- Application Class-Data Sharing
- Parallel Full GC for G1
- Garbage Collector interface
- Thread-local handshakes
- Consolidated JDK repository
- Root certificates in JDK

## Java 11 (2018)

**Key Features:**
- HTTP Client API (standardized)
```java
HttpClient client = HttpClient.newBuilder().build();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://example.com"))
    .build();
```

- String new methods
```java
String s = "   Hello   ";
String trimmed = s.strip();
boolean isEmpty = s.isBlank();
String repeated = s.repeat(3);
```

- Pattern predicate method
- Local-variable syntax for lambda parameters
```java
(var x, var y) -> x + y
```

- Epsilon: A no-op garbage collector
- Flight Recorder
- Nest-based access control
- ZGC: A scalable low-latency garbage collector (experimental)
- Dynamic class-file constants
- Launch single-file source-code programs
```bash
java HelloWorld.java
```

## Java 12 (2019)

**Key Features:**
- Switch expressions (preview)
```java
var day = switch (dayOfWeek) {
    case MONDAY, FRIDAY, SUNDAY -> "Off";
    case TUESDAY -> "Working";
    default -> "Unknown";
};
```

- Teeing collectors
```java
Stream.of(1, 2, 3, 4, 5)
    .collect(Collectors.teeing(
        Collectors.summingDouble(i -> i),
        Collectors.counting(),
        (sum, count) -> sum / count
    ));
```

- String indentation and transform methods
```java
String output = "Hello\nWorld".indent(4);
String transformed = "hello".transform(s -> s + " world");
```

- Compact number formatting
- Constants API (internal)
- JVM improvements
- Shenandoah: A Low-Pause-Time Garbage Collector (experimental)
- Microbenchmark suite

## Java 13 (2019)

**Key Features:**
- Text blocks (preview)
```java
String html = """
              <html>
                  <body>
                      <p>Hello, World</p>
                  </body>
              </html>
              """;
```

- Switch expressions (second preview)
- Socket API reimplement
- FileSystems.newFileSystem() method
- DOM and SAX factories with namespace support
- ZGC: Uncommit unused memory

## Java 14 (2020)

**Key Features:**
- Switch expressions (standard)
- Pattern matching for instanceof (preview)
```java
if (obj instanceof String s) {
    // Use 's' directly without casting
    System.out.println(s.length());
}
```

- Records (preview)
```java
record Point(int x, int y) {}
```

- Text blocks (second preview)
- Helpful NullPointerExceptions
- NUMA-aware memory allocation for G1
- JFR Event Streaming
- Non-volatile mapped byte buffers
- CDS (Class Data Sharing) archived heap objects
- Packaging tool (jpackage, incubator)

## Java 15 (2020)

**Key Features:**
- Text blocks (standard)
- Records (second preview)
- Sealed classes (preview)
```java
sealed interface Shape permits Circle, Rectangle, Square {}
```

- Pattern matching for instanceof (second preview)
- Hidden classes
- Deprecated biased locking
- ZGC: Production ready
- Shenandoah GC: Production ready
- Removed Nashorn JavaScript engine
- DatagramSocket API reimplementation
- Foreign-Memory Access API (incubator)
- Edwards-Curve cryptographic signatures

## Java 16 (2021)

**Key Features:**
- Records (standard)
- Pattern matching for instanceof (standard)
- Unix-domain socket channels
- Warnings for value-based classes
- Vector API (incubator)
```java
var x = FloatVector.fromArray(SPECIES, xArr, 0);
var y = FloatVector.fromArray(SPECIES, yArr, 0);
var z = x.mul(y).add(z);
```

- Foreign linker API (incubator)
- Foreign-memory access API (second incubator)
- Elastic metaspace
- Strongly encapsulate JDK internals
- ZGC: Concurrent thread-stack processing
- Enable C++14 language features
- Alpine Linux port
- Migrate from Mercurial to Git
- Sealed classes (second preview)

## Java 17 (2021)

**Key Features:**
- Sealed classes (standard)
```java
public sealed class Shape
    permits Circle, Rectangle, Square {
    // ...
}
```

- Pattern matching for switch (preview)
```java
String formatted = switch (obj) {
    case Integer i -> String.format("int %d", i);
    case Long l -> String.format("long %d", l);
    case Double d -> String.format("double %f", d);
    case String s -> String.format("String %s", s);
    default -> obj.toString();
};
```

- Foreign Function & Memory API (incubator)
- Vector API (second incubator)
- Enhanced pseudo-random number generators
- Context-specific deserialization filters
- Deprecate the Applet API for removal
- Strongly encapsulate JDK internals
- Restore always-strict floating-point semantics
- Deprecate the Security Manager for removal

## Java 18 (2022)

**Key Features:**
- UTF-8 by default
- Simple web server
```bash
jwebserver -p 8000
```

- Code snippets in Java API documentation
- Pattern matching for switch (second preview)
- Deprecate finalization for removal
- Internet-Address Resolution SPI
- Foreign Function & Memory API (second incubator)
- Vector API (third incubator)
- Charset implementation improvements
- Reimplement Core Reflection with Method Handles

## Java 19 (2022)

**Key Features:**
- Virtual threads (preview)
```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    IntStream.range(0, 10_000).forEach(i -> {
        executor.submit(() -> {
            Thread.sleep(Duration.ofSeconds(1));
            return i;
        });
    });
}  // All 10,000 tasks complete in about 1 second
```

- Pattern matching for switch (third preview)
- Record patterns (preview)
```java
if (obj instanceof Point(int x, int y)) {
    System.out.println(x + y);
}
```

- Foreign Function & Memory API (preview)
```java
// C function: void hello(char* name);
var symbols = Linker.nativeLinker().defaultLookup();
var hello = symbols.lookup("hello").get();
var funcDesc = FunctionDescriptor.ofVoid(ValueLayout.ADDRESS);
var helloFunc = Linker.nativeLinker().downcallHandle(hello, funcDesc);
```

- Structured concurrency (incubator)
```java
try (var scope = new StructuredTaskScope.ShutdownOnFailure()) {
    Future<String> user = scope.fork(() -> findUser());
    Future<Integer> order = scope.fork(() -> fetchOrder());
    
    scope.join();           // Wait for both forks
    scope.throwIfFailed();  // If both succeeded, continue
    
    return new Result(user.resultNow(), order.resultNow());
}
```

- Vector API (fourth incubator)
- Linux/RISC-V port
- JDK 19 security enhancements

## Java 20 (2023)

**Key Features:**
- Record patterns (second preview)
- Pattern matching for switch (fourth preview)
- Scoped values (incubator)
```java
final static ScopedValue<User> LOGGED_USER = new ScopedValue<>();

void process() {
    ScopedValue.where(LOGGED_USER, user)
        .run(() -> doWork());
}

void doWork() {
    // Access the user from any method in the call stack
    User user = LOGGED_USER.get();
}
```

- Virtual threads (second preview)
- Structured concurrency (second incubator)
- Foreign Function & Memory API (second preview)
- Vector API (fifth incubator)

## Java 21 (2023)

**Key Features:**
- Virtual threads (standard)
- Record patterns (standard)
- Pattern matching for switch (standard)
- Sequenced collections
```java
List<String> list = List.of("a", "b", "c");
String first = list.getFirst();  // "a"
String last = list.getLast();    // "c"
List<String> reversed = list.reversed();  // ["c", "b", "a"]
```

- String templates (preview)
```java
String name = "world";
String message = STR."Hello \{name}!";  // "Hello world!"
```

- Unnamed patterns and variables (preview)
```java
// Unnamed patterns
if (obj instanceof Point(int x, int _)) {
    // Only use x coordinate
}

// Unnamed variables
var _ = someMethodCall();  // Explicitly ignoring the result
```

- Unnamed classes and instance main methods (preview)
```java
// Unnamed class
void main() {
    System.out.println("Hello, World!");
}
```

- Foreign Function & Memory API (standard)
- Structured concurrency (preview)
- Key encapsulation mechanism API
- Scoped values (preview)
- Vector API (sixth incubator)
- Generational ZGC
- Deprecate the Windows 32-bit x86 port for removal

## Java 22 (2024)

**Key Features:**
- Unnamed classes and instance main methods (standard)
```java
void main() {
    System.out.println("Hello world!");
}
```

- String templates (second preview)
- Structured concurrency (standard)
```java
try (var scope = new StructuredTaskScope<>()) {
    Future<String> user = scope.fork(() -> findUser());
    Future<Integer> order = scope.fork(() -> fetchOrder());
    
    scope.join();
    
    processUserAndOrder(user.resultNow(), order.resultNow());
}
```

- Region Pinning for G1
- Stream gatherers (preview)
```java
List<Integer> list = Stream.of(1, 2, 3, 4, 5, 6)
    .gather(Stream.gatherer()
        .filter(n -> n % 2 == 0)
        .map(n -> n * 2)
        .flatMap(n -> List.of(n, n+1)))
    .toList();  // [4, 5, 8, 9, 12, 13]
```

- Scoped values (standard)
- Launch multi-file source-code programs
- Stream.takeWhile method with inclusive parameter
- Locale API enhancements
- Java Vector API improvements
- HTTP/2 server push enhancements
- Socket API improvements
- Foreign Function & Memory API improvements

## Java 23 (2024)

Released on September 17, 2024 (non-LTS release).

**Key Features:**

- Markdown documentation comments (standard)
```java
/**
# API Documentation

This is **bold** and this is *italic*.

## Parameters
- `name` - The user's name
- `age` - The user's age

## Returns
A `User` object with the provided details
*/
public User createUser(String name, int age) {
    return new User(name, age);
}
```

- Primitive types in patterns (preview)
```java
// Pattern matching with primitives
int value = 42;
String result = switch (value) {
    case int i when i > 0 -> "Positive";
    case int i when i < 0 -> "Negative";
    case int i -> "Zero";
};
```

- Class-File API (preview)
```java
// Standard API for parsing, generating, and transforming class files
ClassModel cm = ClassFile.of().parse(bytes);
byte[] newBytes = ClassFile.of().build(
    cm.thisClass().asSymbol(),
    clb -> {
        for (ClassElement ce : cm) {
            if (ce instanceof MethodModel mm) {
                clb.withMethod(mm.methodName(), mm.methodType(),
                    ClassFile.ACC_PUBLIC, mb -> {
                        // Transform method
                    });
            } else {
                clb.with(ce);
            }
        }
    });
```

- Stream gatherers (preview)
```java
// Custom stream transformations beyond built-in operations
List<String> result = Stream.of("a", "b", "c", "d")
    .gather(Gatherers.windowFixed(2))
    .map(window -> String.join("-", window))
    .toList();  // ["a-b", "c-d"]
```

- Module import declarations (preview)
```java
// Import all exported packages from a module
import module java.sql;

// Instead of:
// import java.sql.*;
// import javax.sql.*;
// import java.sql.rowset.*;
```

- Implicitly declared classes (preview)
```java
// Simplified main methods for beginners
void main() {
    println("Hello, World!");
}
```

- Structured concurrency (third preview)
- Scoped values (preview)
```java
final static ScopedValue<User> CURRENT_USER = ScopedValue.newInstance();

void serve(Request request, User user) {
    ScopedValue.where(CURRENT_USER, user)
        .run(() -> process(request));
}

void process(Request request) {
    User user = CURRENT_USER.get();  // Access from any method in call stack
    // Process request with user context
}
```

- Flexible constructor bodies (preview)
```java
class PositiveBigInteger extends BigInteger {
    PositiveBigInteger(long value) {
        // Can now have statements before super()
        if (value <= 0)
            throw new IllegalArgumentException("non-positive value");
        super(String.valueOf(value));
    }
}
```

- ZGC: Generational mode by default
- Deprecate memory-access methods in sun.misc.Unsafe for removal

**Notable Removal:**
- String templates feature was removed due to design issues

## Java 24 (2025)

Released on March 18, 2025 (non-LTS release).

**Key Features:**

- Quantum-resistant cryptography (standard)
```java
// ML-DSA (Module-Lattice-Based Digital Signature Algorithm)
KeyPairGenerator kpg = KeyPairGenerator.getInstance("ML-DSA");
KeyPair keyPair = kpg.generateKeyPair();
Signature sig = Signature.getInstance("ML-DSA");
sig.initSign(keyPair.getPrivate());
sig.update(data);
byte[] signature = sig.sign();

// ML-KEM (Module-Lattice-Based Key Encapsulation Mechanism)
KeyPairGenerator kemKpg = KeyPairGenerator.getInstance("ML-KEM");
KeyPair kemKeyPair = kemKpg.generateKeyPair();
```

- Synchronizing virtual threads without pinning
```java
// Virtual threads now release platform threads when blocked
// No more pinning in synchronized blocks
synchronized (lock) {
    // Virtual thread yields platform thread while waiting
    lock.wait();
}
```

- Compact object headers (experimental)
```java
// Reduces object header size from 96-128 bits to 64 bits
// ~25% heap size reduction on 64-bit architectures
// Enable with: -XX:+UseCompactObjectHeaders
```

- Primitive types in patterns (second preview)
```java
// Enhanced pattern matching for all primitive types
Object obj = 42;
switch (obj) {
    case int i when i > 0 -> System.out.println("Positive int");
    case long l -> System.out.println("Long: " + l);
    case double d -> System.out.println("Double: " + d);
    default -> System.out.println("Other");
}
```

- Stable values (preview)
```java
// Computed constants initialized at most once
class Configuration {
    private static final StableValue<Properties> CONFIG =
        StableValue.of(() -> loadConfig());

    static Properties getConfig() {
        return CONFIG.get();
    }
}
```

- Simple source files and instance main methods (fourth preview)
- Flexible constructor bodies (third preview)
- Module import declarations (second preview)
- Structured concurrency (fourth preview)
- Scoped values (second preview)

- Stream gatherers (standard)
```java
// Custom intermediate stream operations
Stream.of(1, 2, 3, 4, 5)
    .gather(Gatherers.fold(() -> 0, (a, b) -> a + b))
    .forEach(System.out::println);
```

- Class-File API (standard)
- Key Derivation Function API
```java
// Derive keys from secrets using HKDF, Argon2, etc.
KDF kdf = KDF.getInstance("HKDF-SHA256");
SecretKey derivedKey = kdf.deriveKey(inputKey, info, algorithm, keySize);
```

- Vector API (ninth incubator)
- Generational Shenandoah GC (experimental)
- Ahead-of-Time class loading
- Unsafe memory access warnings

**Deprecations and Removals:**
- Security Manager permanently disabled
- 32-bit x86 port deprecated for removal (Linux)
- 32-bit x86 port removed (Windows)
- ZGC non-generational mode removed

## Java 25 (2025)

Long-Term Support (LTS) release scheduled for September 16, 2025.

**Key Features:**

- Compact object headers (standard)
```java
// Object headers reduced to 64 bits (production-ready)
// Improves heap size and data locality
// No flag needed - enabled by default
```

- Flexible constructor bodies (standard)
```java
// Finalized feature allowing statements before super()/this()
class ValidationClass extends BaseClass {
    ValidationClass(String value) {
        if (value == null || value.isEmpty()) {
            throw new IllegalArgumentException("Invalid value");
        }
        super(value.trim().toLowerCase());
    }
}
```

- Compact source files and instance main methods (standard)
```java
// Beginners can write streamlined programs
void main() {
    var names = List.of("Alice", "Bob", "Charlie");
    names.forEach(name -> println("Hello, " + name));
}
```

- Structured concurrency (fifth preview)
```java
// Treat related concurrent tasks as single units
try (var scope = StructuredTaskScope.open()) {
    Future<String> user = scope.fork(() -> fetchUser());
    Future<Order> order = scope.fork(() -> fetchOrder());

    scope.join();
    return processUserOrder(user.resultNow(), order.resultNow());
}
```

- Primitive types in patterns (third preview)
- Scoped values (fifth preview)
- Module import declarations (third preview)

- Stable values (preview)
```java
// Immutable data objects treated as constants by JVM
class CacheManager {
    private final StableValue<DataCache> cache =
        StableValue.of(() -> initializeCache());

    public DataCache getCache() {
        return cache.get();  // Constant-folding optimization
    }
}
```

- Key Derivation Function API (standard)
```java
// Support for Argon2, HKDF, ML-KEM, TLS 1.3 Hybrid Key Exchange
KDF argon2 = KDF.getInstance("Argon2id");
SecretKey key = argon2.deriveKey(password, salt, params);
```

- Vector API (tenth incubator)
```java
// Enhanced with Float16 auto-vectorization on x64
// Links to native mathematical libraries via FFM API
var species = FloatVector.SPECIES_256;
var a = FloatVector.fromArray(species, arrayA, 0);
var b = FloatVector.fromArray(species, arrayB, 0);
var c = a.mul(b).add(vectorC);
c.intoArray(result, 0);
```

- PEM encodings (preview)
```java
// Concise API for encoding/decoding cryptographic objects
PemDecoder decoder = PemDecoder.create();
PrivateKey key = decoder.decodePrivateKey(pemString);

PemEncoder encoder = PemEncoder.create();
String pemOutput = encoder.encode(certificate);
```

- Generational Shenandoah GC (standard)
```java
// Promoted from experimental to production
// Enable with: -XX:+UseShenandoahGC
// Generational mode is default
```

- JDK Flight Recorder enhancements
  - CPU-time profiling with accurate metrics on Linux
  - Cooperative sampling for stable async stack sampling
  - Method timing and tracing without bytecode instrumentation

- Ahead-of-Time improvements
  - Simplified AOT cache creation
  - Method profiling for faster startup

**AI Development Support:**
Five features target AI development: primitive types in patterns, module import declarations, Vector API, structured concurrency, and scoped values.

**Removals:**
- 32-bit x86 port source code and build support removed

**Support:**
As an LTS release, Java 25 receives at least 8 years of Premier commercial support from Oracle.

## Release Pattern

Since Java 10, Oracle has shifted to a time-based release model:
- **Feature releases**: Every six months (March and September)
- **Long-term support (LTS) releases**: Every two years (Java 11, 17, 21, 25, etc.)

**Release Features Lifecycle:**
1. **Incubator** - Early-stage feature development where APIs may change
2. **Preview** - Feature is complete but may still evolve based on feedback
3. **Standard** - Feature is stable and permanent part of Java platform

**Support Terminology:**
- **Premier Support**: Bug fixes, security alerts and patches
- **Extended Support**: Security updates and select bug fixes
- **Sustaining Support**: Limited support, typically no security updates
