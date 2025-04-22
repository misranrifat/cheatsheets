# Rest Assured API Testing Cheatsheet

## Table of Contents
- [Setup](#setup)
- [Basic Requests](#basic-requests)
- [Headers and Parameters](#headers-and-parameters)
- [Request Body](#request-body)
- [Authentication](#authentication)
- [Response Validation](#response-validation)
- [JSON Path](#json-path)
- [XML Path](#xml-path)
- [Schema Validation](#schema-validation)
- [Filters and Logging](#filters-and-logging)
- [Specifications](#specifications)
- [File Upload/Download](#file-uploaddownload)
- [Serialization/Deserialization](#serializationdeserialization)
- [Advanced Features](#advanced-features)

## Setup

### Maven Dependencies
```xml
<dependencies>
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>rest-assured</artifactId>
        <version>5.3.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>json-path</artifactId>
        <version>5.3.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>xml-path</artifactId>
        <version>5.3.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>json-schema-validator</artifactId>
        <version>5.3.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-api</artifactId>
        <version>5.9.3</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### Basic Imports
```java
import static io.restassured.RestAssured.*;
import static io.restassured.matcher.RestAssuredMatchers.*;
import static org.hamcrest.Matchers.*;
import io.restassured.response.Response;
import io.restassured.http.ContentType;
```

### Setup Base Configuration
```java
@BeforeAll
public static void setup() {
    RestAssured.baseURI = "https://api.example.com";
    RestAssured.basePath = "/v1";
    RestAssured.port = 443;
    
    // Default configurations
    RestAssured.useRelaxedHTTPSValidation(); // Skip HTTPS validation
    RestAssured.enableLoggingOfRequestAndResponseIfValidationFails(); // Log details on failure
}
```

## Basic Requests

### HTTP Methods
```java
// GET request
Response response = get("/users");
get("/users").then().statusCode(200);

// POST request
given().body(payload).post("/users");

// PUT request
given().body(payload).put("/users/{id}", userId);

// PATCH request
given().body(payload).patch("/users/{id}", userId);

// DELETE request
delete("/users/{id}", userId);

// HEAD request
head("/users");

// OPTIONS request
options("/users");
```

### Basic Request-Response Flow
```java
Response response = given()
                        .param("name", "John")
                    .when()
                        .get("/users")
                    .then()
                        .statusCode(200)
                        .extract().response();
```

## Headers and Parameters

### Headers
```java
// Adding headers
given()
    .header("Content-Type", "application/json")
    .header("Authorization", "Bearer " + token)
    .headers("Custom-Header", "value", "Another-Header", "value")
    .when()
    .get("/endpoint");

// Content type shortcuts
given()
    .contentType(ContentType.JSON)
    .accept(ContentType.JSON);
```

### Query Parameters
```java
given()
    .param("name", "John")
    .param("age", 30)
    .queryParam("active", true)
    .when()
    .get("/users");
```

### Path Parameters
```java
given()
    .pathParam("userId", 123)
    .when()
    .get("/users/{userId}");
    
// Multiple path parameters
given()
    .pathParams("userId", 123, "groupId", 456)
    .when()
    .get("/users/{userId}/groups/{groupId}");
```

### Form Parameters
```java
given()
    .formParam("username", "john")
    .formParam("password", "password123")
    .when()
    .post("/login");
```

### Cookies
```java
given()
    .cookie("session_id", "abc123")
    .cookies("name", "value", "name2", "value2")
    .when()
    .get("/secure");
```

## Request Body

### String Body
```java
String jsonBody = "{\"name\":\"John\",\"age\":30}";
given()
    .body(jsonBody)
    .when()
    .post("/users");
```

### Object Body (Auto-Serialized)
```java
User user = new User("John", 30);
given()
    .body(user)
    .when()
    .post("/users");
```

### Map Body
```java
Map<String, Object> jsonAsMap = new HashMap<>();
jsonAsMap.put("name", "John");
jsonAsMap.put("age", 30);

given()
    .body(jsonAsMap)
    .when()
    .post("/users");
```

## Authentication

### Basic Authentication
```java
given()
    .auth().basic("username", "password")
    .when()
    .get("/secure");
```

### Digest Authentication
```java
given()
    .auth().digest("username", "password")
    .when()
    .get("/secure");
```

### Form Authentication
```java
given()
    .auth().form("username", "password")
    .when()
    .get("/secure");
```

### OAuth 1.0
```java
given()
    .auth().oauth(consumerKey, consumerSecret, accessToken, secretToken)
    .when()
    .get("/secure");
```

### OAuth 2.0
```java
given()
    .auth().oauth2(accessToken)
    .when()
    .get("/secure");
```

### JWT Authentication
```java
given()
    .header("Authorization", "Bearer " + jwtToken)
    .when()
    .get("/secure");
```

### API Key
```java
given()
    .queryParam("api_key", apiKey)
    // OR
    .header("X-API-Key", apiKey)
    .when()
    .get("/secure");
```

## Response Validation

### Status Code
```java
given()
    .when()
    .get("/users")
    .then()
    .statusCode(200);

// Status code ranges
given()
    .when()
    .get("/users")
    .then()
    .statusCode(greaterThanOrEqualTo(200))
    .statusCode(lessThan(300));
```

### Headers
```java
given()
    .when()
    .get("/users")
    .then()
    .header("Content-Type", "application/json")
    .header("Content-Length", Integer::parseInt, greaterThan(100))
    .headers("Custom-Header", "value", "Cache-Control", containsString("max-age="));
```

### Cookie Validation
```java
given()
    .when()
    .get("/users")
    .then()
    .cookie("session_id", notNullValue())
    .cookie("isAuthenticated", "true");
```

### Body Validation
```java
given()
    .when()
    .get("/users/1")
    .then()
    .body("name", equalTo("John"))
    .body("age", greaterThan(18))
    .body("address.city", equalTo("New York"))
    .body("skills", hasItems("Java", "REST"))
    .body("skills.size()", equalTo(3));
```

### Response Time
```java
given()
    .when()
    .get("/users")
    .then()
    .time(lessThan(2000L)); // Less than 2 seconds
```

### Response Type
```java
given()
    .when()
    .get("/users")
    .then()
    .contentType(ContentType.JSON);
```

## JSON Path

### Basic JSON Path Expressions
```java
// Extract values from response
Response response = get("/users/1");
String name = response.jsonPath().getString("name");
int age = response.jsonPath().getInt("age");
List<String> skills = response.jsonPath().getList("skills");
Map<String, Object> address = response.jsonPath().getMap("address");

// Using JSON path in assertions
given()
    .when()
    .get("/users")
    .then()
    .body("users.find{it.name=='John'}.age", equalTo(30))
    .body("users.findAll{it.age > 18}.name", hasItems("John", "Jane"))
    .body("users.collect{it.age}.sum()", greaterThan(100))
    .body("users.max{it.age}.name", equalTo("Bob"));
```

### Advanced JSON Path Examples
```java
// Arrays and collections
given()
    .when()
    .get("/users")
    .then()
    .body("users.size()", equalTo(3))
    .body("users[0].name", equalTo("John"))
    .body("users.findAll{it.active == true}.size()", equalTo(2))
    .body("users*.name", hasItems("John", "Jane", "Bob"));

// Nested objects and arrays
given()
    .when()
    .get("/users")
    .then()
    .body("users[0].address.city", equalTo("New York"))
    .body("users[0].skills[1]", equalTo("REST"))
    .body("users.findAll{it.address.country=='USA'}.size()", equalTo(2));

// Extracting multiple values
Map<String, Object> jsonPathMap = get("/users/1").path("");
List<Map<String, Object>> allUsers = get("/users").path("users");
```

## XML Path

### Basic XML Path
```java
// Imports
import static io.restassured.path.xml.XmlPath.*;

// Extract values from XML response
Response response = get("/users/1");
String name = response.xmlPath().getString("user.name");
int age = response.xmlPath().getInt("user.age");

// Using XML path in assertions
given()
    .when()
    .get("/users")
    .then()
    .body(hasXPath("/users/user[1]/name", containsString("John")))
    .body(hasXPath("count(/users/user)", equalTo("3")))
    .body(hasXPath("/users/user[@id='1']"));
```

### Advanced XML Path
```java
// XML attributes
given()
    .when()
    .get("/users")
    .then()
    .body(hasXPath("/users/user[@active='true']"))
    .body(matchesXPath("/users/user[@id='1' and @active='true']"));

// XML namespaces
given()
    .when()
    .get("/users")
    .then()
    .body(hasXPath("/ns:users/ns:user[1]/ns:name", 
          namespaceContext))
    .body(hasXPath("//ns:name[text()='John']", 
          withNamespaceContext(namespaceMap)));
```

## Schema Validation

### JSON Schema Validation
```java
// Add dependency
// io.rest-assured:json-schema-validator

import static io.restassured.module.jsv.JsonSchemaValidator.*;

// Basic schema validation
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesJsonSchema(new File("user-schema.json")));

// Schema from classpath
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesJsonSchemaInClasspath("schemas/user-schema.json"));

// Schema as string
String schema = "{\"type\":\"object\",\"properties\":{\"name\":{\"type\":\"string\"}}}";
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesJsonSchema(schema));
```

### XML Schema Validation
```java
// Add dependency for XML validation
// io.rest-assured:xml-path
// io.rest-assured:json-schema-validator

import static io.restassured.matcher.RestAssuredMatchers.*;

// XSD validation
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesXsd(new File("user.xsd")));

// XSD from classpath
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesXsdInClasspath("schemas/user.xsd"));

// DTD validation
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesDtd(new File("user.dtd")));

// DTD from classpath
given()
    .when()
    .get("/users/1")
    .then()
    .body(matchesDtdInClasspath("schemas/user.dtd"));
```

## Filters and Logging

### Basic Logging
```java
given()
    .log().all()  // Log all request details
    .when()
    .get("/users")
    .then()
    .log().all(); // Log all response details

// Specific logging
given()
    .log().headers()   // Log only request headers
    .log().parameters() // Log only request parameters
    .log().body()      // Log only request body
    .when()
    .get("/users")
    .then()
    .log().status()    // Log response status
    .log().headers()   // Log response headers
    .log().body();     // Log response body

// Conditional logging
given()
    .log().ifValidationFails() // Log only if validation fails
    .when()
    .get("/users")
    .then()
    .log().ifValidationFails() // Log only if validation fails
    .statusCode(200);
```

### Request/Response Filters
```java
// Create a custom filter
Filter customFilter = (requestSpec, responseSpec, ctx) -> {
    // Before request
    System.out.println("Request about to be sent: " + requestSpec.getUserDefinedPath());
    
    // Send the request and get response
    Response response = ctx.next(requestSpec, responseSpec);
    
    // After response
    System.out.println("Response received with status: " + response.getStatusCode());
    
    return response;
};

// Apply filter
given()
    .filter(customFilter)
    .when()
    .get("/users");

// Built-in filters
given()
    .filter(new RequestLoggingFilter()) // Log all requests
    .filter(new ResponseLoggingFilter()) // Log all responses
    .when()
    .get("/users");
```

## Specifications

### Request Specification
```java
// Create a reusable request specification
RequestSpecification requestSpec = new RequestSpecBuilder()
    .setBaseUri("https://api.example.com")
    .setBasePath("/v1")
    .setPort(443)
    .addHeader("Content-Type", "application/json")
    .addHeader("Accept", "application/json")
    .addQueryParam("apiKey", "abc123")
    .setBody(payload)
    .build();

// Use the specification
given()
    .spec(requestSpec)
    .when()
    .get("/users");

// Combine specification with additional params
given()
    .spec(requestSpec)
    .param("extraParam", "value")
    .when()
    .get("/users");
```

### Response Specification
```java
// Create a reusable response specification
ResponseSpecification responseSpec = new ResponseSpecBuilder()
    .expectStatusCode(200)
    .expectContentType(ContentType.JSON)
    .expectHeader("Server", containsString("Apache"))
    .expectBody("status", equalTo("success"))
    .expectResponseTime(lessThan(2000L))
    .build();

// Use the specification
given()
    .when()
    .get("/users")
    .then()
    .spec(responseSpec);

// Combine specification with additional validations
given()
    .when()
    .get("/users")
    .then()
    .spec(responseSpec)
    .body("users.size()", greaterThan(0));
```

### Default Specifications
```java
// Set default specifications for all requests
RestAssured.requestSpecification = new RequestSpecBuilder()
    .setContentType(ContentType.JSON)
    .setBaseUri("https://api.example.com")
    .build();

RestAssured.responseSpecification = new ResponseSpecBuilder()
    .expectStatusCode(anyOf(is(200), is(201), is(204)))
    .build();

// Now all requests will use these defaults unless overridden
get("/users"); // Uses default requestSpecification
```

## File Upload/Download

### File Upload
```java
// Single file upload
given()
    .multiPart("file", new File("document.pdf"))
    .when()
    .post("/upload");

// Multiple parameters with file
given()
    .multiPart("file", new File("document.pdf"))
    .multiPart("name", "document")
    .multiPart("description", "Important document")
    .when()
    .post("/upload");

// Advanced file upload
given()
    .multiPart(new MultiPartSpecBuilder(new File("document.pdf"))
        .fileName("renamed.pdf")
        .controlName("file")
        .mimeType("application/pdf")
        .build())
    .when()
    .post("/upload");
```

### File Download
```java
// Download and save a file
byte[] downloadedFile = given()
    .when()
    .get("/download/document.pdf")
    .then()
    .statusCode(200)
    .extract().asByteArray();

// Write to disk
try (FileOutputStream fos = new FileOutputStream("downloaded.pdf")) {
    fos.write(downloadedFile);
}

// Validate file contents
given()
    .when()
    .get("/download/document.pdf")
    .then()
    .statusCode(200)
    .body(is(new File("expected.pdf")));
```

## Serialization/Deserialization

### Response Deserialization
```java
// Deserialize into a class
User user = get("/users/1").as(User.class);

// Deserialize into generic types
List<User> users = get("/users").as(new TypeRef<List<User>>() {});
Map<String, Object> data = get("/data").as(new TypeRef<Map<String, Object>>() {});

// Configure object mapper
RestAssured.config = RestAssuredConfig.config()
    .objectMapperConfig(ObjectMapperConfig.objectMapperConfig()
        .jackson2ObjectMapperFactory((cls, charset) -> {
            ObjectMapper om = new ObjectMapper();
            om.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            return om;
        }));
```

### Request Serialization
```java
// Automatic serialization
User user = new User("John", 30);
given()
    .body(user)
    .when()
    .post("/users");

// Custom serialization
ObjectMapper objectMapper = new ObjectMapper();
String json = objectMapper.writeValueAsString(user);
given()
    .body(json)
    .when()
    .post("/users");
```

## Advanced Features

### Session Management
```java
// Session filter to manage cookies between requests
SessionFilter sessionFilter = new SessionFilter();

// Login to establish session
given()
    .filter(sessionFilter)
    .formParam("username", "john")
    .formParam("password", "password123")
    .when()
    .post("/login");

// Subsequent request using the same session
given()
    .filter(sessionFilter) // Reuse the same session filter
    .when()
    .get("/profile")
    .then()
    .statusCode(200);
```

### Response Extraction
```java
// Extract full response
Response response = given()
    .when()
    .get("/users/1")
    .then()
    .extract().response();

// Extract specific parts
String name = given()
    .when()
    .get("/users/1")
    .then()
    .extract().path("name");

String header = given()
    .when()
    .get("/users/1")
    .then()
    .extract().header("Content-Type");

// Extract response as string
String responseAsString = given()
    .when()
    .get("/users/1")
    .then()
    .extract().asString();

// Extract response for further processing
JsonPath jsonPath = given()
    .when()
    .get("/users/1")
    .then()
    .extract().jsonPath();
```

### Proxying
```java
// Set proxy for requests
given()
    .proxy("localhost", 8888)
    .when()
    .get("/users");

// Proxy with authentication
given()
    .proxy(ProxySpecification
        .host("localhost")
        .withPort(8888)
        .withAuth("username", "password"))
    .when()
    .get("/users");
```

### SSL Configuration
```java
// Relaxed HTTPS validation (trust all)
given()
    .relaxedHTTPSValidation()
    .when()
    .get("https://api.example.com/users");

// Specific keystore
given()
    .keyStore("/path/to/keystore.jks", "password")
    .when()
    .get("https://api.example.com/users");

// Trust store configuration
RestAssured.config = RestAssuredConfig.config()
    .sslConfig(SSLConfig.sslConfig()
        .trustStore("/path/to/truststore.jks", "password")
        .keyStore("/path/to/keystore.jks", "password"));
```

### Asynchronous Requests
```java
// Make an async request
CompletableFuture<Response> future = CompletableFuture.supplyAsync(() -> {
    return given()
        .when()
        .get("/users");
});

// Process response when ready
future.thenAccept(response -> {
    Assert.assertEquals(200, response.getStatusCode());
});

// Wait for response
Response response = future.get(5, TimeUnit.SECONDS);
```

### Parameterized Tests
```java
// JUnit 5 parameterized tests
@ParameterizedTest
@ValueSource(ints = {1, 2, 3})
void testUserById(int userId) {
    given()
        .pathParam("id", userId)
        .when()
        .get("/users/{id}")
        .then()
        .statusCode(200)
        .body("id", equalTo(userId));
}

// CSV source
@ParameterizedTest
@CsvSource({
    "1, John, active",
    "2, Jane, inactive",
    "3, Bob, active"
})
void testUserDetails(int id, String name, String status) {
    given()
        .pathParam("id", id)
        .when()
        .get("/users/{id}")
        .then()
        .statusCode(200)
        .body("name", equalTo(name))
        .body("status", equalTo(status));
}
```

### API Client Pattern
```java
// Create a clean API client class
public class UsersApi {
    private final RequestSpecification requestSpec;
    
    public UsersApi() {
        this.requestSpec = new RequestSpecBuilder()
            .setBaseUri("https://api.example.com")
            .setBasePath("/v1/users")
            .setContentType(ContentType.JSON)
            .build();
    }
    
    public Response getUserById(int userId) {
        return given()
            .spec(requestSpec)
            .pathParam("id", userId)
            .when()
            .get("/{id}");
    }
    
    public Response createUser(User user) {
        return given()
            .spec(requestSpec)
            .body(user)
            .when()
            .post();
    }
    
    public Response updateUser(int userId, User user) {
        return given()
            .spec(requestSpec)
            .pathParam("id", userId)
            .body(user)
            .when()
            .put("/{id}");
    }
    
    public Response deleteUser(int userId) {
        return given()
            .spec(requestSpec)
            .pathParam("id", userId)
            .when()
            .delete("/{id}");
    }
}

// Usage in tests
@Test
public void testGetUser() {
    UsersApi api = new UsersApi();
    Response response = api.getUserById(1);
    
    response.then()
        .statusCode(200)
        .body("name", equalTo("John"));
}
```
