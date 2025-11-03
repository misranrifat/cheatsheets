# Hamcrest Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Concepts](#basic-concepts)
- [Core Matchers](#core-matchers)
- [Logical Matchers](#logical-matchers)
- [Object Matchers](#object-matchers)
- [Number Matchers](#number-matchers)
- [Text Matchers](#text-matchers)
- [Collection Matchers](#collection-matchers)
- [Array Matchers](#array-matchers)
- [Map Matchers](#map-matchers)
- [Bean Matchers](#bean-matchers)
- [Custom Matchers](#custom-matchers)
- [Type Safety](#type-safety)
- [Common Patterns](#common-patterns)
- [Integration with JUnit](#integration-with-junit)
- [Integration with TestNG](#integration-with-testng)
- [Integration with Mockito](#integration-with-mockito)
- [Best Practices](#best-practices)
- [References](#references)

## Introduction

Hamcrest is a framework for writing matcher objects allowing 'match' rules to be defined declaratively. It's commonly used with testing frameworks to make assertions more readable and expressive.

**Key Features:**
- Readable and expressive assertions
- Descriptive failure messages
- Reusable matchers
- Type-safe matching
- Composable matchers
- Works with JUnit, TestNG, and other frameworks

## Installation

### Maven
```xml
<!-- pom.xml -->
<dependencies>
    <!-- Hamcrest -->
    <dependency>
        <groupId>org.hamcrest</groupId>
        <artifactId>hamcrest</artifactId>
        <version>2.2</version>
        <scope>test</scope>
    </dependency>

    <!-- JUnit 5 (optional) -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.0</version>
        <scope>test</scope>
    </dependency>

    <!-- JUnit 4 (legacy) -->
    <!-- Note: JUnit 4 includes Hamcrest 1.3 -->
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### Gradle
```groovy
// build.gradle
dependencies {
    testImplementation 'org.hamcrest:hamcrest:2.2'
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.0'
}
```

### Gradle Kotlin DSL
```kotlin
// build.gradle.kts
dependencies {
    testImplementation("org.hamcrest:hamcrest:2.2")
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.0")
}
```

## Basic Concepts

### Using assertThat
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class BasicHamcrestTest {

    @Test
    public void basicAssertion() {
        String actual = "Hello World";

        // Basic assertion
        assertThat(actual, is("Hello World"));

        // With description
        assertThat("String should equal 'Hello World'", actual, is("Hello World"));
    }

    @Test
    public void multipleAssertions() {
        int value = 10;

        assertThat(value, is(10));
        assertThat(value, equalTo(10));
        assertThat(value, greaterThan(5));
        assertThat(value, lessThan(20));
    }
}
```

### Matcher Anatomy
```java
// Structure: assertThat(actual, matcher)
assertThat(actualValue, is(expectedValue));

// With description
assertThat("Description of what is being tested", actualValue, matcher);

// Matchers can be composed
assertThat(value, is(not(equalTo(5))));
```

## Core Matchers

### Equality Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class EqualityMatchersTest {

    @Test
    public void testEquality() {
        String actual = "test";

        // Equal to
        assertThat(actual, is(equalTo("test")));
        assertThat(actual, equalTo("test"));
        assertThat(actual, is("test")); // Shorthand

        // Not equal to
        assertThat(actual, not(equalTo("other")));
        assertThat(actual, is(not("other")));
    }

    @Test
    public void testSameInstance() {
        String str1 = new String("test");
        String str2 = str1;
        String str3 = new String("test");

        // Same instance (reference equality)
        assertThat(str2, sameInstance(str1));
        assertThat(str2, theInstance(str1));

        // Not same instance
        assertThat(str3, not(sameInstance(str1)));
    }
}
```

### Null Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class NullMatchersTest {

    @Test
    public void testNull() {
        String nullValue = null;
        String nonNullValue = "test";

        // Null matchers
        assertThat(nullValue, is(nullValue()));
        assertThat(nullValue, nullValue());

        // Not null matchers
        assertThat(nonNullValue, is(notNullValue()));
        assertThat(nonNullValue, notNullValue());
    }
}
```

### Boolean Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class BooleanMatchersTest {

    @Test
    public void testBoolean() {
        boolean trueValue = true;
        boolean falseValue = false;

        // Boolean matchers
        assertThat(trueValue, is(true));
        assertThat(falseValue, is(false));
    }
}
```

### Any Matcher
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class AnyMatcherTest {

    @Test
    public void testAny() {
        String value = "test";
        Integer number = 42;

        // Matches any value of given type
        assertThat(value, any(String.class));
        assertThat(number, any(Integer.class));
        assertThat(value, anyOf(instanceOf(String.class), instanceOf(Integer.class)));
    }
}
```

## Logical Matchers

### Combining Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class LogicalMatchersTest {

    @Test
    public void testNot() {
        String value = "test";

        // Not matcher
        assertThat(value, is(not("other")));
        assertThat(value, not(equalTo("other")));
        assertThat(value, not(startsWith("x")));
    }

    @Test
    public void testAllOf() {
        String value = "Hello World";

        // All matchers must match
        assertThat(value, allOf(
            startsWith("Hello"),
            endsWith("World"),
            containsString("lo Wo")
        ));
    }

    @Test
    public void testAnyOf() {
        int value = 5;

        // At least one matcher must match
        assertThat(value, anyOf(
            equalTo(5),
            equalTo(10),
            equalTo(15)
        ));
    }

    @Test
    public void testBoth() {
        String value = "test";

        // Both conditions must match
        assertThat(value, both(startsWith("te")).and(endsWith("st")));
    }

    @Test
    public void testEither() {
        int value = 5;

        // Either condition must match
        assertThat(value, either(equalTo(5)).or(equalTo(10)));
    }
}
```

## Object Matchers

### Instance Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class InstanceMatchersTest {

    @Test
    public void testInstanceOf() {
        Object obj = "test";

        // Instance of type
        assertThat(obj, instanceOf(String.class));
        assertThat(obj, isA(String.class));

        // Not instance of type
        assertThat(obj, not(instanceOf(Integer.class)));
    }

    @Test
    public void testCompatibleType() {
        Number num = 42;

        // Compatible type
        assertThat(num, instanceOf(Integer.class));
        assertThat(num, instanceOf(Number.class));
    }
}
```

### Has Property Matcher
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() { return name; }
    public int getAge() { return age; }
}

public class PropertyMatchersTest {

    @Test
    public void testHasProperty() {
        Person person = new Person("John", 30);

        // Has property
        assertThat(person, hasProperty("name"));
        assertThat(person, hasProperty("age"));

        // Has property with value
        assertThat(person, hasProperty("name", equalTo("John")));
        assertThat(person, hasProperty("age", equalTo(30)));
    }
}
```

### ToString Matcher
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class ToStringMatcherTest {

    @Test
    public void testToString() {
        Object obj = new Object() {
            @Override
            public String toString() {
                return "Custom Object";
            }
        };

        // Match toString output
        assertThat(obj, hasToString("Custom Object"));
        assertThat(obj, hasToString(containsString("Custom")));
    }
}
```

## Number Matchers

### Comparison Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class NumberMatchersTest {

    @Test
    public void testComparison() {
        int value = 10;

        // Greater than
        assertThat(value, greaterThan(5));
        assertThat(value, greaterThanOrEqualTo(10));

        // Less than
        assertThat(value, lessThan(20));
        assertThat(value, lessThanOrEqualTo(10));

        // Between (combining matchers)
        assertThat(value, allOf(greaterThan(5), lessThan(20)));
    }

    @Test
    public void testCloseTo() {
        double value = 10.5;

        // Close to value within delta
        assertThat(value, closeTo(10.0, 1.0));
        assertThat(value, is(closeTo(10.6, 0.2)));
    }
}
```

## Text Matchers

### String Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class TextMatchersTest {

    @Test
    public void testStringContent() {
        String text = "Hello World";

        // Contains substring
        assertThat(text, containsString("World"));
        assertThat(text, containsStringIgnoringCase("world"));

        // Starts with
        assertThat(text, startsWith("Hello"));
        assertThat(text, startsWithIgnoringCase("hello"));

        // Ends with
        assertThat(text, endsWith("World"));
        assertThat(text, endsWithIgnoringCase("world"));

        // Equal ignoring case
        assertThat(text, equalToIgnoringCase("HELLO WORLD"));

        // Equal ignoring whitespace
        assertThat(" Hello World ", equalToIgnoringWhiteSpace("Hello World"));
    }

    @Test
    public void testEmptyString() {
        String empty = "";
        String blank = "   ";
        String nonEmpty = "test";

        // Empty string
        assertThat(empty, is(emptyString()));
        assertThat(empty, isEmptyString());

        // Empty or null
        assertThat(empty, is(emptyOrNullString()));
        assertThat(null, is(emptyOrNullString()));

        // Blank string (whitespace only)
        assertThat(blank, blankString());
        assertThat(blank, is(blankString()));

        // Blank or null
        assertThat(blank, blankOrNullString());
        assertThat(null, blankOrNullString());
    }

    @Test
    public void testStringLength() {
        String text = "Hello";

        // String length
        assertThat(text, hasLength(5));
        assertThat(text.length(), equalTo(5));
    }
}
```

## Collection Matchers

### Collection Content Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

public class CollectionMatchersTest {

    @Test
    public void testCollectionSize() {
        List<String> list = Arrays.asList("a", "b", "c");

        // Size
        assertThat(list, hasSize(3));
        assertThat(list.size(), equalTo(3));
    }

    @Test
    public void testEmptyCollection() {
        List<String> emptyList = new ArrayList<>();
        List<String> nonEmptyList = Arrays.asList("a", "b");

        // Empty
        assertThat(emptyList, is(empty()));
        assertThat(emptyList, emptyCollectionOf(String.class));

        // Not empty
        assertThat(nonEmptyList, not(empty()));
    }

    @Test
    public void testContainsItem() {
        List<String> list = Arrays.asList("apple", "banana", "cherry");

        // Contains item
        assertThat(list, hasItem("banana"));
        assertThat(list, hasItem(equalTo("banana")));

        // Contains items
        assertThat(list, hasItems("apple", "cherry"));

        // Not contains
        assertThat(list, not(hasItem("orange")));
    }

    @Test
    public void testContainsInOrder() {
        List<String> list = Arrays.asList("a", "b", "c", "d");

        // Contains in order
        assertThat(list, contains("a", "b", "c", "d"));
        assertThat(list, contains(equalTo("a"), equalTo("b"), equalTo("c"), equalTo("d")));

        // Contains in any order
        assertThat(list, containsInAnyOrder("d", "b", "a", "c"));
    }

    @Test
    public void testEveryItem() {
        List<Integer> numbers = Arrays.asList(2, 4, 6, 8);

        // Every item matches
        assertThat(numbers, everyItem(greaterThan(0)));
        assertThat(numbers, everyItem(lessThan(10)));
    }

    @Test
    public void testCollectionIterable() {
        List<String> list = Arrays.asList("a", "b", "c");

        // Iterable contains
        assertThat(list, iterableWithSize(3));
        assertThat(list, contains("a", "b", "c"));
    }
}
```

### Set Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

public class SetMatchersTest {

    @Test
    public void testSet() {
        Set<String> set = new HashSet<>(Arrays.asList("a", "b", "c"));

        // Contains in any order (sets have no order)
        assertThat(set, containsInAnyOrder("c", "a", "b"));
        assertThat(set, hasSize(3));
        assertThat(set, hasItem("b"));
    }
}
```

## Array Matchers

### Array Content Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class ArrayMatchersTest {

    @Test
    public void testArraySize() {
        String[] array = {"a", "b", "c"};

        // Array size
        assertThat(array, arrayWithSize(3));
        assertThat(array.length, equalTo(3));
    }

    @Test
    public void testEmptyArray() {
        String[] emptyArray = {};
        String[] nonEmptyArray = {"a"};

        // Empty array
        assertThat(emptyArray, emptyArray());

        // Not empty
        assertThat(nonEmptyArray, not(emptyArray()));
    }

    @Test
    public void testArrayContains() {
        String[] array = {"apple", "banana", "cherry"};

        // Contains in order
        assertThat(array, arrayContaining("apple", "banana", "cherry"));

        // Contains in any order
        assertThat(array, arrayContainingInAnyOrder("cherry", "apple", "banana"));

        // Has item
        assertThat(array, hasItemInArray("banana"));
    }

    @Test
    public void testPrimitiveArrays() {
        int[] numbers = {1, 2, 3, 4, 5};

        // Primitive arrays
        assertThat(numbers, arrayWithSize(5));
        assertThat(numbers, arrayContaining(1, 2, 3, 4, 5));
    }
}
```

## Map Matchers

### Map Content Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

public class MapMatchersTest {

    @Test
    public void testMapSize() {
        Map<String, Integer> map = new HashMap<>();
        map.put("a", 1);
        map.put("b", 2);

        // Map size
        assertThat(map, aMapWithSize(2));
        assertThat(map.size(), equalTo(2));
    }

    @Test
    public void testEmptyMap() {
        Map<String, Integer> emptyMap = new HashMap<>();
        Map<String, Integer> nonEmptyMap = new HashMap<>();
        nonEmptyMap.put("a", 1);

        // Empty map
        assertThat(emptyMap, anEmptyMap());

        // Not empty
        assertThat(nonEmptyMap, not(anEmptyMap()));
    }

    @Test
    public void testMapContents() {
        Map<String, Integer> map = new HashMap<>();
        map.put("one", 1);
        map.put("two", 2);
        map.put("three", 3);

        // Has key
        assertThat(map, hasKey("one"));
        assertThat(map, hasKey(equalTo("two")));

        // Has value
        assertThat(map, hasValue(1));
        assertThat(map, hasValue(equalTo(2)));

        // Has entry
        assertThat(map, hasEntry("one", 1));
        assertThat(map, hasEntry(equalTo("two"), equalTo(2)));
    }
}
```

## Bean Matchers

### Bean Property Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.hamcrest.beans.SamePropertyValuesAs;
import org.junit.jupiter.api.Test;

class User {
    private String name;
    private String email;
    private int age;

    public User(String name, String email, int age) {
        this.name = name;
        this.email = email;
        this.age = age;
    }

    public String getName() { return name; }
    public String getEmail() { return email; }
    public int getAge() { return age; }
}

public class BeanMatchersTest {

    @Test
    public void testBeanProperty() {
        User user = new User("John", "john@example.com", 30);

        // Has property
        assertThat(user, hasProperty("name"));
        assertThat(user, hasProperty("email"));

        // Has property with value
        assertThat(user, hasProperty("name", equalTo("John")));
        assertThat(user, hasProperty("email", equalTo("john@example.com")));
        assertThat(user, hasProperty("age", equalTo(30)));
    }

    @Test
    public void testSamePropertyValues() {
        User user1 = new User("John", "john@example.com", 30);
        User user2 = new User("John", "john@example.com", 30);

        // Same property values
        assertThat(user1, samePropertyValuesAs(user2));
    }

    @Test
    public void testMultipleProperties() {
        User user = new User("John", "john@example.com", 30);

        // Multiple properties
        assertThat(user, allOf(
            hasProperty("name", equalTo("John")),
            hasProperty("email", containsString("@example.com")),
            hasProperty("age", greaterThan(18))
        ));
    }
}
```

## Custom Matchers

### Creating Custom Matchers
```java
import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;

public class CustomMatchers {

    // Custom matcher for checking if string is palindrome
    public static Matcher<String> isPalindrome() {
        return new TypeSafeMatcher<String>() {
            @Override
            protected boolean matchesSafely(String item) {
                String reversed = new StringBuilder(item).reverse().toString();
                return item.equals(reversed);
            }

            @Override
            public void describeTo(Description description) {
                description.appendText("a palindrome");
            }

            @Override
            protected void describeMismatchSafely(String item, Description mismatchDescription) {
                mismatchDescription.appendText("was ").appendValue(item);
            }
        };
    }

    // Custom matcher with parameter
    public static Matcher<String> hasLength(int expectedLength) {
        return new TypeSafeMatcher<String>() {
            @Override
            protected boolean matchesSafely(String item) {
                return item.length() == expectedLength;
            }

            @Override
            public void describeTo(Description description) {
                description.appendText("a string with length ")
                          .appendValue(expectedLength);
            }

            @Override
            protected void describeMismatchSafely(String item, Description mismatchDescription) {
                mismatchDescription.appendText("had length ")
                                  .appendValue(item.length());
            }
        };
    }
}

// Usage
import static org.hamcrest.MatcherAssert.assertThat;
import org.junit.jupiter.api.Test;

public class CustomMatcherTest {

    @Test
    public void testPalindrome() {
        String text = "racecar";
        assertThat(text, CustomMatchers.isPalindrome());
    }

    @Test
    public void testCustomLength() {
        String text = "hello";
        assertThat(text, CustomMatchers.hasLength(5));
    }
}
```

### Matcher Composition
```java
import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;
import static org.hamcrest.Matchers.*;

public class ComposedMatchers {

    // Compose existing matchers
    public static Matcher<String> validEmail() {
        return allOf(
            notNullValue(),
            containsString("@"),
            matchesPattern("^[A-Za-z0-9+_.-]+@(.+)$")
        );
    }

    // Custom matcher using composition
    public static Matcher<Integer> between(int min, int max) {
        return allOf(
            greaterThanOrEqualTo(min),
            lessThanOrEqualTo(max)
        );
    }
}
```

## Type Safety

### Type-Safe Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

public class TypeSafetyTest {

    @Test
    public void testTypeSafety() {
        List<String> strings = Arrays.asList("a", "b", "c");

        // Type-safe matchers
        assertThat(strings, hasSize(3));
        assertThat(strings, hasItem("b"));
        assertThat(strings, everyItem(instanceOf(String.class)));

        // Generic type preservation
        List<Integer> numbers = Arrays.asList(1, 2, 3);
        assertThat(numbers, everyItem(greaterThan(0)));
    }
}
```

## Common Patterns

### Null-Safe Assertions
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class NullSafeTest {

    @Test
    public void testNullSafe() {
        String value = null;

        // Null-safe assertions
        assertThat(value, anyOf(nullValue(), equalTo("test")));
        assertThat(value, either(nullValue()).or(equalTo("test")));
    }
}
```

### Complex Object Matching
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

class Order {
    private String id;
    private List<String> items;
    private double total;

    public Order(String id, List<String> items, double total) {
        this.id = id;
        this.items = items;
        this.total = total;
    }

    public String getId() { return id; }
    public List<String> getItems() { return items; }
    public double getTotal() { return total; }
}

public class ComplexMatchingTest {

    @Test
    public void testComplexObject() {
        Order order = new Order("ORD-123",
                               Arrays.asList("item1", "item2", "item3"),
                               99.99);

        // Complex object matching
        assertThat(order, allOf(
            hasProperty("id", startsWith("ORD")),
            hasProperty("items", hasSize(3)),
            hasProperty("items", hasItem("item2")),
            hasProperty("total", closeTo(100.0, 0.5))
        ));
    }
}
```

### Assertion Messages
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class AssertionMessagesTest {

    @Test
    public void testWithMessages() {
        String username = "john_doe";
        String email = "john@example.com";

        // Descriptive assertion messages
        assertThat("Username should be lowercase",
                  username, equalTo(username.toLowerCase()));

        assertThat("Email should contain @ symbol",
                  email, containsString("@"));

        assertThat("Email should be valid format",
                  email, matchesPattern("^[A-Za-z0-9+_.-]+@(.+)$"));
    }
}
```

## Integration with JUnit

### JUnit 5 Integration
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

public class JUnit5IntegrationTest {

    @Test
    @DisplayName("Should validate user email format")
    public void testEmailFormat() {
        String email = "user@example.com";

        assertThat("Email should contain @", email, containsString("@"));
        assertThat("Email should end with .com", email, endsWith(".com"));
    }

    @Test
    @DisplayName("Should validate list operations")
    public void testListOperations() {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

        assertThat("List should have 3 elements", names, hasSize(3));
        assertThat("List should contain Bob", names, hasItem("Bob"));
    }
}
```

### JUnit 4 Integration
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.Test;

public class JUnit4IntegrationTest {

    @Test
    public void testBasicAssertions() {
        int value = 10;

        assertThat(value, is(10));
        assertThat(value, greaterThan(5));
    }
}
```

## Integration with TestNG

### TestNG Integration
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.testng.annotations.Test;

public class TestNGIntegrationTest {

    @Test(description = "Validate string operations")
    public void testStringOperations() {
        String text = "Hello World";

        assertThat(text, containsString("World"));
        assertThat(text, startsWith("Hello"));
    }

    @Test(groups = {"smoke"})
    public void testCollectionOperations() {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

        assertThat(numbers, hasSize(5));
        assertThat(numbers, everyItem(greaterThan(0)));
    }
}
```

## Integration with Mockito

### Mockito Argument Matchers
```java
import static org.mockito.Mockito.*;
import static org.mockito.hamcrest.MockitoHamcrest.argThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.junit.jupiter.api.extension.ExtendWith;

interface UserService {
    void createUser(String name, String email);
}

@ExtendWith(MockitoExtension.class)
public class MockitoIntegrationTest {

    @Mock
    private UserService userService;

    @Test
    public void testMockitoWithHamcrest() {
        userService.createUser("John", "john@example.com");

        // Verify with Hamcrest matchers
        verify(userService).createUser(
            argThat(startsWith("J")),
            argThat(containsString("@"))
        );
    }

    @Test
    public void testMockitoStubbing() {
        // Stubbing with Hamcrest matchers
        when(userService.createUser(
            argThat(startsWith("J")),
            argThat(containsString("@example.com"))
        )).then(invocation -> {
            System.out.println("User created");
            return null;
        });

        userService.createUser("John", "john@example.com");
    }
}
```

## Best Practices

### Use Descriptive Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class DescriptiveMatchersTest {

    @Test
    public void useMostDescriptiveMatcher() {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");

        // Good: Specific matcher
        assertThat(names, hasSize(3));

        // Less good: Generic comparison
        // assertThat(names.size(), equalTo(3));

        // Good: Descriptive string matching
        String email = "user@example.com";
        assertThat(email, containsString("@"));

        // Less good: Contains check
        // assertThat(email.contains("@"), is(true));
    }
}
```

### Compose Matchers for Clarity
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class ComposedMatchersTest {

    @Test
    public void composeMatchersForReadability() {
        String password = "SecureP@ss123";

        // Compose multiple matchers
        assertThat(password, allOf(
            hasLength(greaterThan(8)),
            containsString("@"),
            matchesPattern(".*[0-9].*"),
            matchesPattern(".*[A-Z].*")
        ));
    }
}
```

### Provide Meaningful Messages
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class MeaningfulMessagesTest {

    @Test
    public void provideContextInAssertions() {
        int age = 25;
        String email = "user@example.com";

        assertThat("User must be adult", age, greaterThanOrEqualTo(18));
        assertThat("Email must be valid", email, matchesPattern("^[^@]+@[^@]+\\.[^@]+$"));
    }
}
```

### Avoid Overly Complex Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;

public class SimplifyMatchersTest {

    @Test
    public void keepMatchersSimple() {
        List<Integer> numbers = Arrays.asList(1, 2, 3);

        // Good: Simple and clear
        assertThat(numbers, hasSize(3));
        assertThat(numbers, hasItem(2));

        // Avoid: Overly complex nested matchers
        // assertThat(numbers, allOf(
        //     hasSize(greaterThan(0)),
        //     anyOf(hasItem(1), hasItem(2)),
        //     everyItem(anyOf(equalTo(1), equalTo(2), equalTo(3)))
        // ));
    }
}
```

### Use Type-Safe Matchers
```java
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import org.junit.jupiter.api.Test;
import java.util.*;

public class TypeSafeMatchersTest {

    @Test
    public void useTypeSafeMatchers() {
        List<String> names = Arrays.asList("Alice", "Bob");

        // Type-safe
        assertThat(names, hasItem("Alice"));
        assertThat(names, everyItem(instanceOf(String.class)));
    }
}
```

## References

- [Hamcrest Official Documentation](http://hamcrest.org/JavaHamcrest/)
- [Hamcrest Tutorial](http://hamcrest.org/JavaHamcrest/tutorial)
- [Hamcrest GitHub Repository](https://github.com/hamcrest/JavaHamcrest)
- [Hamcrest Javadoc](http://hamcrest.org/JavaHamcrest/javadoc/)
- [JUnit 5 with Hamcrest](https://junit.org/junit5/docs/current/user-guide/#writing-tests-assertions-third-party)
- [Baeldung Hamcrest Guide](https://www.baeldung.com/java-junit-hamcrest-guide)
