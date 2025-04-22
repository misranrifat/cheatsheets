# Maven and Gradle Cheatsheet

## Table of Contents
- [Maven](#maven)
  - [Installation and Setup](#maven-installation-and-setup)
  - [Project Structure](#maven-project-structure)
  - [POM File](#maven-pom-file)
  - [Dependencies](#maven-dependencies)
  - [Build Lifecycle](#maven-build-lifecycle)
  - [Common Commands](#maven-common-commands)
  - [Plugins](#maven-plugins)
  - [Profiles](#maven-profiles)
  - [Multi-Module Projects](#maven-multi-module-projects)
  - [Properties](#maven-properties)
  - [Repository Management](#maven-repository-management)
- [Gradle](#gradle)
  - [Installation and Setup](#gradle-installation-and-setup)
  - [Project Structure](#gradle-project-structure)
  - [Build Files](#gradle-build-files)
  - [Dependencies](#gradle-dependencies) 
  - [Build Lifecycle](#gradle-build-lifecycle)
  - [Common Commands](#gradle-common-commands)
  - [Plugins](#gradle-plugins)
  - [Multi-Project Builds](#gradle-multi-project-builds)
  - [Properties](#gradle-properties)
  - [Repository Management](#gradle-repository-management)
  - [Task Configuration](#gradle-task-configuration)
  - [Custom Tasks](#gradle-custom-tasks)
- [Migration](#migration)
  - [Maven to Gradle](#maven-to-gradle)
  - [Gradle to Maven](#gradle-to-maven)

## Maven

<a name="maven-installation-and-setup"></a>
### Installation and Setup

**Installing Maven:**
```bash
# macOS (Homebrew)
brew install maven

# Ubuntu/Debian
sudo apt install maven

# Windows (use Chocolatey)
choco install maven
```

**Verify Installation:**
```bash
mvn -version
```

**Setting up environment variables:**
- Set `MAVEN_HOME` to Maven installation directory
- Add `%MAVEN_HOME%\bin` (Windows) or `$MAVEN_HOME/bin` (Unix) to PATH

<a name="maven-project-structure"></a>
### Project Structure

**Standard Directory Layout:**
```
my-app/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/        # Java source files
│   │   ├── resources/   # Application resources
│   │   └── webapp/      # Web application sources
│   └── test/
│       ├── java/        # Test source files
│       └── resources/   # Test resources
└── target/              # Build output directory
```

**Create a New Project:**
```bash
mvn archetype:generate -DgroupId=com.example -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

<a name="maven-pom-file"></a>
### POM File

**Basic POM Structure:**
```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <name>My Application</name>
    <description>Sample application</description>
    <url>http://www.example.com</url>
    
    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <dependencies>
        <!-- Dependencies go here -->
    </dependencies>
    
    <build>
        <plugins>
            <!-- Plugins go here -->
        </plugins>
    </build>
</project>
```

**Packaging Types:**
- `jar`: Java ARchive (default)
- `war`: Web Application Archive
- `ear`: Enterprise Archive
- `pom`: Parent project or multi-module project

<a name="maven-dependencies"></a>
### Dependencies

**Adding Dependencies:**
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>3.1.0</version>
    </dependency>
    
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

**Dependency Scopes:**
- `compile`: Default scope, available in all classpaths and transitive
- `provided`: Available during compile and test, but not runtime (e.g., servlet API)
- `runtime`: Not needed for compilation, but needed for execution (e.g., JDBC drivers)
- `test`: Only available for test compilation and execution (e.g., JUnit)
- `system`: Similar to provided, but you specify the JAR location explicitly
- `import`: Special scope for dependency management

**Excluding Transitive Dependencies:**
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>6.0.0</version>
    <exclusions>
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

**Dependency Management:**
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

<a name="maven-build-lifecycle"></a>
### Build Lifecycle

**Default Lifecycle Phases:**
1. `validate`: Validate project structure
2. `compile`: Compile source code
3. `test`: Run tests
4. `package`: Package compiled code
5. `verify`: Run integration tests
6. `install`: Install package to local repository
7. `deploy`: Copy package to remote repository

**Clean Lifecycle:**
- `clean`: Delete target directory

**Site Lifecycle:**
- `site`: Generate project's site documentation

<a name="maven-common-commands"></a>
### Common Commands

**Build Commands:**
```bash
# Clean and install
mvn clean install

# Compile the project
mvn compile

# Run tests
mvn test

# Package the application
mvn package

# Skip tests
mvn install -DskipTests

# Run a specific test class
mvn test -Dtest=TestClassName

# Specify active profile
mvn package -P production

# Show dependency tree
mvn dependency:tree

# Check for dependency updates
mvn versions:display-dependency-updates

# Generate site documentation
mvn site

# Clean project
mvn clean
```

**Debugging Commands:**
```bash
# Debug mode (show more output)
mvn -X clean install

# Offline mode
mvn -o clean install

# Show effective POM
mvn help:effective-pom

# Show all plugin goals
mvn help:describe -Dplugin=org.apache.maven.plugins:maven-compiler-plugin
```

<a name="maven-plugins"></a>
### Plugins

**Common Plugins:**

- **Compiler Plugin:**
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.11.0</version>
    <configuration>
        <source>17</source>
        <target>17</target>
    </configuration>
</plugin>
```

- **JAR Plugin:**
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-jar-plugin</artifactId>
    <version>3.3.0</version>
    <configuration>
        <archive>
            <manifest>
                <mainClass>com.example.MainClass</mainClass>
            </manifest>
        </archive>
    </configuration>
</plugin>
```

- **Spring Boot Plugin:**
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <version>3.1.0</version>
    <executions>
        <execution>
            <goals>
                <goal>repackage</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

- **Surefire Plugin (Testing):**
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.1.0</version>
    <configuration>
        <includes>
            <include>**/*Test.java</include>
        </includes>
    </configuration>
</plugin>
```

<a name="maven-profiles"></a>
### Profiles

**Profile Configuration:**
```xml
<profiles>
    <profile>
        <id>development</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
            <env>dev</env>
        </properties>
    </profile>
    <profile>
        <id>production</id>
        <properties>
            <env>prod</env>
        </properties>
    </profile>
</profiles>
```

**Activate Profile:**
```bash
mvn package -P production
```

<a name="maven-multi-module-projects"></a>
### Multi-Module Projects

**Parent POM:**
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>parent-project</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>
    
    <modules>
        <module>module1</module>
        <module>module2</module>
    </modules>
    
    <properties>
        <!-- Common properties -->
    </properties>
    
    <dependencyManagement>
        <!-- Manage dependency versions -->
    </dependencyManagement>
</project>
```

**Child Module POM:**
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>com.example</groupId>
        <artifactId>parent-project</artifactId>
        <version>1.0.0</version>
    </parent>
    
    <artifactId>module1</artifactId>
    
    <dependencies>
        <!-- Module-specific dependencies -->
    </dependencies>
</project>
```

<a name="maven-properties"></a>
### Properties

**Common Properties:**
```xml
<properties>
    <!-- Java version -->
    <java.version>17</java.version>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <maven.compiler.target>${java.version}</maven.compiler.target>
    
    <!-- Encoding -->
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    
    <!-- Dependency versions -->
    <spring.version>6.0.9</spring.version>
    <junit.version>5.9.3</junit.version>
</properties>
```

**Using Properties:**
```xml
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-core</artifactId>
    <version>${spring.version}</version>
</dependency>
```

<a name="maven-repository-management"></a>
### Repository Management

**Configuring Repositories:**
```xml
<repositories>
    <repository>
        <id>central</id>
        <name>Maven Central</name>
        <url>https://repo.maven.apache.org/maven2</url>
    </repository>
    <repository>
        <id>company-repo</id>
        <name>Company Repository</name>
        <url>https://repo.example.com/maven</url>
    </repository>
</repositories>
```

**Distribution Management:**
```xml
<distributionManagement>
    <repository>
        <id>internal.repo</id>
        <name>Internal Repository</name>
        <url>https://mycompany.artifactoryonline.com/mycompany/libs-release-local</url>
    </repository>
    <snapshotRepository>
        <id>internal.snapshot.repo</id>
        <name>Internal Snapshot Repository</name>
        <url>https://mycompany.artifactoryonline.com/mycompany/libs-snapshot-local</url>
    </snapshotRepository>
</distributionManagement>
```

## Gradle

<a name="gradle-installation-and-setup"></a>
### Installation and Setup

**Installing Gradle:**
```bash
# macOS (Homebrew)
brew install gradle

# Ubuntu/Debian
sudo apt install gradle

# Windows (use Chocolatey)
choco install gradle
```

**Verify Installation:**
```bash
gradle -v
```

**Setting up environment variables:**
- Set `GRADLE_HOME` to Gradle installation directory
- Add `%GRADLE_HOME%\bin` (Windows) or `$GRADLE_HOME/bin` (Unix) to PATH

**Using Gradle Wrapper:**
```bash
# Initialize wrapper
gradle wrapper

# Run gradle through wrapper
./gradlew tasks
```

<a name="gradle-project-structure"></a>
### Project Structure

**Standard Directory Layout:**
```
my-app/
├── build.gradle          # Main build script
├── settings.gradle       # Project settings
├── gradle/               # Gradle configurations
│   └── wrapper/          # Gradle Wrapper files
├── src/
│   ├── main/
│   │   ├── java/         # Java source files
│   │   ├── resources/    # Application resources
│   │   └── webapp/       # Web application sources
│   └── test/
│       ├── java/         # Test source files
│       └── resources/    # Test resources
└── build/                # Build output directory
```

**Create a New Project:**
```bash
# Using Gradle init
gradle init --type java-application
```

<a name="gradle-build-files"></a>
### Build Files

**Basic build.gradle (Groovy DSL):**
```groovy
plugins {
    id 'java'
    id 'application'
}

group = 'com.example'
version = '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web:3.1.0'
    testImplementation 'junit:junit:4.13.2'
}

application {
    mainClass = 'com.example.Main'
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

**Basic build.gradle.kts (Kotlin DSL):**
```kotlin
plugins {
    java
    application
}

group = "com.example"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:3.1.0")
    testImplementation("junit:junit:4.13.2")
}

application {
    mainClass.set("com.example.Main")
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

**Settings File (settings.gradle):**
```groovy
rootProject.name = 'my-app'
```

<a name="gradle-dependencies"></a>
### Dependencies

**Dependency Configurations:**
- `implementation`: Needed at compile time and runtime, but not exposed to dependents
- `api`: Needed at compile time and runtime, and exposed to dependents
- `compileOnly`: Needed only at compile time, not bundled at runtime (like Maven's provided)
- `runtimeOnly`: Needed only at runtime, not compile time (like Maven's runtime)
- `testImplementation`: Needed for testing only
- `testCompileOnly`: Needed only for compiling tests
- `testRuntimeOnly`: Needed only for running tests

**Adding Dependencies:**
```groovy
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web:3.1.0'
    implementation 'com.google.guava:guava:31.1-jre'
    
    compileOnly 'org.projectlombok:lombok:1.18.26'
    annotationProcessor 'org.projectlombok:lombok:1.18.26'
    
    testImplementation 'org.junit.jupiter:junit-jupiter-api:5.9.3'
    testRuntimeOnly 'org.junit.jupiter:junit-jupiter-engine:5.9.3'
}
```

**Excluding Transitive Dependencies:**
```groovy
implementation('org.springframework:spring-core:6.0.9') {
    exclude group: 'commons-logging', module: 'commons-logging'
}
```

**Dependency Management:**
```groovy
plugins {
    id 'java'
    id 'io.spring.dependency-management' version '1.1.0'
}

dependencyManagement {
    imports {
        mavenBom 'org.springframework.boot:spring-boot-dependencies:3.1.0'
    }
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    // No version needed, managed by BOM
}
```

<a name="gradle-build-lifecycle"></a>
### Build Lifecycle

**Phases:**
- `Initialization`: Determine which projects to build
- `Configuration`: Configure the project objects
- `Execution`: Execute the selected tasks

**Task Execution Graph:**
Tasks form a directed acyclic graph (DAG) based on their dependencies.

<a name="gradle-common-commands"></a>
### Common Commands

**Build Commands:**
```bash
# List all tasks
gradle tasks

# Build the project
gradle build

# Clean build
gradle clean build

# Run the application
gradle run

# Run a specific test
gradle test --tests MyTestClass

# Show dependencies
gradle dependencies

# Skip tests
gradle build -x test

# Debug mode
gradle build --debug

# Show build info
gradle buildEnvironment

# Using wrapper
./gradlew build
```

**Other Helpful Commands:**
```bash
# Generate wrapper
gradle wrapper

# Check for dependency updates
gradle dependencyUpdates

# Generate project report
gradle projectReport

# Refresh dependencies
gradle --refresh-dependencies build
```

<a name="gradle-plugins"></a>
### Plugins

**Adding Plugins (legacy):**
```groovy
apply plugin: 'java'
apply plugin: 'application'
```

**Adding Plugins (recommended):**
```groovy
plugins {
    id 'java'
    id 'application'
    id 'org.springframework.boot' version '3.1.0'
    id 'io.spring.dependency-management' version '1.1.0'
}
```

**Common Plugins:**
- `java`: Basic Java project support
- `application`: Run Java applications
- `java-library`: Java library projects
- `war`: Web applications
- `org.springframework.boot`: Spring Boot support
- `com.android.application`: Android applications
- `com.gradle.plugin-publish`: Publishing Gradle plugins

<a name="gradle-multi-project-builds"></a>
### Multi-Project Builds

**Settings File (settings.gradle):**
```groovy
rootProject.name = 'parent-project'
include 'module1', 'module2'
```

**Root build.gradle:**
```groovy
allprojects {
    repositories {
        mavenCentral()
    }
}

subprojects {
    apply plugin: 'java'
    
    group = 'com.example'
    version = '1.0.0'
    
    java {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    dependencies {
        implementation 'org.slf4j:slf4j-api:2.0.7'
        testImplementation 'junit:junit:4.13.2'
    }
}
```

**Module build.gradle:**
```groovy
dependencies {
    implementation project(':module2') // Project dependency
    implementation 'com.google.guava:guava:31.1-jre'
}
```

<a name="gradle-properties"></a>
### Properties

**gradle.properties:**
```properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
org.gradle.parallel=true
springBootVersion=3.1.0
```

**Using Properties:**
```groovy
// From gradle.properties
def springVersion = project.springBootVersion

// From system
def javaHome = System.getenv("JAVA_HOME")

// Project properties
project.ext.customProperty = "value"
```

<a name="gradle-repository-management"></a>
### Repository Management

**Configure Repositories:**
```groovy
repositories {
    mavenCentral()
    google()
    maven {
        url = uri("https://repo.example.com/maven")
        credentials {
            username = "user"
            password = "secret"
        }
    }
    flatDir {
        dirs 'libs'
    }
}
```

**Publishing:**
```groovy
plugins {
    id 'maven-publish'
}

publishing {
    publications {
        mavenJava(MavenPublication) {
            from components.java
        }
    }
    
    repositories {
        maven {
            url = uri("https://repo.example.com/releases")
            credentials {
                username = project.findProperty("repoUser") ?: "user"
                password = project.findProperty("repoPassword") ?: "secret"
            }
        }
    }
}
```

<a name="gradle-task-configuration"></a>
### Task Configuration

**Configuring Built-in Tasks:**
```groovy
tasks.named('test') {
    useJUnitPlatform()
    maxHeapSize = '1G'
}

tasks.withType(JavaCompile) {
    options.encoding = 'UTF-8'
    options.compilerArgs << '-Xlint:unchecked'
}
```

**Task Inputs and Outputs:**
```groovy
task processData {
    inputs.file('src/data/input.txt')
    outputs.file('build/output.txt')
    
    doLast {
        def inputFile = file('src/data/input.txt')
        def outputFile = file('build/output.txt')
        outputFile.text = inputFile.text.toUpperCase()
    }
}
```

<a name="gradle-custom-tasks"></a>
### Custom Tasks

**Simple Task:**
```groovy
task hello {
    doLast {
        println 'Hello, World!'
    }
}
```

**Custom Task Class:**
```groovy
class GreetingTask extends DefaultTask {
    @Input
    String message = 'Hello from Gradle'
    
    @TaskAction
    def greet() {
        println message
    }
}

tasks.register('greet', GreetingTask) {
    message = 'Hi there!'
}
```

**Task Ordering:**
```groovy
task first {
    doLast { println 'First' }
}

task second {
    doLast { println 'Second' }
}

// Make second depend on first
second.dependsOn first

// Or
second {
    dependsOn first
}

// Task ordering without dependency
second.mustRunAfter first
```

## Migration

<a name="maven-to-gradle"></a>
### Maven to Gradle

**Convert Maven to Gradle:**
```bash
gradle init --type pom
```

**Common Mappings:**
- Maven `compile` → Gradle `implementation`
- Maven `provided` → Gradle `compileOnly`
- Maven `runtime` → Gradle `runtimeOnly`
- Maven `test` → Gradle `testImplementation`

<a name="gradle-to-maven"></a>
### Gradle to Maven

**No direct tool, but common mappings:**

- Gradle `implementation` → Maven `compile`
- Gradle `api` → Maven `compile`
- Gradle `compileOnly` → Maven `provided`
- Gradle `runtimeOnly` → Maven `runtime`
- Gradle `testImplementation` → Maven `test`
