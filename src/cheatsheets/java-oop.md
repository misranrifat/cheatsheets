# Java OOP Concepts Cheatsheet

## Table of Contents
- [Classes and Objects](#classes-and-objects)
- [Four Pillars of OOP](#four-pillars-of-oop)
  - [Encapsulation](#encapsulation)
  - [Inheritance](#inheritance)
  - [Polymorphism](#polymorphism)
  - [Abstraction](#abstraction)
- [Class Components](#class-components)
  - [Constructors](#constructors)
  - [Methods](#methods)
  - [Variables/Fields](#variablesfields)
  - [Access Modifiers](#access-modifiers)
- [Special Classes](#special-classes)
  - [Abstract Classes](#abstract-classes)
  - [Interfaces](#interfaces)
  - [Enums](#enums)
  - [Nested Classes](#nested-classes)
- [Advanced Concepts](#advanced-concepts)
  - [Object Lifecycle](#object-lifecycle)
  - [Generics](#generics)
  - [Lambda Expressions](#lambda-expressions)
  - [Functional Interfaces](#functional-interfaces)
  - [Stream API](#stream-api)
  - [Exception Handling](#exception-handling)
  - [Annotations](#annotations)
- [Design Patterns](#design-patterns)
- [Best Practices](#best-practices)

## Classes and Objects

### Class Definition
```java
public class MyClass {
    // Fields, constructors, methods
}
```

### Object Creation
```java
MyClass myObject = new MyClass();
```

### Object References
```java
MyClass obj1 = new MyClass();
MyClass obj2 = obj1; // obj2 references the same object as obj1
```

## Four Pillars of OOP

### Encapsulation
Bundling data and methods that operate on that data within a single unit (class), and restricting access to internal state.

```java
public class BankAccount {
    private double balance; // private field
    
    // Public getter
    public double getBalance() {
        return balance;
    }
    
    // Public setter with validation
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }
}
```

### Inheritance
Mechanism where a new class inherits properties and behaviors from an existing class.

```java
// Parent/Base/Super class
public class Animal {
    protected String name;
    
    public void eat() {
        System.out.println("Animal is eating");
    }
}

// Child/Derived/Sub class
public class Dog extends Animal {
    public Dog(String name) {
        this.name = name;
    }
    
    public void bark() {
        System.out.println("Woof!");
    }
    
    @Override
    public void eat() {
        System.out.println("Dog is eating");
    }
}
```

#### Inheritance Types
- **Single**: A class inherits from one superclass
- **Multilevel**: A class inherits from a class, which inherits from another class
- **Hierarchical**: Multiple classes inherit from one superclass
- **Multiple**: A class inherits from multiple superclasses (Java doesn't support this directly, but can achieve through interfaces)

### Polymorphism
Ability of an object to take many forms.

#### Method Overriding
```java
class Animal {
    public void makeSound() {
        System.out.println("Animal makes a sound");
    }
}

class Cat extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Meow");
    }
}

// Usage
Animal myAnimal = new Cat(); // Animal reference, Cat object
myAnimal.makeSound(); // Outputs: "Meow"
```

#### Method Overloading
```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
    
    public double add(double a, double b) {
        return a + b;
    }
    
    public int add(int a, int b, int c) {
        return a + b + c;
    }
}
```

### Abstraction
Hiding complex implementation details and showing only necessary features.

```java
// Using abstract class
abstract class Vehicle {
    abstract void start();
    
    public void stop() {
        System.out.println("Vehicle stopped");
    }
}

class Car extends Vehicle {
    @Override
    void start() {
        System.out.println("Car started");
    }
}

// Using interface
interface Drawable {
    void draw();
}

class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing a circle");
    }
}
```

## Class Components

### Constructors
Special methods used to initialize objects.

```java
public class Person {
    private String name;
    private int age;
    
    // Default constructor
    public Person() {
        name = "Unknown";
        age = 0;
    }
    
    // Parameterized constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Copy constructor
    public Person(Person other) {
        this.name = other.name;
        this.age = other.age;
    }
}
```

#### Constructor Chaining
```java
public class Student {
    private String name;
    private int age;
    private String studentId;
    
    public Student() {
        this("Unknown", 0);
    }
    
    public Student(String name, int age) {
        this(name, age, "N/A");
    }
    
    public Student(String name, int age, String studentId) {
        this.name = name;
        this.age = age;
        this.studentId = studentId;
    }
}
```

### Methods
Functions that define the behavior of a class.

```java
public class Calculator {
    // Instance method
    public int add(int a, int b) {
        return a + b;
    }
    
    // Static method
    public static int multiply(int a, int b) {
        return a * b;
    }
    
    // Final method (can't be overridden)
    public final double divide(double a, double b) {
        if (b == 0) throw new ArithmeticException("Division by zero");
        return a / b;
    }
    
    // Method overloading
    public double add(double a, double b) {
        return a + b;
    }
    
    // Varargs method
    public int sum(int... numbers) {
        int total = 0;
        for (int num : numbers) {
            total += num;
        }
        return total;
    }
}
```

### Variables/Fields
Data members of a class.

```java
public class Employee {
    // Instance variables
    private String name;
    private double salary;
    
    // Static variable (class variable)
    public static String company = "TechCorp";
    
    // Final variable (constant)
    public final int EMPLOYEE_ID;
    
    // Static final constant
    public static final double MIN_WAGE = 15.0;
    
    // Transient variable (not serialized)
    private transient String password;
    
    // Volatile variable (thread safety)
    private volatile boolean isActive;
    
    public Employee(String name, double salary, int id) {
        this.name = name;
        this.salary = salary;
        this.EMPLOYEE_ID = id;
    }
}
```

### Access Modifiers

| Modifier | Class | Package | Subclass | World |
|----------|-------|---------|----------|-------|
| public | Yes | Yes | Yes | Yes |
| protected | Yes | Yes | Yes | No |
| default (no modifier) | Yes | Yes | No | No |
| private | Yes | No | No | No |

```java
public class AccessExample {
    public String publicVar;      // Accessible from anywhere
    protected String protectedVar; // Accessible in same package and subclasses
    String defaultVar;            // Accessible only in same package
    private String privateVar;    // Accessible only in this class
}
```

## Special Classes

### Abstract Classes
Classes that cannot be instantiated and may contain abstract methods.

```java
abstract class Shape {
    protected String color;
    
    // Constructor
    public Shape(String color) {
        this.color = color;
    }
    
    // Concrete method
    public String getColor() {
        return color;
    }
    
    // Abstract method (no implementation)
    abstract public double calculateArea();
}

class Circle extends Shape {
    private double radius;
    
    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    
    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
}
```

### Interfaces
Contract specifying methods that implementing classes must provide.

```java
interface Payable {
    double calculatePayment(); // implicitly public abstract
    
    // Default method (Java 8+)
    default void printDetails() {
        System.out.println("Payment details");
    }
    
    // Static method (Java 8+)
    static boolean validatePayment(double amount) {
        return amount > 0;
    }
    
    // Private method (Java 9+)
    private void helperMethod() {
        System.out.println("Helper method");
    }
    
    // Constant
    double TAX_RATE = 0.15; // implicitly public static final
}

interface Taxable {
    double calculateTax();
}

// Multiple interface implementation
class Invoice implements Payable, Taxable {
    private double amount;
    
    public Invoice(double amount) {
        this.amount = amount;
    }
    
    @Override
    public double calculatePayment() {
        return amount;
    }
    
    @Override
    public double calculateTax() {
        return amount * Payable.TAX_RATE;
    }
}
```

### Enums
Special class type for representing a group of constants.

```java
public enum DayOfWeek {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

// Enum with properties and methods
public enum Planet {
    MERCURY(3.303e+23, 2.4397e6),
    VENUS(4.869e+24, 6.0518e6),
    EARTH(5.976e+24, 6.37814e6),
    MARS(6.421e+23, 3.3972e6),
    JUPITER(1.9e+27, 7.1492e7),
    SATURN(5.688e+26, 6.0268e7),
    URANUS(8.686e+25, 2.5559e7),
    NEPTUNE(1.024e+26, 2.4746e7);

    private final double mass;   // in kilograms
    private final double radius; // in meters
    
    Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }
    
    public double getMass() {
        return mass;
    }
    
    public double getRadius() {
        return radius;
    }
    
    // Calculate surface gravity
    public double surfaceGravity() {
        double G = 6.67300E-11; // gravitational constant
        return G * mass / (radius * radius);
    }
}
```

### Nested Classes
Classes defined within another class.

```java
public class OuterClass {
    private int outerVariable = 10;
    
    // Inner class (non-static nested class)
    public class InnerClass {
        public void displayOuter() {
            System.out.println("Outer variable: " + outerVariable);
        }
    }
    
    // Static nested class
    public static class StaticNestedClass {
        public void display() {
            // Can't access outerVariable directly
            System.out.println("Inside static nested class");
        }
    }
    
    // Method local inner class
    public void method() {
        final int localVariable = 20;
        
        class LocalInnerClass {
            public void display() {
                System.out.println("Local variable: " + localVariable);
            }
        }
        
        LocalInnerClass local = new LocalInnerClass();
        local.display();
    }
    
    // Anonymous inner class
    public Runnable getRunnable() {
        return new Runnable() {
            @Override
            public void run() {
                System.out.println("Anonymous class running");
            }
        };
    }
}

// Usage
OuterClass outer = new OuterClass();
OuterClass.InnerClass inner = outer.new InnerClass();
OuterClass.StaticNestedClass staticNested = new OuterClass.StaticNestedClass();
```

## Advanced Concepts

### Object Lifecycle
1. Creation (using `new` keyword, calling constructor)
2. Use (invoking methods, accessing fields)
3. Unreachable (when no references point to the object)
4. Garbage Collection

```java
public class Person {
    private String name;
    
    public Person(String name) {
        this.name = name;
        System.out.println("Constructor: Person created - " + name);
    }
    
    // Finalize method is deprecated but still part of object lifecycle
    // Don't rely on this in modern Java
    @Override
    protected void finalize() throws Throwable {
        try {
            System.out.println("Finalize: Person destroyed - " + name);
        } finally {
            super.finalize();
        }
    }
}
```

### Generics
Enable types to be parameters when defining classes, interfaces, and methods.

```java
// Generic class
public class Box<T> {
    private T content;
    
    public void put(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

// Generic method
public class Util {
    public static <T> T getMiddle(T... elements) {
        return elements[elements.length / 2];
    }
    
    // Bounded type parameter
    public static <T extends Comparable<T>> T getMax(T a, T b) {
        return a.compareTo(b) > 0 ? a : b;
    }
}

// Multiple type parameters
public class Pair<K, V> {
    private K key;
    private V value;
    
    public Pair(K key, V value) {
        this.key = key;
        this.value = value;
    }
    
    public K getKey() { return key; }
    public V getValue() { return value; }
}

// Wildcards
public void processElements(List<? extends Number> numbers) {
    // Can read Numbers from the list
}

public void addIntegers(List<? super Integer> list) {
    // Can add Integers to the list
}
```

### Lambda Expressions
Anonymous functions that can be passed as arguments.

```java
// Basic lambda
Runnable run = () -> System.out.println("Running");

// Lambda with parameters
Comparator<String> comparator = (s1, s2) -> s1.compareTo(s2);

// Lambda with block
Consumer<String> printer = s -> {
    String formatted = s.toUpperCase();
    System.out.println(formatted);
};

// Method reference
List<String> names = Arrays.asList("John", "Mary", "Bob");
names.forEach(System.out::println);
```

### Functional Interfaces
Interfaces with a single abstract method, can be implemented using lambda expressions.

```java
// Built-in functional interfaces
Function<String, Integer> length = s -> s.length();
Predicate<Integer> isEven = n -> n % 2 == 0;
Consumer<String> print = s -> System.out.println(s);
Supplier<Double> random = () -> Math.random();
BiFunction<Integer, Integer, Integer> add = (a, b) -> a + b;

// Custom functional interface
@FunctionalInterface
interface Transformer<T, R> {
    R transform(T input);
    
    // Can have default and static methods
    default void printInfo() {
        System.out.println("Transformer interface");
    }
}
```

### Stream API
Provides a way to process collections of objects in a functional style.

```java
List<String> names = Arrays.asList("John", "Mary", "Bob", "Alice");

// Basic stream operations
List<String> filteredNames = names.stream()
    .filter(name -> name.length() > 3)
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.toList());

// Stream creation
Stream<Integer> streamFromValues = Stream.of(1, 2, 3, 4, 5);
Stream<String> streamFromArray = Arrays.stream(new String[] {"a", "b", "c"});
Stream<Integer> infiniteStream = Stream.iterate(0, n -> n + 2);

// Common operations
int sum = Stream.of(1, 2, 3, 4, 5).reduce(0, Integer::sum);
boolean allMatch = Stream.of(2, 4, 6).allMatch(n -> n % 2 == 0);
String joined = Stream.of("a", "b", "c").collect(Collectors.joining(", "));

// Parallel streams
long count = names.parallelStream()
    .filter(name -> name.length() > 3)
    .count();
```

### Exception Handling
Mechanism to handle runtime errors.

```java
// Try-catch-finally
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Division by zero: " + e.getMessage());
} finally {
    System.out.println("This always executes");
}

// Multiple catch blocks
try {
    String s = null;
    s.length();
} catch (NullPointerException e) {
    System.out.println("Null reference: " + e.getMessage());
} catch (Exception e) {
    System.out.println("Other exception: " + e.getMessage());
}

// Try-with-resources
try (FileReader reader = new FileReader("file.txt");
     BufferedReader br = new BufferedReader(reader)) {
    String line = br.readLine();
    System.out.println(line);
} catch (IOException e) {
    System.out.println("I/O Error: " + e.getMessage());
}

// Throwing exceptions
public void deposit(double amount) throws IllegalArgumentException {
    if (amount <= 0) {
        throw new IllegalArgumentException("Amount must be positive");
    }
    balance += amount;
}

// Custom exceptions
class InsufficientFundsException extends Exception {
    private double amount;
    
    public InsufficientFundsException(double amount) {
        super("Insufficient funds: shortfall of $" + amount);
        this.amount = amount;
    }
    
    public double getAmount() {
        return amount;
    }
}
```

### Annotations
Metadata added to Java source code.

```java
// Built-in annotations
@Override
public String toString() {
    return "Custom toString implementation";
}

@Deprecated
public void oldMethod() {
    // Deprecated method
}

@SuppressWarnings("unchecked")
public void suppressedMethod() {
    // Warning suppressed
}

@FunctionalInterface
interface Processor {
    void process();
}

// Custom annotation
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Test {
    boolean enabled() default true;
    String[] tags() default {};
}

// Using custom annotation
public class MyTests {
    @Test(enabled = true, tags = {"unit", "fast"})
    public void testMethod() {
        // Test method
    }
}
```

## Design Patterns

### Creational Patterns
- **Singleton**: Ensures a class has only one instance
```java
public class Singleton {
    private static volatile Singleton instance;
    
    private Singleton() {}
    
    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

- **Factory Method**: Creates objects without specifying the exact class
```java
interface Product {
    void operation();
}

class ConcreteProductA implements Product {
    @Override
    public void operation() {
        System.out.println("Product A operation");
    }
}

class ConcreteProductB implements Product {
    @Override
    public void operation() {
        System.out.println("Product B operation");
    }
}

abstract class Creator {
    public abstract Product createProduct();
}

class ConcreteCreatorA extends Creator {
    @Override
    public Product createProduct() {
        return new ConcreteProductA();
    }
}
```

- **Builder**: Separates object construction from its representation
```java
public class Person {
    private final String name;
    private final int age;
    private final String address;
    
    private Person(Builder builder) {
        this.name = builder.name;
        this.age = builder.age;
        this.address = builder.address;
    }
    
    public static class Builder {
        private String name;
        private int age;
        private String address;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder age(int age) {
            this.age = age;
            return this;
        }
        
        public Builder address(String address) {
            this.address = address;
            return this;
        }
        
        public Person build() {
            return new Person(this);
        }
    }
}

// Usage
Person person = new Person.Builder()
    .name("John")
    .age(30)
    .address("123 Main St")
    .build();
```

### Structural Patterns
- **Adapter**: Allows incompatible interfaces to work together
- **Decorator**: Adds responsibilities to objects dynamically
- **Proxy**: Provides a surrogate for another object

### Behavioral Patterns
- **Observer**: Defines a one-to-many dependency between objects
- **Strategy**: Defines a family of algorithms, encapsulates them, and makes them interchangeable
- **Command**: Encapsulates a request as an object

## Best Practices

### Naming Conventions
- **Classes**: `PascalCase` (e.g., `BankAccount`)
- **Methods/Variables**: `camelCase` (e.g., `calculateInterest`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `MAX_BALANCE`)
- **Packages**: lowercase, reverse domain name (e.g., `com.company.project`)

### SOLID Principles
- **Single Responsibility Principle**: A class should have only one reason to change
- **Open/Closed Principle**: Classes should be open for extension but closed for modification
- **Liskov Substitution Principle**: Subtypes must be substitutable for their base types
- **Interface Segregation Principle**: Clients should not be forced to depend on interfaces they don't use
- **Dependency Inversion Principle**: Depend on abstractions, not concretions

### Code Quality
- Write clear, self-documenting code
- Keep methods short and focused
- Use meaningful variable and method names
- Follow the DRY principle (Don't Repeat Yourself)
- Write unit tests for your code
- Use proper indentation and formatting
- Add JavaDoc comments for public APIs

```java
/**
 * Calculates the monthly payment for a loan.
 *
 * @param principal The loan amount
 * @param rate Annual interest rate (as a decimal)
 * @param years Loan term in years
 * @return The monthly payment amount
 * @throws IllegalArgumentException if inputs are negative
 */
public double calculateMonthlyPayment(double principal, double rate, int years) {
    if (principal < 0 || rate < 0 || years < 0) {
        throw new IllegalArgumentException("All parameters must be positive");
    }
    
    double monthlyRate = rate / 12;
    int months = years * 12;
    
    return principal * monthlyRate * Math.pow(1 + monthlyRate, months) / 
           (Math.pow(1 + monthlyRate, months) - 1);
}
```
