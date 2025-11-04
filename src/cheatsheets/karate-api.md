# Karate API Testing Cheat Sheet

## Table of Contents
- [Setup and Installation](#setup-and-installation)
  - [Maven Setup](#maven-setup)
  - [Gradle Setup](#gradle-setup)
  - [Project Structure](#project-structure)
- [Basic Syntax](#basic-syntax)
  - [Feature Files](#feature-files)
  - [Scenarios](#scenarios)
  - [Comments](#comments)
- [HTTP Requests](#http-requests)
  - [GET Requests](#get-requests)
  - [POST Requests](#post-requests)
  - [PUT Requests](#put-requests)
  - [DELETE Requests](#delete-requests)
  - [PATCH Requests](#patch-requests)
- [Request Configuration](#request-configuration)
  - [Headers](#headers)
  - [Query Parameters](#query-parameters)
  - [Path Parameters](#path-parameters)
  - [Request Body](#request-body)
  - [Form Data](#form-data)
  - [Multipart Files](#multipart-files)
- [Response Validation](#response-validation)
  - [Status Validation](#status-validation)
  - [Response Matching](#response-matching)
  - [JSON Path](#json-path)
  - [Schema Validation](#schema-validation)
- [Variables and Data](#variables-and-data)
  - [Defining Variables](#defining-variables)
  - [Reading Files](#reading-files)
  - [Data Tables](#data-tables)
  - [Embedded Expressions](#embedded-expressions)
- [Assertions](#assertions)
  - [Match Types](#match-types)
  - [Fuzzy Matching](#fuzzy-matching)
  - [Contains Assertions](#contains-assertions)
- [Reusable Features](#reusable-features)
  - [Calling Features](#calling-features)
  - [Background](#background)
  - [Tags](#tags)
- [Data-Driven Testing](#data-driven-testing)
  - [Scenario Outline](#scenario-outline)
  - [Examples Table](#examples-table)
  - [CSV Files](#csv-files)
  - [JSON Arrays](#json-arrays)
- [JavaScript Functions](#javascript-functions)
  - [Inline Functions](#inline-functions)
  - [External JS Files](#external-js-files)
  - [Java Interop](#java-interop)
- [Authentication](#authentication)
  - [Basic Auth](#basic-auth)
  - [OAuth 2.0](#oauth-20)
  - [Bearer Tokens](#bearer-tokens)
  - [Custom Auth](#custom-auth)
- [Configuration](#configuration)
  - [karate-config.js](#karate-configjs)
  - [Environment Config](#environment-config)
  - [Timeouts](#timeouts)
  - [SSL Configuration](#ssl-configuration)
- [Parallel Execution](#parallel-execution)
  - [Runner Configuration](#runner-configuration)
  - [Thread Configuration](#thread-configuration)
- [Reporting](#reporting)
  - [HTML Reports](#html-reports)
  - [Cucumber Reports](#cucumber-reports)
  - [Custom Reports](#custom-reports)
- [Mocking and Test Doubles](#mocking-and-test-doubles)
  - [Mock Server](#mock-server)
  - [Conditional Responses](#conditional-responses)
- [Database Testing](#database-testing)
  - [JDBC Configuration](#jdbc-configuration)
  - [SQL Queries](#sql-queries)
- [Performance Testing](#performance-testing)
  - [Gatling Integration](#gatling-integration)
  - [Load Testing](#load-testing)
- [Debugging](#debugging)
  - [Print Statements](#print-statements)
  - [Karate UI](#karate-ui)
  - [IDE Support](#ide-support)
- [Best Practices](#best-practices)
  - [Organization](#organization)
  - [Naming Conventions](#naming-conventions)
  - [Error Handling](#error-handling)

## Setup and Installation

### Maven Setup
```xml
<dependency>
    <groupId>com.intuit.karate</groupId>
    <artifactId>karate-junit5</artifactId>
    <version>1.4.1</version>
    <scope>test</scope>
</dependency>
```

### Gradle Setup
```gradle
testImplementation 'com.intuit.karate:karate-junit5:1.4.1'
```

### Project Structure
```
src/test/java/
├── karate-config.js       # Global configuration
├── features/              # Feature files
│   ├── users.feature
│   └── auth.feature
├── runners/               # Test runners
│   └── TestRunner.java
└── mocks/                # Mock data files
    └── user.json
```

## Basic Syntax

### Feature Files
```gherkin
Feature: User API Tests
  Background section for common setup

  Background:
    * url 'https://api.example.com'
    * header Accept = 'application/json'
```

### Scenarios
```gherkin
Scenario: Get user by ID
  Given path 'users', userId
  When method GET
  Then status 200
  And match response == expectedUser
```

### Comments
```gherkin
# This is a comment
Feature: API Tests
  # Another comment
  * print 'test' # Inline comment
```

## HTTP Requests

### GET Requests
```gherkin
# Simple GET
Given url 'https://api.example.com/users'
When method GET
Then status 200

# GET with path
Given path 'users', 123
When method GET
Then status 200

# GET with query parameters
Given param page = 1
And param size = 10
When method GET
Then status 200
```

### POST Requests
```gherkin
# POST with JSON body
Given url 'https://api.example.com/users'
And request { name: 'John', age: 30 }
When method POST
Then status 201

# POST with variable
* def user = { name: 'John', email: 'john@example.com' }
Given request user
When method POST
Then status 201
```

### PUT Requests
```gherkin
Given path 'users', userId
And request { name: 'Updated Name' }
When method PUT
Then status 200
```

### DELETE Requests
```gherkin
Given path 'users', userId
When method DELETE
Then status 204
```

### PATCH Requests
```gherkin
Given path 'users', userId
And request { status: 'active' }
When method PATCH
Then status 200
```

## Request Configuration

### Headers
```gherkin
# Single header
Given header Authorization = 'Bearer ' + token
And header Content-Type = 'application/json'

# Multiple headers
Given headers { Authorization: 'Bearer token', Accept: 'application/json' }

# Headers from variable
* def headers = { 'X-API-Key': 'secret', 'X-Request-ID': '12345' }
Given headers headers
```

### Query Parameters
```gherkin
# Single parameter
Given param search = 'john'
And param limit = 10

# Multiple parameters
Given params { page: 1, size: 20, sort: 'name' }

# Parameters from variable
* def queryParams = { status: 'active', role: 'admin' }
Given params queryParams
```

### Path Parameters
```gherkin
# Single path parameter
Given path 'users', userId

# Multiple path parameters
Given path 'organizations', orgId, 'users', userId

# Dynamic paths
* def endpoint = 'users/' + userId + '/posts'
Given path endpoint
```

### Request Body
```gherkin
# JSON body
Given request { name: 'John', age: 30 }

# JSON from file
Given request read('classpath:data/user.json')

# XML body
Given request
"""
<user>
  <name>John</name>
  <age>30</age>
</user>
"""

# Form fields
Given form field username = 'john'
And form field password = 'secret'
```

### Form Data
```gherkin
# URL encoded form
Given form field username = 'john'
And form field password = 'pass123'
When method POST

# Multiple form fields
Given form fields { username: 'john', password: 'pass', remember: true }
```

### Multipart Files
```gherkin
# File upload
Given multipart file file = { read: 'classpath:test.pdf', filename: 'test.pdf', contentType: 'application/pdf' }
And multipart field name = 'John'
When method POST
```

## Response Validation

### Status Validation
```gherkin
Then status 200
Then status 201
Then status 404

# Status in range
Then assert responseStatus >= 200 && responseStatus < 300
```

### Response Matching
```gherkin
# Exact match
Then match response == { id: 1, name: 'John' }

# Partial match
Then match response contains { name: 'John' }

# Array matching
Then match response[0] == { id: 1, name: 'John' }

# Not null
Then match response.id != null
```

### JSON Path
```gherkin
# Extract value
* def userId = response.data.id
* def name = response.users[0].name

# JSON Path expressions
* def firstUser = $response.users[0]
* def allNames = $response.users[*].name
```

### Schema Validation
```gherkin
# Schema definition
* def userSchema =
"""
{
  id: '#number',
  name: '#string',
  email: '#string',
  active: '#boolean',
  roles: '#array',
  profile: '#object'
}
"""

Then match response == userSchema

# Optional fields
* def schema = { id: '#number', name: '#string', age: '##number' }
```

## Variables and Data

### Defining Variables
```gherkin
# Simple variables
* def userId = 123
* def baseUrl = 'https://api.example.com'

# Complex variables
* def user = { name: 'John', age: 30 }
* def users = [{ id: 1 }, { id: 2 }]

# Dynamic variables
* def timestamp = new Date().getTime()
* def uuid = java.util.UUID.randomUUID() + ''
```

### Reading Files
```gherkin
# JSON file
* def userData = read('classpath:data/user.json')

# Text file
* def template = read('classpath:templates/email.txt')

# CSV file
* def csvData = read('classpath:data/users.csv')

# YAML file
* def config = read('classpath:config.yml')
```

### Data Tables
```gherkin
# Table data
* table users
  | name   | age | role    |
  | 'John' | 30  | 'admin' |
  | 'Jane' | 25  | 'user'  |

# Using table data
* def firstUser = users[0]
```

### Embedded Expressions
```gherkin
# In JSON
* def user = { name: '#(name)', age: '#(age)', timestamp: '#(new Date())' }

# In strings
* def message = 'Hello #(userName), your ID is #(userId)'

# Conditional expressions
* def status = active ? 'enabled' : 'disabled'
```

## Assertions

### Match Types
```gherkin
# String matching
Then match response.name == 'John'
Then match response.name != 'Jane'

# Number matching
Then match response.age == 30
Then match response.price == 19.99

# Boolean matching
Then match response.active == true
Then match response.deleted == false

# Type matching
Then match response.id == '#number'
Then match response.name == '#string'
Then match response.active == '#boolean'
Then match response.data == '#array'
Then match response.user == '#object'
```

### Fuzzy Matching
```gherkin
# Present (not null)
Then match response.id == '#present'

# Not present (null or undefined)
Then match response.deleted == '#notpresent'

# Ignore
Then match response == { id: '#ignore', name: 'John' }

# Regex
Then match response.email == '#regex .+@.+\\..+'

# UUID
Then match response.id == '#uuid'

# Date
Then match response.created == '#date'
```

### Contains Assertions
```gherkin
# Object contains
Then match response contains { name: 'John' }

# Array contains
Then match response contains [{ id: 1 }]

# Deep contains
Then match response contains deep { user: { name: 'John' } }

# Only contains
Then match response contains only { id: 1, name: 'John' }

# Any of
Then match response.status == '#? _ == "active" || _ == "pending"'
```

## Reusable Features

### Calling Features
```gherkin
# Call another feature
* def result = call read('classpath:features/auth.feature')
* def token = result.response.token

# Call with parameters
* def result = call read('classpath:features/createUser.feature') { name: 'John', age: 30 }

# Call once
* def config = callonce read('classpath:features/config.feature')
```

### Background
```gherkin
Feature: Reusable auth

Background:
  * url baseUrl
  * def auth = call read('classpath:features/auth.feature')
  * header Authorization = 'Bearer ' + auth.response.token

Scenario: Use authenticated request
  Given path 'profile'
  When method GET
  Then status 200
```

### Tags
```gherkin
@smoke
Feature: Smoke tests

@regression @critical
Scenario: Critical test
  Given url baseUrl
  When method GET
  Then status 200

@ignore
Scenario: Skip this test
  # This scenario will be skipped
```

## Data-Driven Testing

### Scenario Outline
```gherkin
Scenario Outline: Test multiple users
  Given url baseUrl
  And path 'users', <userId>
  When method GET
  Then status <status>
  And match response.name == '<name>'

  Examples:
    | userId | status | name   |
    | 1      | 200    | John   |
    | 2      | 200    | Jane   |
    | 999    | 404    | null   |
```

### Examples Table
```gherkin
Scenario Outline: Dynamic data
  * def user = { id: <id>, name: '<name>', active: <active> }
  Given request user
  When method POST
  Then status 201

  Examples:
    | id | name   | active |
    | 1  | John   | true   |
    | 2  | Jane   | false  |
```

### CSV Files
```gherkin
Scenario Outline: Read from CSV
  Given url baseUrl
  And request row
  When method POST
  Then status 201

  Examples:
    | read('classpath:data/users.csv') |
```

### JSON Arrays
```gherkin
Scenario Outline: Read from JSON array
  Given url baseUrl
  And request __row
  When method POST
  Then status 201

  Examples:
    | read('classpath:data/users.json') |
```

## JavaScript Functions

### Inline Functions
```gherkin
# Define function
* def generateEmail = function(name) { return name.toLowerCase() + '@example.com' }
* def email = generateEmail('John')

# Arrow function
* def add = (a, b) => a + b
* def sum = add(5, 3)

# Complex function
* def validateUser =
"""
function(user) {
  if (!user.name || !user.email) {
    return false;
  }
  return user.age >= 18;
}
"""
```

### External JS Files
```javascript
// utils.js
function generateRandomId() {
  return Math.floor(Math.random() * 10000);
}

function formatDate(date) {
  return new Date(date).toISOString();
}
```

```gherkin
# Using external JS
* def utils = read('classpath:utils.js')
* def id = utils.generateRandomId()
* def date = utils.formatDate('2024-01-01')
```

### Java Interop
```gherkin
# Call Java class
* def DbUtils = Java.type('com.example.DbUtils')
* def result = DbUtils.queryDatabase('SELECT * FROM users')

# Java static method
* def uuid = java.util.UUID.randomUUID() + ''

# Java instance
* def SimpleDateFormat = Java.type('java.text.SimpleDateFormat')
* def formatter = new SimpleDateFormat('yyyy-MM-dd')
* def date = formatter.format(new java.util.Date())
```

## Authentication

### Basic Auth
```gherkin
# Basic authentication
Given url baseUrl
And configure headers = { Authorization: '#("Basic " + Base64.encoder.encodeToString((username + ":" + password).bytes))' }

# Using configure
* configure headers = { Authorization: 'Basic dXNlcjpwYXNz' }
```

### OAuth 2.0
```gherkin
Feature: OAuth authentication

Background:
  * def getToken =
  """
  function() {
    var auth = karate.call('classpath:features/oauth-token.feature');
    return auth.response.access_token;
  }
  """
  * def token = getToken()
  * header Authorization = 'Bearer ' + token
```

### Bearer Tokens
```gherkin
# Simple bearer token
Given header Authorization = 'Bearer ' + token

# From response
Given url authUrl
And request { username: 'user', password: 'pass' }
When method POST
Then status 200
* def token = response.token

Given url apiUrl
And header Authorization = 'Bearer ' + token
```

### Custom Auth
```gherkin
# API Key
Given header X-API-Key = apiKey

# HMAC signature
* def signature = generateHmacSignature(request, secret)
Given header X-Signature = signature

# Multiple auth headers
Given headers { 'X-API-Key': apiKey, 'X-Client-Id': clientId }
```

## Configuration

### karate-config.js
```javascript
function fn() {
  var config = {
    baseUrl: 'https://api.example.com',
    apiKey: 'your-api-key',
    connectTimeout: 5000,
    readTimeout: 10000
  };

  var env = karate.env || 'dev';

  if (env == 'dev') {
    config.baseUrl = 'http://localhost:8080';
  } else if (env == 'qa') {
    config.baseUrl = 'https://qa-api.example.com';
  } else if (env == 'prod') {
    config.baseUrl = 'https://api.example.com';
  }

  karate.configure('connectTimeout', config.connectTimeout);
  karate.configure('readTimeout', config.readTimeout);

  return config;
}
```

### Environment Config
```gherkin
# Access config variables
* def baseUrl = karate.properties['base.url'] || 'http://localhost:8080'

# Set system property
* karate.properties['my.property'] = 'value'

# Environment-specific config
* def env = karate.env
* def config = env == 'prod' ? prodConfig : devConfig
```

### Timeouts
```gherkin
# Configure timeouts
* configure connectTimeout = 10000
* configure readTimeout = 30000

# Retry configuration
* configure retry = { count: 3, interval: 5000 }

# Conditional retry
* configure retry = { count: 3, interval: 1000, conditions: ['status != 200'] }
```

### SSL Configuration
```gherkin
# Disable SSL verification (dev only)
* configure ssl = true

# Custom SSL config
* configure ssl = { keyStore: 'classpath:keystore.p12', keyStorePassword: 'secret' }

# Trust all certificates (not for production)
* configure ssl = { trustAll: true }
```

## Parallel Execution

### Runner Configuration
```java
// TestRunner.java
@Test
void testParallel() {
    Results results = Runner.path("classpath:features")
        .outputCucumberJson(true)
        .parallel(5);
    assertEquals(0, results.getFailCount(), results.getErrorMessages());
}
```

### Thread Configuration
```java
// Parallel execution with custom thread pool
Runner.Builder()
    .path("classpath:features")
    .tags("~@ignore")
    .parallel(10)
    .threadCount(5);
```

## Reporting

### HTML Reports
```gherkin
# Generate HTML report
* def report = karate.report()

# Custom report location
* configure report = { showLog: true, showAllSteps: true }
```

### Cucumber Reports
```java
// Generate Cucumber JSON
Results results = Runner.path("classpath:features")
    .outputCucumberJson(true)
    .parallel(5);

// Generate report
generateReport(results.getReportDir());
```

### Custom Reports
```gherkin
# Log custom metrics
* def startTime = new Date().getTime()
# ... test execution ...
* def endTime = new Date().getTime()
* def duration = endTime - startTime
* karate.log('Test duration:', duration, 'ms')

# Write to file
* def report = { test: 'user-api', duration: duration, status: 'passed' }
* karate.write(report, 'target/custom-report.json')
```

## Mocking and Test Doubles

### Mock Server
```gherkin
Feature: Mock server

Background:
  * def mockServer = karate.start('mock-server.feature')

Scenario: Start mock server
  Given url mockServer
  And path 'users'
  When method GET
  Then status 200
```

### Conditional Responses
```gherkin
# mock-server.feature
Scenario: pathMatches('/users/{id}')
  * def id = pathParams.id
  * def response = id == '999' ? { error: 'Not found' } : { id: '#(id)', name: 'User ' + id }
  * def status = id == '999' ? 404 : 200

Scenario: pathMatches('/users') && methodIs('post')
  * def response = { id: '#(UUID.randomUUID())', name: request.name }
  * def status = 201
```

## Database Testing

### JDBC Configuration
```gherkin
# Configure database
* def DbUtils = Java.type('com.example.DbUtils')
* def db = new DbUtils('jdbc:postgresql://localhost:5432/test', 'user', 'pass')

# Query execution
* def users = db.query("SELECT * FROM users WHERE active = true")
* match users[0].name == 'John'
```

### SQL Queries
```gherkin
# Read SQL from file
* def query = read('classpath:sql/get-users.sql')
* def result = db.query(query)

# Insert data
* def insertQuery = "INSERT INTO users (name, email) VALUES ('" + name + "', '" + email + "')"
* db.execute(insertQuery)

# Update with parameters
* def updateQuery = "UPDATE users SET status = ? WHERE id = ?"
* db.executeUpdate(updateQuery, ['active', userId])
```

## Performance Testing

### Gatling Integration
```scala
// KarateGatlingTest.scala
class KarateGatlingTest extends Simulation {

  val protocol = karateProtocol(
    "/users/{id}" -> Nil,
    "/users" -> pauseFor("get" -> 15, "post" -> 25)
  )

  val scenario = karateScenario("classpath:features/performance.feature")

  setUp(
    scenario.inject(rampUsers(100).during(10 seconds))
  ).protocols(protocol)
}
```

### Load Testing
```gherkin
# performance.feature
Feature: Load test

Scenario: Load test user API
  Given url baseUrl
  And path 'users', __gatling.userId
  When method GET
  Then status 200
```

## Debugging

### Print Statements
```gherkin
# Print to console
* print 'Debug message'
* print 'Response:', response
* print 'Status:', responseStatus

# Pretty print JSON
* print karate.pretty(response)

# Print with condition
* if (responseStatus != 200) karate.log('Error:', response)
```

### Karate UI
```gherkin
# Enable UI debugger
* configure driver = { type: 'chrome' }
* driver 'https://api.example.com'

# Set breakpoint
* breakpoint()
```

### IDE Support
```gherkin
# VS Code / IntelliJ debugging
* def debug = true
* if (debug) print 'Breakpoint here'

# Conditional execution
* def skipTest = karate.properties['skip.test'] == 'true'
* if (skipTest) karate.abort()
```

## Best Practices

### Organization
```gherkin
# Organize features by domain
features/
├── auth/
│   ├── login.feature
│   └── logout.feature
├── users/
│   ├── create.feature
│   └── update.feature
└── common/
    └── utils.feature

# Reusable components
helpers/
├── auth-helper.feature
└── data-generator.js
```

### Naming Conventions
```gherkin
# Feature names
Feature: User Management API Tests

# Scenario names
Scenario: Should create new user with valid data
Scenario: Should return 400 for invalid email format

# Variable names
* def userId = 123  # camelCase for variables
* def BASE_URL = 'https://api.example.com'  # UPPER_CASE for constants
```

### Error Handling
```gherkin
# Try-catch blocks
* def result =
"""
function() {
  try {
    return karate.call('classpath:features/risky.feature');
  } catch (e) {
    karate.log('Error:', e.message);
    return { error: e.message };
  }
}
"""

# Soft assertions
* def errors = []
* if (response.name != 'John') errors.push('Name mismatch')
* if (response.age != 30) errors.push('Age mismatch')
* match errors == []

# Conditional retry
* retry until responseStatus == 200
"""
Given url baseUrl
When method GET
"""
```

## Tips and Tricks

### Dynamic Waiting
```gherkin
# Wait for condition
* waitFor('response.status == "complete"')
* waitForText('.status', 'Complete')

# Polling
* retry until response.status == 'ready'
```

### Response Transformation
```gherkin
# Transform response
* def users = response.map(x => ({ id: x.id, name: x.name.toUpperCase() }))

# Filter data
* def activeUsers = response.filter(x => x.active == true)

# Sort array
* def sorted = response.sort((a, b) => a.name.localeCompare(b.name))
```

### Advanced Matching
```gherkin
# Each validation
* match each response == { id: '#number', name: '#string' }

# Conditional schema
* def schema = response.type == 'user' ? userSchema : adminSchema
* match response == schema

# Complex conditions
* match response == '#? _.age > 18 && _.status == "active"'
```

### Performance Optimization
```gherkin
# Connection pooling
* configure connectionPool = { max: 10, keepAlive: 30000 }

# Response caching
* configure cache = true

# Disable pretty printing in CI
* configure prettyPrint = karate.env != 'ci'
```