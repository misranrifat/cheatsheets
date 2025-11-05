# Java Playwright Cheatsheet

## Table of Contents
- [Installation and Setup](#installation-and-setup)
- [Basic Structure](#basic-structure)
- [Browser and Context Management](#browser-and-context-management)
- [Navigation](#navigation)
- [Selectors](#selectors)
- [Actions](#actions)
- [Waits and Assertions](#waits-and-assertions)
- [Network Interception](#network-interception)
- [Screenshots and Videos](#screenshots-and-videos)
- [Debugging](#debugging)
- [Common Patterns](#common-patterns)
- [Testing Frameworks Integration](#testing-frameworks-integration)
- [Cross-Browser Parallel Execution](#cross-browser-parallel-execution)
- [Allure Reporting](#allure-reporting)

## Installation and Setup

### Maven Dependency
```xml
<dependency>
  <groupId>com.microsoft.playwright</groupId>
  <artifactId>playwright</artifactId>
  <version>1.41.0</version>
</dependency>
```

### Gradle Dependency
```groovy
implementation 'com.microsoft.playwright:playwright:1.41.0'
```

### Install Browsers
```bash
mvn exec:java -e -D exec.mainClass=com.microsoft.playwright.CLI -D exec.args="install"
```

## Basic Structure

### Simple Example
```java
import com.microsoft.playwright.*;

public class PlaywrightExample {
    public static void main(String[] args) {
        try (Playwright playwright = Playwright.create()) {
            Browser browser = playwright.chromium().launch();
            Page page = browser.newPage();
            page.navigate("https://playwright.dev/");
            System.out.println(page.title());
            browser.close();
        }
    }
}
```

### With Browser Context
```java
try (Playwright playwright = Playwright.create()) {
    Browser browser = playwright.chromium().launch();
    BrowserContext context = browser.newContext();
    Page page = context.newPage();
    // Perform actions...
    context.close();
    browser.close();
}
```

## Browser and Context Management

### Launch Options
```java
Browser browser = playwright.chromium().launch(new BrowserType.LaunchOptions()
    .setHeadless(false)        // Run in non-headless mode
    .setSlowMo(50)             // Slow down operations by 50ms
    .setDevtools(true)         // Open developer tools
    .setArgs(Arrays.asList("--start-maximized"))  // Browser arguments
);
```

### Browser Context Options
```java
BrowserContext context = browser.newContext(new Browser.NewContextOptions()
    .setViewportSize(1920, 1080)              // Set viewport size
    .setUserAgent("Custom User Agent")        // Set user agent
    .setLocale("en-US")                       // Set locale
    .setTimezoneId("America/New_York")        // Set timezone
    .setGeolocation(41.890221, 12.492348)     // Set geolocation
    .setPermissions(Arrays.asList("geolocation"))  // Grant permissions
    .setHttpCredentials("username", "password")    // HTTP Authentication
);
```

### Multiple Pages & Contexts
```java
// Create two isolated browser contexts
BrowserContext context1 = browser.newContext();
BrowserContext context2 = browser.newContext();

// Create pages in each context
Page page1 = context1.newPage();
Page page2 = context2.newPage();
```

### Handle Multiple Tabs
```java
// Listen for new pages (tabs)
context.onPage(page -> {
    System.out.println("New page opened: " + page.url());
    // Handle the new page...
});

// Click something that opens a new tab
Page newPage = context.waitForPage(() -> {
    page.click("a[target='_blank']");
});
```

## Navigation

### Basic Navigation
```java
// Navigate to URL
page.navigate("https://example.com");

// Navigate with options
page.navigate("https://example.com",
    new Page.NavigateOptions()
        .setTimeout(30000)     // 30 seconds timeout
        .setWaitUntil(WaitUntilState.NETWORKIDLE)  // Wait until network is idle
);

// Get current URL
String url = page.url();

// Go back and forward
page.goBack();
page.goForward();

// Reload page
page.reload();
```

## Selectors

### Basic Selectors
```java
// CSS Selectors
page.click("div.class");
page.click("#id");
page.click("text=Click me");    // Text selector
page.click("[aria-label='Submit']");  // Attribute selector

// XPath
page.click("xpath=//button");
page.click("xpath=//button[contains(text(), 'Submit')]");

// Text selectors
page.click("text=Exact text");
page.click("text='Exact text with spaces'");
page.click("text=/text with regex/i");  // Case-insensitive regex

// Combine selectors
page.click("form >> input[type=submit]");  // Descendant combinator
page.click("form input:nth-child(2)");     // CSS pseudo-selectors
```

### Advanced Selectors
```java
// Locate by test ID (data-testid attribute)
page.click("[data-testid=submit-button]");

// Locate by placeholder
page.click("[placeholder='Enter your name']");

// nth element
page.click(".items >> nth=2");  // Select the 3rd element (0-based)

// Visible elements only
page.click("button:visible");

// First and last
page.click(".items >> first");  // First element
page.click(".items >> last");   // Last element

// Has-text (elements containing text)
page.click("div:has-text('Hello')");

// Has (elements containing other elements)
page.click("div:has(button.primary)");
```

## Actions

### Mouse Actions
```java
// Click
page.click("#button");
page.click("#button", new Page.ClickOptions()
    .setButton(MouseButton.RIGHT)    // RIGHT, LEFT or MIDDLE
    .setClickCount(2)                // Double click
    .setDelay(1000)                  // Hold for 1 second before release
    .setPosition(10, 15)             // Click 10px from left, 15px from top
    .setForce(true)                  // Bypass actionability checks
);

// Hover
page.hover("#menu");

// Drag and Drop
page.dragAndDrop("#source", "#target");

// Mouse movement
page.mouse().move(100, 200);
page.mouse().down();
page.mouse().move(300, 400);
page.mouse().up();
```

### Keyboard Actions
```java
// Type text
page.fill("#input", "Hello, World!");

// Press a single key
page.press("#input", "Enter");

// Key combinations
page.keyboard().press("Control+A");  // Select all
page.keyboard().press("Control+C");  // Copy
page.keyboard().press("Control+V");  // Paste

// Advanced keyboard control
page.keyboard().down("Shift");
page.keyboard().press("ArrowRight");  // Shift + Right Arrow
page.keyboard().press("ArrowRight");  // Shift + Right Arrow again
page.keyboard().up("Shift");
```

### Form Actions
```java
// Fill input
page.fill("input[name='username']", "john_doe");

// Clear input
page.fill("input[name='username']", "");

// Check/uncheck checkboxes
page.check("input[type='checkbox']");     // Check
page.uncheck("input[type='checkbox']");   // Uncheck
page.setChecked("input[type='checkbox']", true);  // Set to checked state

// Radio buttons
page.check("input[type='radio'][value='option1']");

// Select dropdown
page.selectOption("select#country", "USA");                  // By value
page.selectOption("select#country", new String[]{"USA", "Canada"});  // Multiple values
page.selectOption("select#country", new SelectOption().setLabel("United States"));  // By label
page.selectOption("select#country", new SelectOption().setIndex(2));  // By index

// File upload
page.setInputFiles("input[type='file']", Paths.get("myfile.pdf"));
page.setInputFiles("input[type='file']", new Path[]{
    Paths.get("file1.pdf"),
    Paths.get("file2.pdf")
});
```

## Waits and Assertions

### Basic Waits
```java
// Wait for element
page.waitForSelector("#element");
page.waitForSelector("#element", new Page.WaitForSelectorOptions()
    .setState(WaitForSelectorState.VISIBLE)  // ATTACHED, DETACHED, VISIBLE, HIDDEN
    .setTimeout(5000)                        // 5 seconds timeout
);

// Wait for navigation
page.waitForNavigation(() -> {
    page.click("a.link");  // Click that causes navigation
});

// Wait for specific URL
page.waitForURL("https://example.com/welcome");
page.waitForURL(Pattern.compile(".*welcome.*"));

// Wait for load state
page.waitForLoadState(LoadState.NETWORKIDLE);  // DOMCONTENTLOADED, LOAD, NETWORKIDLE

// Wait for function
page.waitForFunction("() => window.readyState === 'complete'");
```

### Assertions
```java
// Using Playwright's assertions
import static com.microsoft.playwright.assertions.PlaywrightAssertions.assertThat;

// Element assertions
assertThat(page.locator("button")).isVisible();
assertThat(page.locator("button")).isEnabled();
assertThat(page.locator("button")).isDisabled();
assertThat(page.locator("button")).isHidden();
assertThat(page.locator(".error")).hasText("Invalid input");
assertThat(page.locator("input")).hasValue("text");
assertThat(page.locator("input")).hasAttribute("required", "true");
assertThat(page.locator("input[type=checkbox]")).isChecked();

// Page assertions
assertThat(page).hasTitle("Page Title");
assertThat(page).hasURL(Pattern.compile(".*checkout"));

// Soft assertions (don't fail immediately)
assertThat(page.locator("button")).isVisible(new LocatorAssertions.IsVisibleOptions()
    .setTimeout(5000)     // Wait up to 5 seconds
);
```

## Network Interception

### Route Handling
```java
// Block images
page.route("**/*.{png,jpg,jpeg,svg}", route -> route.abort());

// Mock API response
page.route("**/api/users", route -> {
    route.fulfill(new Route.FulfillOptions()
        .setStatus(200)
        .setContentType("application/json")
        .setBody("[{\"name\": \"John\", \"age\": 30}]")
    );
});

// Modify request
page.route("**/api/submit", route -> {
    String postData = route.request().postData();
    // Modify the data as needed
    route.continue_(new Route.ContinueOptions()
        .setPostData(modifiedData)
    );
});

// Continue with custom headers
page.route("**/*", route -> {
    Map<String, String> headers = new HashMap<>(route.request().headers());
    headers.put("X-Custom-Header", "value");
    route.continue_(new Route.ContinueOptions().setHeaders(headers));
});
```

### Network Monitoring
```java
// Listen for all requests
page.onRequest(request -> {
    System.out.println(">> " + request.method() + " " + request.url());
});

// Listen for responses
page.onResponse(response -> {
    System.out.println("<< " + response.status() + " " + response.url());
});

// Wait for specific request
Request request = page.waitForRequest("**/api/users", () -> {
    page.click("button#load-users");
});

// Wait for specific response
Response response = page.waitForResponse("**/api/users", () -> {
    page.click("button#load-users");
});

// Get response body
byte[] body = response.body();
String json = response.text();
JsonObject jsonObj = new Gson().fromJson(response.text(), JsonObject.class);
```

## Screenshots and Videos

### Screenshots
```java
// Take screenshot
page.screenshot(new Page.ScreenshotOptions()
    .setPath(Paths.get("screenshot.png"))
    .setFullPage(true)  // Full page screenshot
);

// Screenshot specific element
page.locator(".header").screenshot(new Locator.ScreenshotOptions()
    .setPath(Paths.get("header.png"))
);

// Screenshot options
page.screenshot(new Page.ScreenshotOptions()
    .setPath(Paths.get("screenshot.png"))
    .setQuality(90)                     // JPEG quality (0-100)
    .setType(ScreenshotType.JPEG)       // PNG or JPEG
    .setOmitBackground(true)            // Transparent background
    .setClip(0, 0, 500, 500)            // x, y, width, height
);
```

### Videos
```java
// Enable video recording for context
BrowserContext context = browser.newContext(new Browser.NewContextOptions()
    .setRecordVideoDir(Paths.get("videos/"))
    .setRecordVideoSize(1280, 720)
);

// Use the context...

// Get video path (after closing the page)
String videoPath = page.video().path().toString();

// Stop video recording
context.close();
```

## Debugging

### Playwright Inspector
```bash
# Run with inspector (CLI)
PWDEBUG=1 mvn test

# Or set environment variable in code
System.setProperty("playwright.firefox.debug", "1");
```

### Tracing
```java
// Start tracing
context.tracing().start(new Tracing.StartOptions()
    .setScreenshots(true)
    .setSnapshots(true)
);

// Perform actions...

// Stop and save trace
context.tracing().stop(new Tracing.StopOptions()
    .setPath(Paths.get("trace.zip"))
);

// View trace with Playwright CLI
// npx playwright show-trace trace.zip
```

### Logging and Console
```java
// Listen for console messages
page.onConsoleMessage(message -> {
    System.out.println("Console: " + message.text());
});

// Listen for JavaScript errors
page.onPageError(exception -> {
    System.err.println("Error: " + exception);
});

// Evaluate in console
Object result = page.evaluate("() => { return window.innerHeight; }");

// Pause execution (only works with PWDEBUG=1)
page.pause();
```

## Common Patterns

### Page Object Model
```java
public class LoginPage {
    private final Page page;

    // Locators
    private final Locator usernameInput;
    private final Locator passwordInput;
    private final Locator loginButton;

    public LoginPage(Page page) {
        this.page = page;
        this.usernameInput = page.locator("#username");
        this.passwordInput = page.locator("#password");
        this.loginButton = page.locator("button[type='submit']");
    }

    public void navigate() {
        page.navigate("https://example.com/login");
    }

    public void login(String username, String password) {
        usernameInput.fill(username);
        passwordInput.fill(password);
        loginButton.click();
    }

    public boolean isLoggedIn() {
        return page.url().contains("/dashboard");
    }
}

// Usage
LoginPage loginPage = new LoginPage(page);
loginPage.navigate();
loginPage.login("user", "pass");
```

### Handle Authentication
```java
// Login and save state
BrowserContext context = browser.newContext();
Page page = context.newPage();
page.navigate("https://example.com/login");
page.fill("#username", "user");
page.fill("#password", "password");
page.click("button[type='submit']");
// Save storage state
context.storageState(new BrowserContext.StorageStateOptions()
    .setPath(Paths.get("auth.json"))
);

// Reuse authentication
BrowserContext authenticatedContext = browser.newContext(
    new Browser.NewContextOptions().setStorageStatePath(Paths.get("auth.json"))
);
```

### Handle Dialogs
```java
// Handle alerts, confirms, prompts
page.onDialog(dialog -> {
    System.out.println("Dialog message: " + dialog.message());
    dialog.accept("Optional input for prompt");  // Or dialog.dismiss()
});

// Trigger a dialog
page.evaluate("alert('Hello')");
```

### Handle Frames
```java
// Get frame by name
Frame frame = page.frame("frameName");

// Get frame by URL
Frame frame = page.frameByUrl(Pattern.compile(".*iframe-src.*"));

// Work with frame
frame.fill("input", "text");
frame.click("button");

// Frame locator (recommended approach)
page.frameLocator("#iframe").locator("button").click();
```

## Testing Frameworks Integration

### JUnit 5 Integration
```java
import org.junit.jupiter.api.*;
import com.microsoft.playwright.*;

public class PlaywrightTest {
    static Playwright playwright;
    static Browser browser;

    BrowserContext context;
    Page page;

    @BeforeAll
    static void launchBrowser() {
        playwright = Playwright.create();
        browser = playwright.chromium().launch();
    }

    @AfterAll
    static void closeBrowser() {
        playwright.close();
    }

    @BeforeEach
    void createContextAndPage() {
        context = browser.newContext();
        page = context.newPage();
    }

    @AfterEach
    void closeContext() {
        context.close();
    }

    @Test
    void shouldNavigateToHomepage() {
        page.navigate("https://playwright.dev/");
        Assertions.assertEquals("Fast and reliable end-to-end testing for modern web apps | Playwright", page.title());
    }
}
```

### TestNG Integration
```java
import org.testng.annotations.*;
import com.microsoft.playwright.*;
import static com.microsoft.playwright.assertions.PlaywrightAssertions.assertThat;

public class PlaywrightTestNG {
    Playwright playwright;
    Browser browser;
    BrowserContext context;
    Page page;

    @BeforeSuite
    void launchBrowser() {
        playwright = Playwright.create();
        browser = playwright.chromium().launch();
    }

    @AfterSuite
    void closeBrowser() {
        playwright.close();
    }

    @BeforeMethod
    void createContextAndPage() {
        context = browser.newContext();
        page = context.newPage();
    }

    @AfterMethod
    void closeContext() {
        context.close();
    }

    @Test
    void shouldNavigateToHomepage() {
        page.navigate("https://playwright.dev/");
        assertThat(page).hasTitle(Pattern.compile(".*Playwright"));
    }
}
```

### Cucumber Integration
```java
// StepDefinitions.java
import io.cucumber.java.en.*;
import com.microsoft.playwright.*;

public class StepDefinitions {
    private final PlaywrightContext context;  // Custom class to manage Playwright
    private Page page;

    public StepDefinitions(PlaywrightContext context) {
        this.context = context;
        this.page = context.getPage();
    }

    @Given("I navigate to {string}")
    public void navigateTo(String url) {
        page.navigate(url);
    }

    @When("I click on {string}")
    public void clickElement(String selector) {
        page.click(selector);
    }

    @Then("I should see {string}")
    public void checkContent(String text) {
        page.waitForSelector("text=" + text);
    }
}

// Hook.java
import io.cucumber.java.*;
import com.microsoft.playwright.*;

public class Hooks {
    private final PlaywrightContext context;

    public Hooks(PlaywrightContext context) {
        this.context = context;
    }

    @Before
    public void beforeScenario() {
        context.createContextAndPage();
    }

    @After
    public void afterScenario() {
        context.closeContext();
    }
}
```

## Cross-Browser Parallel Execution

### TestNG Parallel Execution

#### Dependencies (Maven)
```xml
<dependency>
    <groupId>org.testng</groupId>
    <artifactId>testng</artifactId>
    <version>7.8.0</version>
    <scope>test</scope>
</dependency>
```

#### testng.xml Configuration
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Playwright Cross-Browser Suite" parallel="tests" thread-count="3">

    <!-- Chrome Tests -->
    <test name="Chrome Tests">
        <parameter name="browser" value="chromium"/>
        <classes>
            <class name="com.example.tests.LoginTest"/>
            <class name="com.example.tests.CheckoutTest"/>
        </classes>
    </test>

    <!-- Firefox Tests -->
    <test name="Firefox Tests">
        <parameter name="browser" value="firefox"/>
        <classes>
            <class name="com.example.tests.LoginTest"/>
            <class name="com.example.tests.CheckoutTest"/>
        </classes>
    </test>

    <!-- WebKit Tests -->
    <test name="WebKit Tests">
        <parameter name="browser" value="webkit"/>
        <classes>
            <class name="com.example.tests.LoginTest"/>
            <class name="com.example.tests.CheckoutTest"/>
        </classes>
    </test>

</suite>
```

#### Base Test Class with Browser Parameter
```java
import org.testng.annotations.*;
import com.microsoft.playwright.*;

public class BaseTest {
    protected Playwright playwright;
    protected Browser browser;
    protected BrowserContext context;
    protected Page page;

    @BeforeClass
    @Parameters("browser")
    public void setup(@Optional("chromium") String browserName) {
        playwright = Playwright.create();

        // Launch browser based on parameter
        BrowserType.LaunchOptions launchOptions = new BrowserType.LaunchOptions()
            .setHeadless(true);

        switch (browserName.toLowerCase()) {
            case "firefox":
                browser = playwright.firefox().launch(launchOptions);
                break;
            case "webkit":
                browser = playwright.webkit().launch(launchOptions);
                break;
            case "chromium":
            default:
                browser = playwright.chromium().launch(launchOptions);
                break;
        }
    }

    @BeforeMethod
    public void createContext() {
        context = browser.newContext();
        page = context.newPage();
    }

    @AfterMethod
    public void closeContext() {
        if (context != null) {
            context.close();
        }
    }

    @AfterClass
    public void teardown() {
        if (browser != null) {
            browser.close();
        }
        if (playwright != null) {
            playwright.close();
        }
    }
}
```

#### Test Class Example
```java
import org.testng.annotations.Test;
import static com.microsoft.playwright.assertions.PlaywrightAssertions.assertThat;

public class LoginTest extends BaseTest {

    @Test
    public void testSuccessfulLogin() {
        page.navigate("https://example.com/login");
        page.fill("#username", "testuser");
        page.fill("#password", "password123");
        page.click("button[type='submit']");

        assertThat(page).hasURL("https://example.com/dashboard");
    }

    @Test
    public void testInvalidLogin() {
        page.navigate("https://example.com/login");
        page.fill("#username", "invalid");
        page.fill("#password", "wrong");
        page.click("button[type='submit']");

        assertThat(page.locator(".error-message")).isVisible();
    }
}
```

#### Method-Level Parallel Execution
```xml
<!-- Execute methods in parallel instead of classes -->
<suite name="Method Parallel Suite" parallel="methods" thread-count="5">
    <test name="All Tests">
        <classes>
            <class name="com.example.tests.LoginTest"/>
            <class name="com.example.tests.CheckoutTest"/>
            <class name="com.example.tests.SearchTest"/>
        </classes>
    </test>
</suite>
```

#### Data Provider for Multi-Browser Testing
```java
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class CrossBrowserTest {

    @DataProvider(name = "browsers", parallel = true)
    public Object[][] getBrowsers() {
        return new Object[][] {
            {"chromium"},
            {"firefox"},
            {"webkit"}
        };
    }

    @Test(dataProvider = "browsers")
    public void testAcrossBrowsers(String browserName) {
        try (Playwright playwright = Playwright.create()) {
            BrowserType browserType;
            switch (browserName) {
                case "firefox":
                    browserType = playwright.firefox();
                    break;
                case "webkit":
                    browserType = playwright.webkit();
                    break;
                default:
                    browserType = playwright.chromium();
            }

            Browser browser = browserType.launch(new BrowserType.LaunchOptions().setHeadless(true));
            Page page = browser.newPage();
            page.navigate("https://playwright.dev/");

            assertThat(page).hasTitle(Pattern.compile(".*Playwright"));

            browser.close();
        }
    }
}
```

### JUnit 5 Parallel Execution

#### Dependencies (Maven)
```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.10.0</version>
    <scope>test</scope>
</dependency>
```

#### junit-platform.properties
```properties
# Enable parallel execution
junit.jupiter.execution.parallel.enabled=true

# Set parallelization strategy
junit.jupiter.execution.parallel.mode.default=concurrent
junit.jupiter.execution.parallel.mode.classes.default=concurrent

# Configure thread pool
junit.jupiter.execution.parallel.config.strategy=fixed
junit.jupiter.execution.parallel.config.fixed.parallelism=3
```

#### Parameterized Test with Multiple Browsers
```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import com.microsoft.playwright.*;

public class CrossBrowserJUnitTest {

    @ParameterizedTest
    @ValueSource(strings = {"chromium", "firefox", "webkit"})
    void testLoginOnMultipleBrowsers(String browserName) {
        try (Playwright playwright = Playwright.create()) {
            Browser browser = launchBrowser(playwright, browserName);
            BrowserContext context = browser.newContext();
            Page page = context.newPage();

            page.navigate("https://example.com/login");
            page.fill("#username", "testuser");
            page.fill("#password", "password123");
            page.click("button[type='submit']");

            assertThat(page).hasURL("https://example.com/dashboard");

            context.close();
            browser.close();
        }
    }

    private Browser launchBrowser(Playwright playwright, String browserName) {
        BrowserType.LaunchOptions options = new BrowserType.LaunchOptions().setHeadless(true);

        switch (browserName.toLowerCase()) {
            case "firefox":
                return playwright.firefox().launch(options);
            case "webkit":
                return playwright.webkit().launch(options);
            default:
                return playwright.chromium().launch(options);
        }
    }
}
```

#### Custom Annotation for Browser Testing
```java
import org.junit.jupiter.params.provider.ArgumentsSource;
import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@ArgumentsSource(BrowserArgumentsProvider.class)
public @interface BrowserTest {
    String[] browsers() default {"chromium", "firefox", "webkit"};
}

// Arguments Provider
import org.junit.jupiter.api.extension.ExtensionContext;
import org.junit.jupiter.params.provider.*;
import java.util.stream.Stream;

public class BrowserArgumentsProvider implements ArgumentsProvider {
    @Override
    public Stream<? extends Arguments> provideArguments(ExtensionContext context) {
        BrowserTest annotation = context.getRequiredTestMethod()
            .getAnnotation(BrowserTest.class);

        return Stream.of(annotation.browsers())
            .map(Arguments::of);
    }
}

// Usage
@ParameterizedTest
@BrowserTest(browsers = {"chromium", "firefox"})
void testOnSpecificBrowsers(String browserName) {
    // Test implementation
}
```

#### Thread-Safe Browser Management
```java
import org.junit.jupiter.api.*;

public class ThreadSafeBrowserTest {
    private static final ThreadLocal<Playwright> playwrightThreadLocal = new ThreadLocal<>();
    private static final ThreadLocal<Browser> browserThreadLocal = new ThreadLocal<>();
    private static final ThreadLocal<BrowserContext> contextThreadLocal = new ThreadLocal<>();
    private static final ThreadLocal<Page> pageThreadLocal = new ThreadLocal<>();

    @BeforeEach
    void setup() {
        Playwright playwright = Playwright.create();
        playwrightThreadLocal.set(playwright);

        Browser browser = playwright.chromium().launch();
        browserThreadLocal.set(browser);

        BrowserContext context = browser.newContext();
        contextThreadLocal.set(context);

        Page page = context.newPage();
        pageThreadLocal.set(page);
    }

    @AfterEach
    void teardown() {
        Page page = pageThreadLocal.get();
        if (page != null) page.close();

        BrowserContext context = contextThreadLocal.get();
        if (context != null) context.close();

        Browser browser = browserThreadLocal.get();
        if (browser != null) browser.close();

        Playwright playwright = playwrightThreadLocal.get();
        if (playwright != null) playwright.close();

        // Clean up thread locals
        playwrightThreadLocal.remove();
        browserThreadLocal.remove();
        contextThreadLocal.remove();
        pageThreadLocal.remove();
    }

    protected Page getPage() {
        return pageThreadLocal.get();
    }

    @Test
    void testExample() {
        Page page = getPage();
        page.navigate("https://example.com");
        assertThat(page).hasTitle("Example Domain");
    }
}
```

## Allure Reporting

### Dependencies

#### Maven Dependencies
```xml
<!-- Allure TestNG -->
<dependency>
    <groupId>io.qameta.allure</groupId>
    <artifactId>allure-testng</artifactId>
    <version>2.24.0</version>
</dependency>

<!-- Allure JUnit 5 -->
<dependency>
    <groupId>io.qameta.allure</groupId>
    <artifactId>allure-junit5</artifactId>
    <version>2.24.0</version>
</dependency>

<!-- Allure Maven Plugin -->
<build>
    <plugins>
        <plugin>
            <groupId>io.qameta.allure</groupId>
            <artifactId>allure-maven</artifactId>
            <version>2.12.0</version>
            <configuration>
                <reportVersion>2.24.0</reportVersion>
                <resultsDirectory>${project.build.directory}/allure-results</resultsDirectory>
            </configuration>
        </plugin>
    </plugins>
</build>
```

#### Gradle Dependencies
```groovy
plugins {
    id 'io.qameta.allure' version '2.11.2'
}

dependencies {
    // For TestNG
    testImplementation 'io.qameta.allure:allure-testng:2.24.0'

    // For JUnit 5
    testImplementation 'io.qameta.allure:allure-junit5:2.24.0'
}

allure {
    version = '2.24.0'
    autoconfigure = true
    aspectjweaver = true
}
```

### Allure Annotations

#### Basic Annotations
```java
import io.qameta.allure.*;
import org.testng.annotations.Test;

@Epic("E-commerce Platform")
@Feature("User Authentication")
public class LoginTests extends BaseTest {

    @Test
    @Story("Successful Login")
    @Severity(SeverityLevel.CRITICAL)
    @Description("Test verifies that user can login with valid credentials")
    @Link(name = "User Story", url = "https://jira.example.com/US-123")
    @Issue("BUG-456")
    @TmsLink("TC-789")
    public void testSuccessfulLogin() {
        loginToApplication("validuser", "validpass");
        verifyDashboardPage();
    }

    @Step("Login to application with username: {username}")
    private void loginToApplication(String username, String password) {
        page.navigate("https://example.com/login");
        page.fill("#username", username);
        page.fill("#password", password);
        page.click("button[type='submit']");
    }

    @Step("Verify dashboard page is displayed")
    private void verifyDashboardPage() {
        assertThat(page).hasURL(Pattern.compile(".*dashboard"));
    }
}
```

#### Step Annotations
```java
import io.qameta.allure.Step;

public class AllureSteps {
    private final Page page;

    public AllureSteps(Page page) {
        this.page = page;
    }

    @Step("Navigate to URL: {url}")
    public void navigateTo(String url) {
        page.navigate(url);
    }

    @Step("Fill field {selector} with value: {value}")
    public void fillField(String selector, String value) {
        page.fill(selector, value);
    }

    @Step("Click on element: {selector}")
    public void clickElement(String selector) {
        page.click(selector);
    }

    @Step("Verify element {selector} is visible")
    public void verifyElementVisible(String selector) {
        assertThat(page.locator(selector)).isVisible();
    }

    @Step("Verify page title contains: {expectedTitle}")
    public void verifyPageTitle(String expectedTitle) {
        assertThat(page).hasTitle(Pattern.compile(".*" + expectedTitle + ".*"));
    }
}
```

### Attachments

#### Screenshot Attachments
```java
import io.qameta.allure.Attachment;
import io.qameta.allure.Step;

public class AllureHelper {

    @Attachment(value = "Screenshot: {name}", type = "image/png")
    public static byte[] saveScreenshot(Page page, String name) {
        return page.screenshot(new Page.ScreenshotOptions().setFullPage(true));
    }

    @Attachment(value = "Page Screenshot", type = "image/png")
    public static byte[] takeScreenshot(Page page) {
        return page.screenshot();
    }

    @Attachment(value = "Element Screenshot", type = "image/png")
    public static byte[] takeElementScreenshot(Locator locator) {
        return locator.screenshot();
    }

    @Attachment(value = "Page Source", type = "text/html")
    public static String savePageSource(Page page) {
        return page.content();
    }

    @Attachment(value = "Browser Console Logs", type = "text/plain")
    public static String saveConsoleLogs(String logs) {
        return logs;
    }

    @Attachment(value = "Video Recording", type = "video/webm")
    public static byte[] saveVideo(Path videoPath) throws IOException {
        return Files.readAllBytes(videoPath);
    }
}
```

#### Automatic Screenshot on Failure
```java
import org.testng.ITestListener;
import org.testng.ITestResult;
import io.qameta.allure.Attachment;

public class AllureListener implements ITestListener {

    @Override
    public void onTestFailure(ITestResult result) {
        Object testClass = result.getInstance();

        // Get page from test instance
        if (testClass instanceof BaseTest) {
            Page page = ((BaseTest) testClass).page;
            if (page != null) {
                AllureHelper.saveScreenshot(page, "Failure Screenshot");
                AllureHelper.savePageSource(page);
            }
        }
    }

    @Attachment(value = "Failure Screenshot", type = "image/png")
    private byte[] saveScreenshotOnFailure(Page page) {
        return page.screenshot(new Page.ScreenshotOptions().setFullPage(true));
    }
}

// Add listener in testng.xml
// <listeners>
//     <listener class-name="com.example.AllureListener"/>
// </listeners>
```

### Advanced Allure Features

#### Categorization
```java
@Epic("E-commerce Platform")
@Feature("Shopping Cart")
@Story("Add Items to Cart")
@Owner("QA Team")
@Tag("smoke")
@Tag("regression")
public class ShoppingCartTest extends BaseTest {

    @Test
    @Severity(SeverityLevel.BLOCKER)
    public void testAddItemToCart() {
        // Test implementation
    }
}
```

#### Parameters in Report
```java
import io.qameta.allure.Allure;

@Test
public void testWithParameters() {
    String browser = "Chrome";
    String environment = "Staging";

    Allure.parameter("Browser", browser);
    Allure.parameter("Environment", environment);
    Allure.parameter("Test Data", "user@example.com");

    // Test steps
}
```

#### Dynamic Steps
```java
import io.qameta.allure.Allure;

@Test
public void testDynamicSteps() {
    Allure.step("Step 1: Navigate to login page", () -> {
        page.navigate("https://example.com/login");
    });

    Allure.step("Step 2: Enter credentials", () -> {
        page.fill("#username", "testuser");
        page.fill("#password", "password");
    });

    Allure.step("Step 3: Click login button", () -> {
        page.click("button[type='submit']");
    });

    Allure.step("Step 4: Verify successful login", () -> {
        assertThat(page).hasURL(Pattern.compile(".*dashboard"));
    });
}
```

#### Environment Properties
```properties
# Create allure.properties or environment.properties in src/test/resources
Browser=Chrome
OS=Windows 10
Environment=Staging
API.Version=v2.0
```

#### Programmatic Environment Info
```java
import io.qameta.allure.Allure;

@BeforeClass
public void setEnvironmentInfo() {
    Allure.addEnvironment("Browser", "Chromium");
    Allure.addEnvironment("Browser Version", "120.0");
    Allure.addEnvironment("OS", System.getProperty("os.name"));
    Allure.addEnvironment("Java Version", System.getProperty("java.version"));
    Allure.addEnvironment("Base URL", "https://example.com");
}
```

### Generate and View Reports

#### Maven Commands
```bash
# Run tests and generate Allure results
mvn clean test

# Generate Allure report
mvn allure:report

# Serve Allure report (opens in browser)
mvn allure:serve

# Generate report to specific directory
mvn allure:report -Dallure.results.directory=target/allure-results
```

#### Gradle Commands
```bash
# Run tests
./gradlew clean test

# Generate Allure report
./gradlew allureReport

# Serve Allure report
./gradlew allureServe
```

#### Allure CLI
```bash
# Install Allure CLI (macOS)
brew install allure

# Generate report from results directory
allure generate target/allure-results --clean -o target/allure-report

# Open report in browser
allure open target/allure-report

# Serve report
allure serve target/allure-results
```

### Complete Test Example with Allure

```java
import io.qameta.allure.*;
import org.testng.annotations.*;
import com.microsoft.playwright.*;
import static com.microsoft.playwright.assertions.PlaywrightAssertions.assertThat;

@Epic("E-commerce Application")
@Feature("User Management")
public class CompleteAllureTest extends BaseTest {

    private AllureSteps steps;

    @BeforeMethod
    @Override
    public void createContext() {
        super.createContext();
        steps = new AllureSteps(page);
    }

    @Test
    @Story("User Registration")
    @Severity(SeverityLevel.CRITICAL)
    @Description("Verify new user can successfully register")
    @Link(name = "Requirements", url = "https://docs.example.com/registration")
    @Owner("John Doe")
    @Tag("smoke")
    @Tag("regression")
    public void testUserRegistration() {
        Allure.parameter("Test User", "newuser@example.com");
        Allure.parameter("Browser", "Chromium");

        steps.navigateTo("https://example.com/register");
        AllureHelper.saveScreenshot(page, "Registration Page");

        steps.fillField("#firstName", "John");
        steps.fillField("#lastName", "Doe");
        steps.fillField("#email", "john.doe@example.com");
        steps.fillField("#password", "SecurePass123!");
        steps.clickElement("button[type='submit']");

        AllureHelper.saveScreenshot(page, "After Registration");

        steps.verifyPageTitle("Welcome");
        steps.verifyElementVisible(".success-message");
    }

    @AfterMethod
    public void captureFailure(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            AllureHelper.saveScreenshot(page, "Test Failure");
            AllureHelper.savePageSource(page);
        }
    }
}
```
