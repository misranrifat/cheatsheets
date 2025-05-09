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
