# Spring Boot Cheatsheet

## Table of Contents
1. [Project Setup](#project-setup)
2. [Application Configuration](#application-configuration)
3. [Spring Boot Starters](#spring-boot-starters)
4. [Spring Boot Annotations](#spring-boot-annotations)
5. [REST API Development](#rest-api-development)
6. [Data Access](#data-access)
7. [Testing](#testing)
8. [Security](#security)
9. [Actuator](#actuator)
10. [Deployment](#deployment)
11. [Common Configurations](#common-configurations)
12. [Best Practices](#best-practices)

## Project Setup

### Using Spring Initializr
- Web: https://start.spring.io
- CLI: `spring init --dependencies=web,data-jpa my-project`

### Maven Dependencies
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.2.0</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

### Gradle Dependencies
```groovy
plugins {
    id 'org.springframework.boot' version '3.2.0'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'java'
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
}
```

### Main Application Class
```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

## Application Configuration

### application.properties

```properties
# Server Configuration
server.port=8080
server.servlet.context-path=/api

# Logging Configuration
logging.level.root=INFO
logging.level.org.springframework.web=DEBUG
logging.level.org.hibernate=ERROR

# Database Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.datasource.username=postgres
spring.datasource.password=password
spring.datasource.driver-class-name=org.postgresql.Driver

# JPA / Hibernate
spring.jpa.show-sql=true
spring.jpa.hibernate.ddl-auto=update
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect

# Jackson Properties
spring.jackson.serialization.write-dates-as-timestamps=false
spring.jackson.date-format=yyyy-MM-dd HH:mm:ss
```

### application.yml

```yaml
server:
  port: 8080
  servlet:
    context-path: /api

logging:
  level:
    root: INFO
    org:
      springframework:
        web: DEBUG
      hibernate: ERROR

spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/mydb
    username: postgres
    password: password
    driver-class-name: org.postgresql.Driver
  jpa:
    show-sql: true
    hibernate:
      ddl-auto: update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
  jackson:
    serialization:
      write-dates-as-timestamps: false
    date-format: yyyy-MM-dd HH:mm:ss
```

### Profile-Specific Configuration
- `application-dev.properties`
- `application-prod.properties`
- `application-test.properties`

Activating profiles:
```
java -jar myapp.jar --spring.profiles.active=dev
```

Or in application.properties:
```properties
spring.profiles.active=dev
```

## Spring Boot Starters

| Starter | Description |
|---------|-------------|
| spring-boot-starter | Core starter, includes auto-configuration, logging, and YAML |
| spring-boot-starter-web | Web applications including RESTful, Spring MVC, Tomcat |
| spring-boot-starter-data-jpa | JPA with Hibernate |
| spring-boot-starter-security | Spring Security |
| spring-boot-starter-test | Unit testing including JUnit, Hamcrest, and Mockito |
| spring-boot-starter-actuator | Production-ready features for monitoring and management |
| spring-boot-starter-thymeleaf | Thymeleaf template engine for web applications |
| spring-boot-starter-data-redis | Redis support |
| spring-boot-starter-aop | Aspect-oriented programming |
| spring-boot-starter-cache | Caching support |
| spring-boot-starter-validation | Bean Validation with Hibernate Validator |
| spring-boot-starter-webflux | Reactive web applications |
| spring-boot-starter-oauth2-client | OAuth2 client features |
| spring-boot-starter-batch | Spring Batch |
| spring-boot-starter-mail | Email sending support |

## Spring Boot Annotations

### Core Annotations
- `@SpringBootApplication`: Combines `@Configuration`, `@EnableAutoConfiguration`, and `@ComponentScan`
- `@EnableAutoConfiguration`: Enables Spring Boot's auto-configuration mechanism
- `@ComponentScan`: Enables component scanning
- `@Configuration`: Indicates a class as a source of bean definitions

### Component Annotations
- `@Component`: Marks a class as a Spring component
- `@Service`: Indicates a business service class
- `@Repository`: Indicates a data access class
- `@Controller`: Marks a class as a web controller
- `@RestController`: Combines `@Controller` and `@ResponseBody`

### REST Annotations
- `@RequestMapping`: Maps HTTP requests to handler methods
- `@GetMapping`: Shortcut for `@RequestMapping(method = RequestMethod.GET)`
- `@PostMapping`: Shortcut for `@RequestMapping(method = RequestMethod.POST)`
- `@PutMapping`: Shortcut for `@RequestMapping(method = RequestMethod.PUT)`
- `@DeleteMapping`: Shortcut for `@RequestMapping(method = RequestMethod.DELETE)`
- `@PatchMapping`: Shortcut for `@RequestMapping(method = RequestMethod.PATCH)`
- `@RequestBody`: Binds HTTP request body to a method parameter
- `@RequestParam`: Binds HTTP request parameters to method parameters
- `@PathVariable`: Binds URI template variables to method parameters
- `@ResponseBody`: Indicates that a method return value should be bound to the web response body
- `@ResponseStatus`: Marks a method or exception class with a status code

### Data Annotations
- `@Entity`: Marks a class as a JPA entity
- `@Table`: Specifies the primary table for the annotated entity
- `@Id`: Marks a field as the primary key
- `@GeneratedValue`: Specifies generation strategy for primary keys
- `@Column`: Specifies column mapping for a field
- `@Transactional`: Declares a transaction boundary
- `@Query`: Defines a custom JPA query

### Configuration Annotations
- `@ConfigurationProperties`: Binds and validates external configuration
- `@Value`: Injects values from properties files
- `@Profile`: Indicates that a component is eligible for registration when one or more profiles are active
- `@PropertySource`: Provides a convenient way to add property sources to the environment

### Testing Annotations
- `@SpringBootTest`: Loads the full application context for integration tests
- `@WebMvcTest`: Tests Spring MVC components
- `@DataJpaTest`: Tests JPA components
- `@MockBean`: Adds mock implementations to the application context
- `@AutoConfigureMockMvc`: Auto-configures MockMvc

## REST API Development

### Simple REST Controller
```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public User createUser(@Valid @RequestBody User user) {
        return userService.save(user);
    }

    @PutMapping("/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @Valid @RequestBody User user) {
        return userService.findById(id)
                .map(existingUser -> {
                    user.setId(id);
                    return ResponseEntity.ok(userService.save(user));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        return userService.findById(id)
                .map(user -> {
                    userService.deleteById(id);
                    return ResponseEntity.noContent().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
```

### Exception Handling
```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ApiError handleResourceNotFound(ResourceNotFoundException ex) {
        return new ApiError(HttpStatus.NOT_FOUND.value(), ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiError handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return new ApiError(HttpStatus.BAD_REQUEST.value(), "Validation failed", errors);
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ApiError handleAllExceptions(Exception ex) {
        return new ApiError(HttpStatus.INTERNAL_SERVER_ERROR.value(), "An unexpected error occurred");
    }
}
```

## Data Access

### JPA Entity
```java
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "Name is required")
    private String name;

    @Column(nullable = false, unique = true)
    @Email(message = "Email should be valid")
    private String email;

    @Column(nullable = false)
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<Order> orders;

    // Getters and setters
}
```

### Spring Data JPA Repository
```java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.name LIKE %:name%")
    List<User> findByNameContaining(@Param("name") String name);
}
```

### Service Layer
```java
@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }
}
```

## Testing

### Unit Testing
```java
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    void findById_ShouldReturnUser_WhenUserExists() {
        // Given
        User user = new User();
        user.setId(1L);
        user.setName("John Doe");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        // When
        Optional<User> foundUser = userService.findById(1L);

        // Then
        assertTrue(foundUser.isPresent());
        assertEquals("John Doe", foundUser.get().getName());
        verify(userRepository).findById(1L);
    }
}
```

### Integration Testing
```java
@SpringBootTest
class UserControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    @Test
    void getUserById_ShouldReturnUser_WhenUserExists() throws Exception {
        // Given
        User user = new User();
        user.setId(1L);
        user.setName("John Doe");
        when(userService.findById(1L)).thenReturn(Optional.of(user));

        // When & Then
        mockMvc.perform(get("/api/users/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("John Doe"));
    }
}
```

### Repository Testing
```java
@DataJpaTest
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    void findByEmail_ShouldReturnUser_WhenEmailExists() {
        // Given
        User user = new User();
        user.setName("John Doe");
        user.setEmail("john@example.com");
        user.setPassword("password");
        userRepository.save(user);

        // When
        Optional<User> foundUser = userRepository.findByEmail("john@example.com");

        // Then
        assertTrue(foundUser.isPresent());
        assertEquals("John Doe", foundUser.get().getName());
    }
}
```

## Security

### Basic Security Configuration
```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .httpBasic(Customizer.withDefaults());
        
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### JWT Authentication Configuration
```java
@Configuration
@EnableWebSecurity
public class JwtSecurityConfig {

    private final JwtTokenProvider jwtTokenProvider;

    public JwtSecurityConfig(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            .addFilterBefore(new JwtAuthenticationFilter(jwtTokenProvider),
                    UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
```

### Custom UserDetailsService
```java
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + username));

        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPassword())
                .roles(user.getRoles().stream().map(Role::getName).toArray(String[]::new))
                .build();
    }
}
```

## Actuator

### Basic Configuration
```properties
# Enable all endpoints
management.endpoints.web.exposure.include=*

# Disable specific endpoints
management.endpoints.web.exposure.exclude=env,beans

# Health endpoint configuration
management.endpoint.health.show-details=always

# Info endpoint configuration
info.app.name=@project.name@
info.app.description=@project.description@
info.app.version=@project.version@
info.app.java.version=@java.version@
```

### Custom Health Indicator
```java
@Component
public class DatabaseHealthIndicator implements HealthIndicator {

    private final DataSource dataSource;

    public DatabaseHealthIndicator(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public Health health() {
        try (Connection connection = dataSource.getConnection()) {
            if (connection.isValid(1000)) {
                return Health.up()
                        .withDetail("database", "PostgreSQL")
                        .withDetail("status", "Available")
                        .build();
            } else {
                return Health.down()
                        .withDetail("error", "Database connection is not valid")
                        .build();
            }
        } catch (SQLException e) {
            return Health.down()
                    .withDetail("error", e.getMessage())
                    .build();
        }
    }
}
```

## Deployment

### JAR Packaging
```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

### Running the Application
```bash
# Run the application
java -jar myapp.jar

# Run with specific profile
java -jar myapp.jar --spring.profiles.active=prod

# Run with specific port
java -jar myapp.jar --server.port=9090

# Run with JVM options
java -Xms256m -Xmx1024m -jar myapp.jar
```

### Docker Deployment
```dockerfile
FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

### Docker Compose
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/mydb
      - SPRING_DATASOURCE_USERNAME=postgres
      - SPRING_DATASOURCE_PASSWORD=password
    depends_on:
      - db
  db:
    image: postgres:14
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  postgres-data:
```

## Common Configurations

### Logging Configuration
```properties
# Log file location
logging.file.name=logs/application.log
logging.file.max-size=10MB
logging.file.max-history=10

# Log levels
logging.level.root=INFO
logging.level.org.springframework=INFO
logging.level.org.hibernate=ERROR
logging.level.com.myapp=DEBUG

# Log pattern
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
logging.pattern.file=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

### Cache Configuration
```java
@Configuration
@EnableCaching
public class CacheConfig {

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();
        cacheManager.setCaches(Arrays.asList(
            new ConcurrentMapCache("users"),
            new ConcurrentMapCache("products")
        ));
        return cacheManager;
    }
}
```

### Internationalization (i18n)
```java
@Configuration
public class MessageConfig {

    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename("classpath:messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }

    @Bean
    public LocaleResolver localeResolver() {
        AcceptHeaderLocaleResolver resolver = new AcceptHeaderLocaleResolver();
        resolver.setDefaultLocale(Locale.US);
        return resolver;
    }
}
```

### CORS Configuration
```java
@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                        .allowedOrigins("http://localhost:3000")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true)
                        .maxAge(3600);
            }
        };
    }
}
```

## Best Practices

### Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/
│   │       └── example/
│   │           └── myapp/
│   │               ├── MyApplication.java
│   │               ├── config/
│   │               ├── controller/
│   │               ├── dto/
│   │               ├── exception/
│   │               ├── mapper/
│   │               ├── model/
│   │               ├── repository/
│   │               ├── security/
│   │               ├── service/
│   │               └── util/
│   └── resources/
│       ├── application.yml
│       ├── application-dev.yml
│       ├── application-prod.yml
│       ├── static/
│       └── templates/
└── test/
    └── java/
        └── com/
            └── example/
                └── myapp/
                    ├── controller/
                    ├── repository/
                    └── service/
```

### Code Quality Best Practices
1. **Layered Architecture**:
   - Controllers: Handle HTTP requests and responses
   - Services: Implement business logic
   - Repositories: Access data

2. **DTO Pattern**:
   - Use DTOs to transfer data between service layers
   - Map between entities and DTOs using mappers

3. **Validation**:
   - Use Bean Validation for request validation
   - Implement proper error handling

4. **Logging**:
   - Use SLF4J for logging
   - Log meaningful information for debugging

5. **Testing**:
   - Write unit tests for service layer
   - Write integration tests for repositories
   - Write end-to-end tests for APIs

6. **Configuration**:
   - Externalize configuration
   - Use profiles for different environments

7. **Security**:
   - Implement proper authentication and authorization
   - Use HTTPS for production
   - Protect sensitive information

8. **Exception Handling**:
   - Define custom exceptions
   - Handle exceptions properly
   - Provide meaningful error messages

9. **Documentation**:
   - Document APIs using Swagger/OpenAPI
   - Include meaningful comments
   - Keep README updated

10. **Performance**:
    - Optimize database queries
    - Use caching for frequently accessed data
    - Implement pagination for large datasets
