# TestNG Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Annotations](#basic-annotations)
- [Test Configuration](#test-configuration)
- [Assertions](#assertions)
- [Test Groups](#test-groups)
- [Test Dependencies](#test-dependencies)
- [Parameterized Tests](#parameterized-tests)
- [Data Providers](#data-providers)
- [Parallel Execution](#parallel-execution)
- [Test Factories](#test-factories)
- [Listeners](#listeners)
- [Test Execution Order](#test-execution-order)
- [XML Configuration](#xml-configuration)
- [Ignoring Tests](#ignoring-tests)
- [Exception Testing](#exception-testing)
- [Timeout](#timeout)
- [Soft Assertions](#soft-assertions)
- [Reporting](#reporting)
- [Integration with Build Tools](#integration-with-build-tools)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)
- [References](#references)

## Introduction

TestNG is a testing framework inspired by JUnit and NUnit, designed to cover all categories of tests: unit, functional, end-to-end, integration, etc.

**Key Features:**
- Flexible test configuration
- Support for data-driven testing
- Powerful execution model (parallel execution, dependencies)
- Flexible test configuration with XML or annotations
- Built-in reporting
- Support for multiple data sets
- Test groups and priorities

## Installation

### Maven
```xml
<!-- pom.xml -->
<dependencies>
    <!-- TestNG -->
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.8.0</version>
        <scope>test</scope>
    </dependency>

    <!-- Optional: For better assertions -->
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- Maven Surefire Plugin -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0</version>
            <configuration>
                <suiteXmlFiles>
                    <suiteXmlFile>testng.xml</suiteXmlFile>
                </suiteXmlFiles>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### Gradle
```groovy
// build.gradle
dependencies {
    testImplementation 'org.testng:testng:7.8.0'

    // Optional: For better assertions
    testImplementation 'org.assertj:assertj-core:3.24.2'
}

test {
    useTestNG() {
        // Use all testng.xml files
        suites 'src/test/resources/testng.xml'

        // Or specify test classes
        // includeGroups 'smoke', 'regression'
        // excludeGroups 'slow'
    }
}
```

### Gradle Kotlin DSL
```kotlin
// build.gradle.kts
dependencies {
    testImplementation("org.testng:testng:7.8.0")
    testImplementation("org.assertj:assertj-core:3.24.2")
}

tasks.test {
    useTestNG {
        suites("src/test/resources/testng.xml")
    }
}
```

## Basic Annotations

### Test Annotation
```java
import org.testng.annotations.Test;
import org.testng.Assert;

public class BasicTest {

    @Test
    public void testMethod() {
        int result = 5 + 3;
        Assert.assertEquals(result, 8);
    }

    @Test(description = "Test addition functionality")
    public void testWithDescription() {
        Assert.assertTrue(10 > 5);
    }

    @Test(enabled = false)
    public void disabledTest() {
        // This test will not run
    }
}
```

### Configuration Annotations
```java
import org.testng.annotations.*;

public class ConfigurationTest {

    @BeforeSuite
    public void beforeSuite() {
        System.out.println("Before Suite - runs once before all tests");
    }

    @AfterSuite
    public void afterSuite() {
        System.out.println("After Suite - runs once after all tests");
    }

    @BeforeTest
    public void beforeTest() {
        System.out.println("Before Test - runs before each <test> tag");
    }

    @AfterTest
    public void afterTest() {
        System.out.println("After Test - runs after each <test> tag");
    }

    @BeforeClass
    public void beforeClass() {
        System.out.println("Before Class - runs once before first test method");
    }

    @AfterClass
    public void afterClass() {
        System.out.println("After Class - runs once after all test methods");
    }

    @BeforeMethod
    public void beforeMethod() {
        System.out.println("Before Method - runs before each test method");
    }

    @AfterMethod
    public void afterMethod() {
        System.out.println("After Method - runs after each test method");
    }

    @Test
    public void testMethod1() {
        System.out.println("Test Method 1");
    }

    @Test
    public void testMethod2() {
        System.out.println("Test Method 2");
    }
}
```

### Annotation Execution Order
```java
// Execution order:
// @BeforeSuite
// @BeforeTest
// @BeforeClass
// @BeforeMethod
// @Test
// @AfterMethod
// @BeforeMethod
// @Test
// @AfterMethod
// @AfterClass
// @AfterTest
// @AfterSuite
```

## Test Configuration

### Test Attributes
```java
import org.testng.annotations.Test;

public class TestAttributesExample {

    // Test with priority (lower number runs first)
    @Test(priority = 1)
    public void testOne() {
        System.out.println("Test 1");
    }

    @Test(priority = 2)
    public void testTwo() {
        System.out.println("Test 2");
    }

    // Test with timeout (in milliseconds)
    @Test(timeOut = 5000)
    public void testWithTimeout() throws InterruptedException {
        Thread.sleep(4000); // Will pass
    }

    // Test expecting exception
    @Test(expectedExceptions = ArithmeticException.class)
    public void testException() {
        int result = 10 / 0;
    }

    // Test with enabled flag
    @Test(enabled = false)
    public void disabledTest() {
        // This test is disabled
    }

    // Test with description
    @Test(description = "This test verifies login functionality")
    public void testLogin() {
        // Test code
    }

    // Test with invocation count
    @Test(invocationCount = 5)
    public void testRepeated() {
        System.out.println("This will run 5 times");
    }

    // Test with thread pool size
    @Test(invocationCount = 10, threadPoolSize = 3)
    public void testParallel() {
        System.out.println("Thread: " + Thread.currentThread().getId());
    }
}
```

## Assertions

### Basic Assertions
```java
import org.testng.Assert;

public class AssertionsTest {

    @Test
    public void testAssertions() {
        // Equality assertions
        Assert.assertEquals(5, 5);
        Assert.assertEquals("Hello", "Hello");
        Assert.assertEquals(5, 5, "Values should be equal");

        // True/False assertions
        Assert.assertTrue(10 > 5);
        Assert.assertFalse(5 > 10);
        Assert.assertTrue(10 > 5, "10 should be greater than 5");

        // Null assertions
        String str = null;
        Assert.assertNull(str);
        Assert.assertNull(str, "String should be null");

        String str2 = "NotNull";
        Assert.assertNotNull(str2);
        Assert.assertNotNull(str2, "String should not be null");

        // Same/Not Same assertions
        String obj1 = "Test";
        String obj2 = "Test";
        String obj3 = new String("Test");
        Assert.assertSame(obj1, obj2);
        Assert.assertNotSame(obj1, obj3);

        // Not Equals
        Assert.assertNotEquals(5, 10);
        Assert.assertNotEquals("Hello", "World");

        // Fail
        // Assert.fail("Intentional failure");
        // Assert.fail("Test failed due to...", new Exception());
    }
}
```

### Array and Collection Assertions
```java
import org.testng.Assert;
import java.util.Arrays;
import java.util.List;

public class CollectionAssertionsTest {

    @Test
    public void testArrayAssertions() {
        int[] actual = {1, 2, 3};
        int[] expected = {1, 2, 3};
        Assert.assertEquals(actual, expected);

        String[] stringArray = {"a", "b", "c"};
        String[] expectedArray = {"a", "b", "c"};
        Assert.assertEquals(stringArray, expectedArray);
    }

    @Test
    public void testListAssertions() {
        List<String> actual = Arrays.asList("a", "b", "c");
        List<String> expected = Arrays.asList("a", "b", "c");
        Assert.assertEquals(actual, expected);
    }
}
```

## Assertions

### Soft Assertions
```java
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

public class SoftAssertionsTest {

    @Test
    public void testSoftAssertions() {
        SoftAssert softAssert = new SoftAssert();

        softAssert.assertEquals(5, 5, "First assertion");
        softAssert.assertEquals(10, 15, "Second assertion will fail");
        softAssert.assertTrue(true, "Third assertion");
        softAssert.assertFalse(true, "Fourth assertion will fail");

        // All assertions are collected and reported together
        softAssert.assertAll();
    }
}
```

## Test Groups

### Defining Groups
```java
import org.testng.annotations.Test;

public class GroupsTest {

    @Test(groups = {"smoke"})
    public void testLogin() {
        System.out.println("Login test - Smoke");
    }

    @Test(groups = {"smoke", "regression"})
    public void testLogout() {
        System.out.println("Logout test - Smoke and Regression");
    }

    @Test(groups = {"regression"})
    public void testUserProfile() {
        System.out.println("User Profile test - Regression");
    }

    @Test(groups = {"integration"})
    public void testDatabaseConnection() {
        System.out.println("Database test - Integration");
    }
}
```

### Group Configuration
```java
import org.testng.annotations.*;

public class GroupConfigTest {

    @BeforeGroups(groups = {"smoke"})
    public void beforeSmokeTests() {
        System.out.println("Setup before smoke tests");
    }

    @AfterGroups(groups = {"smoke"})
    public void afterSmokeTests() {
        System.out.println("Cleanup after smoke tests");
    }

    @Test(groups = {"smoke"})
    public void smokeTest1() {
        System.out.println("Smoke Test 1");
    }

    @Test(groups = {"smoke"})
    public void smokeTest2() {
        System.out.println("Smoke Test 2");
    }
}
```

### Running Specific Groups
```xml
<!-- testng.xml -->
<suite name="Test Suite">
    <test name="Smoke Tests">
        <groups>
            <run>
                <include name="smoke" />
            </run>
        </groups>
        <classes>
            <class name="com.example.GroupsTest" />
        </classes>
    </test>
</suite>
```

## Test Dependencies

### Method Dependencies
```java
import org.testng.annotations.Test;

public class DependenciesTest {

    @Test
    public void testLogin() {
        System.out.println("Login successful");
    }

    @Test(dependsOnMethods = {"testLogin"})
    public void testDashboard() {
        System.out.println("Dashboard loaded");
    }

    @Test(dependsOnMethods = {"testDashboard"})
    public void testLogout() {
        System.out.println("Logout successful");
    }

    // Multiple dependencies
    @Test
    public void testA() {
        System.out.println("Test A");
    }

    @Test
    public void testB() {
        System.out.println("Test B");
    }

    @Test(dependsOnMethods = {"testA", "testB"})
    public void testC() {
        System.out.println("Test C - depends on A and B");
    }
}
```

### Group Dependencies
```java
import org.testng.annotations.Test;

public class GroupDependenciesTest {

    @Test(groups = {"init"})
    public void initDatabase() {
        System.out.println("Initialize database");
    }

    @Test(groups = {"init"})
    public void initCache() {
        System.out.println("Initialize cache");
    }

    @Test(groups = {"database"}, dependsOnGroups = {"init"})
    public void testDatabaseOperation() {
        System.out.println("Database operation");
    }

    @Test(groups = {"cache"}, dependsOnGroups = {"init"})
    public void testCacheOperation() {
        System.out.println("Cache operation");
    }
}
```

### Always Run
```java
import org.testng.annotations.Test;

public class AlwaysRunTest {

    @Test
    public void testMethod1() {
        System.out.println("Test Method 1");
        throw new RuntimeException("Test failed");
    }

    @Test(dependsOnMethods = {"testMethod1"}, alwaysRun = true)
    public void cleanupMethod() {
        System.out.println("Cleanup - runs even if testMethod1 fails");
    }
}
```

## Parameterized Tests

### Using @Parameters
```java
import org.testng.annotations.Parameters;
import org.testng.annotations.Test;
import org.testng.Assert;

public class ParameterizedTest {

    @Test
    @Parameters({"username", "password"})
    public void testLogin(String username, String password) {
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        Assert.assertNotNull(username);
        Assert.assertNotNull(password);
    }

    @Test
    @Parameters({"url"})
    public void testURL(String url) {
        System.out.println("URL: " + url);
        Assert.assertTrue(url.startsWith("http"));
    }
}
```

### Parameters XML Configuration
```xml
<!-- testng.xml -->
<suite name="Parameterized Suite">
    <test name="Login Test">
        <parameter name="username" value="testuser" />
        <parameter name="password" value="testpass123" />
        <parameter name="url" value="https://example.com" />
        <classes>
            <class name="com.example.ParameterizedTest" />
        </classes>
    </test>
</suite>
```

### Optional Parameters
```java
import org.testng.annotations.Parameters;
import org.testng.annotations.Optional;
import org.testng.annotations.Test;

public class OptionalParametersTest {

    @Test
    @Parameters({"browser"})
    public void testBrowser(@Optional("chrome") String browser) {
        System.out.println("Browser: " + browser);
        // Uses "chrome" if parameter not provided in XML
    }
}
```

## Data Providers

### Basic Data Provider
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import org.testng.Assert;

public class DataProviderTest {

    @DataProvider(name = "loginData")
    public Object[][] provideLoginData() {
        return new Object[][] {
            {"user1", "pass1"},
            {"user2", "pass2"},
            {"user3", "pass3"}
        };
    }

    @Test(dataProvider = "loginData")
    public void testLogin(String username, String password) {
        System.out.println("Testing with: " + username + " / " + password);
        Assert.assertNotNull(username);
        Assert.assertNotNull(password);
    }
}
```

### Data Provider with Different Types
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class DataProviderTypesTest {

    @DataProvider(name = "mixedData")
    public Object[][] provideMixedData() {
        return new Object[][] {
            {"John", 25, true},
            {"Jane", 30, false},
            {"Bob", 35, true}
        };
    }

    @Test(dataProvider = "mixedData")
    public void testUser(String name, int age, boolean active) {
        System.out.println("Name: " + name + ", Age: " + age + ", Active: " + active);
    }
}
```

### Data Provider from External Source
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ExternalDataProviderTest {

    @DataProvider(name = "userData")
    public Iterator<Object[]> provideUserData() {
        List<Object[]> data = new ArrayList<>();
        // Could read from database, file, API, etc.
        data.add(new Object[]{"user1", "email1@example.com"});
        data.add(new Object[]{"user2", "email2@example.com"});
        data.add(new Object[]{"user3", "email3@example.com"});
        return data.iterator();
    }

    @Test(dataProvider = "userData")
    public void testUserEmail(String username, String email) {
        System.out.println("Username: " + username + ", Email: " + email);
    }
}
```

### Data Provider in Different Class
```java
// DataProviders.java
public class DataProviders {

    @DataProvider(name = "searchData")
    public static Object[][] provideSearchData() {
        return new Object[][] {
            {"TestNG"},
            {"Java"},
            {"Selenium"}
        };
    }
}

// SearchTest.java
import org.testng.annotations.Test;

public class SearchTest {

    @Test(dataProvider = "searchData", dataProviderClass = DataProviders.class)
    public void testSearch(String keyword) {
        System.out.println("Searching for: " + keyword);
    }
}
```

### Parallel Data Provider
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class ParallelDataProviderTest {

    @DataProvider(name = "parallelData", parallel = true)
    public Object[][] provideParallelData() {
        return new Object[][] {
            {"Data1"},
            {"Data2"},
            {"Data3"},
            {"Data4"}
        };
    }

    @Test(dataProvider = "parallelData")
    public void testParallel(String data) {
        System.out.println("Thread: " + Thread.currentThread().getId() + ", Data: " + data);
    }
}
```

## Parallel Execution

### Parallel Methods
```java
import org.testng.annotations.Test;

public class ParallelTest {

    @Test
    public void test1() {
        System.out.println("Test 1 - Thread: " + Thread.currentThread().getId());
    }

    @Test
    public void test2() {
        System.out.println("Test 2 - Thread: " + Thread.currentThread().getId());
    }

    @Test
    public void test3() {
        System.out.println("Test 3 - Thread: " + Thread.currentThread().getId());
    }
}
```

### Parallel Configuration in XML
```xml
<!-- testng.xml -->
<!-- Parallel by methods -->
<suite name="Parallel Suite" parallel="methods" thread-count="3">
    <test name="Parallel Test">
        <classes>
            <class name="com.example.ParallelTest" />
        </classes>
    </test>
</suite>

<!-- Parallel by tests -->
<suite name="Parallel Suite" parallel="tests" thread-count="2">
    <test name="Test 1">
        <classes>
            <class name="com.example.Test1" />
        </classes>
    </test>
    <test name="Test 2">
        <classes>
            <class name="com.example.Test2" />
        </classes>
    </test>
</suite>

<!-- Parallel by classes -->
<suite name="Parallel Suite" parallel="classes" thread-count="2">
    <test name="Parallel Test">
        <classes>
            <class name="com.example.TestClass1" />
            <class name="com.example.TestClass2" />
        </classes>
    </test>
</suite>

<!-- Parallel by instances -->
<suite name="Parallel Suite" parallel="instances" thread-count="2">
    <test name="Parallel Test">
        <classes>
            <class name="com.example.TestClass1" />
            <class name="com.example.TestClass2" />
        </classes>
    </test>
</suite>
```

## Test Factories

### Basic Test Factory
```java
import org.testng.annotations.Factory;
import org.testng.annotations.Test;

public class TestFactoryExample {

    private int number;

    @Factory
    public Object[] createInstances() {
        return new Object[] {
            new TestFactoryExample(1),
            new TestFactoryExample(2),
            new TestFactoryExample(3)
        };
    }

    public TestFactoryExample(int number) {
        this.number = number;
    }

    @Test
    public void testMethod() {
        System.out.println("Test with number: " + number);
    }
}
```

### Factory with Data Provider
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Factory;
import org.testng.annotations.Test;

public class FactoryWithDataProviderTest {

    private String username;

    @Factory(dataProvider = "userProvider")
    public FactoryWithDataProviderTest(String username) {
        this.username = username;
    }

    @DataProvider(name = "userProvider")
    public static Object[][] provideUsers() {
        return new Object[][] {
            {"user1"},
            {"user2"},
            {"user3"}
        };
    }

    @Test
    public void testUser() {
        System.out.println("Testing user: " + username);
    }
}
```

## Listeners

### Test Listener
```java
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class CustomTestListener implements ITestListener {

    @Override
    public void onStart(ITestContext context) {
        System.out.println("Test Suite started: " + context.getName());
    }

    @Override
    public void onFinish(ITestContext context) {
        System.out.println("Test Suite finished: " + context.getName());
    }

    @Override
    public void onTestStart(ITestResult result) {
        System.out.println("Test started: " + result.getName());
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        System.out.println("Test passed: " + result.getName());
    }

    @Override
    public void onTestFailure(ITestResult result) {
        System.out.println("Test failed: " + result.getName());
        System.out.println("Reason: " + result.getThrowable());
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        System.out.println("Test skipped: " + result.getName());
    }

    @Override
    public void onTestFailedButWithinSuccessPercentage(ITestResult result) {
        System.out.println("Test failed but within success percentage: " + result.getName());
    }
}
```

### Using Listener with Annotation
```java
import org.testng.annotations.Listeners;
import org.testng.annotations.Test;

@Listeners(CustomTestListener.class)
public class ListenerTest {

    @Test
    public void testSuccess() {
        System.out.println("This test will pass");
    }

    @Test
    public void testFailure() {
        System.out.println("This test will fail");
        throw new RuntimeException("Intentional failure");
    }
}
```

### Listener in XML
```xml
<!-- testng.xml -->
<suite name="Test Suite">
    <listeners>
        <listener class-name="com.example.CustomTestListener" />
    </listeners>
    <test name="Test">
        <classes>
            <class name="com.example.TestClass" />
        </classes>
    </test>
</suite>
```

### Retry Analyzer
```java
import org.testng.IRetryAnalyzer;
import org.testng.ITestResult;

public class RetryAnalyzer implements IRetryAnalyzer {

    private int retryCount = 0;
    private static final int MAX_RETRY_COUNT = 3;

    @Override
    public boolean retry(ITestResult result) {
        if (retryCount < MAX_RETRY_COUNT) {
            System.out.println("Retrying test: " + result.getName() +
                             " for the " + (retryCount + 1) + " time");
            retryCount++;
            return true;
        }
        return false;
    }
}

// Using RetryAnalyzer
public class RetryTest {

    @Test(retryAnalyzer = RetryAnalyzer.class)
    public void testWithRetry() {
        // Test that might fail intermittently
        if (Math.random() > 0.5) {
            throw new RuntimeException("Random failure");
        }
    }
}
```

## Test Execution Order

### Priority
```java
import org.testng.annotations.Test;

public class PriorityTest {

    @Test(priority = 1)
    public void firstTest() {
        System.out.println("First - Priority 1");
    }

    @Test(priority = 2)
    public void secondTest() {
        System.out.println("Second - Priority 2");
    }

    @Test(priority = 3)
    public void thirdTest() {
        System.out.println("Third - Priority 3");
    }

    @Test // No priority = 0 (default)
    public void defaultPriority() {
        System.out.println("Default - Priority 0");
    }
}
```

### Preserve Order
```xml
<!-- testng.xml -->
<suite name="Test Suite">
    <test name="Test" preserve-order="true">
        <classes>
            <class name="com.example.Test1" />
            <class name="com.example.Test2" />
            <class name="com.example.Test3" />
        </classes>
    </test>
</suite>
```

## XML Configuration

### Basic XML Configuration
```xml
<!-- testng.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Test Suite" verbose="1">
    <test name="Sample Test">
        <classes>
            <class name="com.example.TestClass1" />
            <class name="com.example.TestClass2" />
        </classes>
    </test>
</suite>
```

### Complete XML Configuration
```xml
<!-- testng.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Complete Test Suite" parallel="methods" thread-count="3" verbose="1">

    <!-- Global parameters -->
    <parameter name="environment" value="staging" />

    <!-- Listeners -->
    <listeners>
        <listener class-name="com.example.CustomTestListener" />
    </listeners>

    <!-- Test 1 -->
    <test name="Smoke Tests" preserve-order="true">
        <parameter name="browser" value="chrome" />

        <groups>
            <run>
                <include name="smoke" />
            </run>
        </groups>

        <classes>
            <class name="com.example.LoginTest" />
            <class name="com.example.HomePageTest" />
        </classes>
    </test>

    <!-- Test 2 -->
    <test name="Regression Tests">
        <parameter name="browser" value="firefox" />

        <groups>
            <run>
                <include name="regression" />
                <exclude name="slow" />
            </run>
        </groups>

        <packages>
            <package name="com.example.tests.*" />
        </packages>
    </test>

    <!-- Test 3 - Specific methods -->
    <test name="Specific Methods">
        <classes>
            <class name="com.example.UserTest">
                <methods>
                    <include name="testCreateUser" />
                    <include name="testUpdateUser" />
                    <exclude name="testDeleteUser" />
                </methods>
            </class>
        </classes>
    </test>
</suite>
```

### Multiple Suite Files
```xml
<!-- master-suite.xml -->
<suite name="Master Suite">
    <suite-files>
        <suite-file path="smoke-suite.xml" />
        <suite-file path="regression-suite.xml" />
    </suite-files>
</suite>
```

## Ignoring Tests

### Disable Test
```java
import org.testng.annotations.Test;

public class IgnoreTest {

    @Test(enabled = false)
    public void disabledTest() {
        System.out.println("This test is disabled");
    }

    @Test(enabled = true)
    public void enabledTest() {
        System.out.println("This test is enabled");
    }
}
```

### Conditional Ignore
```java
import org.testng.SkipException;
import org.testng.annotations.Test;

public class ConditionalSkipTest {

    @Test
    public void conditionalTest() {
        String environment = System.getProperty("env", "dev");

        if ("prod".equals(environment)) {
            throw new SkipException("Skipping test in production");
        }

        System.out.println("Running test in: " + environment);
    }
}
```

## Exception Testing

### Expected Exception
```java
import org.testng.annotations.Test;

public class ExceptionTest {

    @Test(expectedExceptions = ArithmeticException.class)
    public void testDivideByZero() {
        int result = 10 / 0;
    }

    @Test(expectedExceptions = {NullPointerException.class, ArrayIndexOutOfBoundsException.class})
    public void testMultipleExceptions() {
        String str = null;
        str.length(); // Will throw NullPointerException
    }

    @Test(expectedExceptions = IllegalArgumentException.class,
          expectedExceptionsMessageRegExp = ".*invalid.*")
    public void testExceptionMessage() {
        throw new IllegalArgumentException("This is invalid input");
    }
}
```

## Timeout

### Method Timeout
```java
import org.testng.annotations.Test;

public class TimeoutTest {

    @Test(timeOut = 5000) // 5 seconds
    public void testWithTimeout() throws InterruptedException {
        Thread.sleep(4000); // Will pass
    }

    @Test(timeOut = 2000)
    public void testTimeoutFailure() throws InterruptedException {
        Thread.sleep(3000); // Will fail - exceeds timeout
    }
}
```

### Class-Level Timeout
```xml
<!-- testng.xml -->
<suite name="Test Suite" time-out="10000">
    <test name="Test">
        <classes>
            <class name="com.example.TestClass" />
        </classes>
    </test>
</suite>
```

## Soft Assertions

### Using SoftAssert
```java
import org.testng.annotations.Test;
import org.testng.asserts.SoftAssert;

public class SoftAssertTest {

    @Test
    public void testMultipleAssertions() {
        SoftAssert softAssert = new SoftAssert();

        softAssert.assertEquals(5, 5, "First assertion");
        softAssert.assertTrue(10 > 5, "Second assertion");
        softAssert.assertEquals("Hello", "Hello", "Third assertion");
        softAssert.assertFalse(5 > 10, "Fourth assertion");

        // Collect all assertion failures and report
        softAssert.assertAll();
    }

    @Test
    public void testFormValidation() {
        SoftAssert softAssert = new SoftAssert();

        String name = "";
        String email = "invalidemail";
        int age = -5;

        softAssert.assertFalse(name.isEmpty(), "Name should not be empty");
        softAssert.assertTrue(email.contains("@"), "Email should contain @");
        softAssert.assertTrue(age > 0, "Age should be positive");

        softAssert.assertAll();
    }
}
```

## Reporting

### Default Reports
```bash
# After test execution, reports are generated in:
# test-output/
# ├── index.html           # Main report
# ├── emailable-report.html # Email-friendly report
# └── testng-results.xml   # XML results
```

### Custom Report
```java
import org.testng.IReporter;
import org.testng.ISuite;
import org.testng.xml.XmlSuite;
import java.util.List;

public class CustomReporter implements IReporter {

    @Override
    public void generateReport(List<XmlSuite> xmlSuites, List<ISuite> suites, String outputDirectory) {
        for (ISuite suite : suites) {
            System.out.println("Suite: " + suite.getName());
            // Custom reporting logic
        }
    }
}
```

## Integration with Build Tools

### Maven Configuration
```xml
<!-- pom.xml -->
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0</version>
            <configuration>
                <!-- TestNG suite XML file -->
                <suiteXmlFiles>
                    <suiteXmlFile>testng.xml</suiteXmlFile>
                </suiteXmlFiles>

                <!-- Or specify groups -->
                <!-- <groups>smoke,regression</groups> -->

                <!-- System properties -->
                <systemPropertyVariables>
                    <environment>staging</environment>
                </systemPropertyVariables>

                <!-- Parallel execution -->
                <parallel>methods</parallel>
                <threadCount>3</threadCount>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### Gradle Configuration
```groovy
// build.gradle
test {
    useTestNG() {
        // Suite XML file
        suites 'src/test/resources/testng.xml'

        // Or specify groups
        // includeGroups 'smoke', 'regression'
        // excludeGroups 'slow'

        // Parallel execution
        parallel 'methods'
        threadCount 3

        // System properties
        systemProperty 'environment', 'staging'
    }

    // Test output
    testLogging {
        events "passed", "skipped", "failed"
        showStandardStreams = true
    }
}
```

## Best Practices

### Organize Tests
```java
// Use packages to organize tests
// src/test/java/
// ├── com/example/
// │   ├── smoke/
// │   │   ├── LoginTest.java
// │   │   └── HomePageTest.java
// │   ├── regression/
// │   │   ├── UserManagementTest.java
// │   │   └── ReportingTest.java
// │   └── integration/
// │       └── DatabaseTest.java
```

### Use Meaningful Names
```java
public class UserManagementTest {

    @Test(description = "Verify user can be created with valid data")
    public void testCreateUserWithValidData() {
        // Test code
    }

    @Test(description = "Verify user creation fails with invalid email")
    public void testCreateUserWithInvalidEmail() {
        // Test code
    }
}
```

### Setup and Teardown
```java
import org.testng.annotations.*;

public class SetupTeardownTest {

    private WebDriver driver;

    @BeforeClass
    public void setupClass() {
        // One-time setup
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
    }

    @BeforeMethod
    public void setupMethod() {
        // Setup before each test
        driver = new ChromeDriver();
    }

    @AfterMethod
    public void teardownMethod() {
        // Cleanup after each test
        if (driver != null) {
            driver.quit();
        }
    }

    @AfterClass
    public void teardownClass() {
        // One-time cleanup
    }

    @Test
    public void testMethod() {
        driver.get("https://example.com");
    }
}
```

### Use Groups Effectively
```java
@Test(groups = {"smoke", "critical"})
public void testLogin() {
    // Critical smoke test
}

@Test(groups = {"regression", "ui"})
public void testUserInterface() {
    // UI regression test
}

@Test(groups = {"integration", "database"})
public void testDatabaseConnection() {
    // Database integration test
}
```

## Common Patterns

### Page Object Model with TestNG
```java
// LoginPage.java
public class LoginPage {
    private WebDriver driver;

    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    public void login(String username, String password) {
        // Login logic
    }
}

// LoginTest.java
import org.testng.annotations.*;

public class LoginTest {
    private WebDriver driver;
    private LoginPage loginPage;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
        loginPage = new LoginPage(driver);
    }

    @Test(dataProvider = "loginData")
    public void testLogin(String username, String password) {
        loginPage.login(username, password);
        // Assertions
    }

    @DataProvider(name = "loginData")
    public Object[][] provideLoginData() {
        return new Object[][] {
            {"user1", "pass1"},
            {"user2", "pass2"}
        };
    }

    @AfterMethod
    public void teardown() {
        driver.quit();
    }
}
```

### API Testing with TestNG
```java
import io.restassured.RestAssured;
import io.restassured.response.Response;
import org.testng.annotations.Test;
import static org.testng.Assert.*;

public class APITest {

    @Test
    public void testGetUser() {
        Response response = RestAssured
            .given()
                .baseUri("https://api.example.com")
                .basePath("/users/1")
            .when()
                .get()
            .then()
                .extract().response();

        assertEquals(response.statusCode(), 200);
        assertNotNull(response.jsonPath().getString("name"));
    }
}
```

## References

- [TestNG Official Documentation](https://testng.org/doc/documentation-main.html)
- [TestNG GitHub Repository](https://github.com/testng-team/testng)
- [TestNG Javadoc](https://javadoc.io/doc/org.testng/testng/latest/index.html)
- [TestNG Tutorial](https://www.baeldung.com/testng)
- [TestNG vs JUnit](https://www.baeldung.com/junit-vs-testng)
