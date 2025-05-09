# Java Selenium Cheatsheet

## Table of Contents
- [Setup and Configuration](#setup-and-configuration)
- [WebDriver Basics](#webdriver-basics)
- [Locating Elements](#locating-elements)
- [Browser Interactions](#browser-interactions)
- [Waits and Synchronization](#waits-and-synchronization)
- [Advanced Interactions](#advanced-interactions)
- [Frames and Windows](#frames-and-windows)
- [JavaScript Execution](#javascript-execution)
- [Screenshots and Cookies](#screenshots-and-cookies)
- [Assertions with TestNG/JUnit](#assertions-with-testng-junit)
- [Page Object Model](#page-object-model)
- [Handling Alerts](#handling-alerts)
- [WebDriver Manager](#webdriver-manager)
- [Common Patterns](#common-patterns)
- [Debugging Tips](#debugging-tips)

## Setup and Configuration

### Maven Dependencies
```xml
<dependencies>
    <!-- Selenium Java -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.15.0</version>
    </dependency>
    
    <!-- WebDriverManager -->
    <dependency>
        <groupId>io.github.bonigarcia</groupId>
        <artifactId>webdrivermanager</artifactId>
        <version>5.5.3</version>
    </dependency>
    
    <!-- TestNG -->
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.8.0</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### Driver Setup

#### Using WebDriverManager (Recommended)
```java
import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class SeleniumSetup {
    public static void main(String[] args) {
        // Setup ChromeDriver
        WebDriverManager.chromedriver().setup();
        WebDriver driver = new ChromeDriver();
        
        // Your test code here
        
        driver.quit();
    }
}
```

#### Manual Setup
```java
System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
WebDriver driver = new ChromeDriver();
```

#### Different Browsers
```java
// Chrome
WebDriverManager.chromedriver().setup();
WebDriver chromeDriver = new ChromeDriver();

// Firefox
WebDriverManager.firefoxdriver().setup();
WebDriver firefoxDriver = new FirefoxDriver();

// Edge
WebDriverManager.edgedriver().setup();
WebDriver edgeDriver = new EdgeDriver();

// Safari (no WebDriverManager needed)
WebDriver safariDriver = new SafariDriver();
```

#### Driver Options
```java
import org.openqa.selenium.chrome.ChromeOptions;

ChromeOptions options = new ChromeOptions();
options.addArguments("--start-maximized");
options.addArguments("--incognito");
options.addArguments("--headless");
options.addArguments("--disable-extensions");
options.addArguments("--disable-notifications");

WebDriver driver = new ChromeDriver(options);
```

## WebDriver Basics

### Browser Navigation
```java
// Open URL
driver.get("https://www.example.com");

// Navigation
driver.navigate().to("https://www.example.com");
driver.navigate().back();
driver.navigate().forward();
driver.navigate().refresh();

// Get current URL
String currentUrl = driver.getCurrentUrl();

// Get page title
String title = driver.getTitle();

// Get page source
String pageSource = driver.getPageSource();
```

### Browser Window Management
```java
// Maximize window
driver.manage().window().maximize();

// Set window size
driver.manage().window().setSize(new Dimension(1366, 768));

// Set window position
driver.manage().window().setPosition(new Point(0, 0));

// Fullscreen
driver.manage().window().fullscreen();

// Get window size and position
Dimension size = driver.manage().window().getSize();
Point position = driver.manage().window().getPosition();
```

### Driver Management
```java
// Close current window/tab
driver.close();

// Quit the driver (closes all windows/tabs)
driver.quit();
```

## Locating Elements

### Finding Elements
```java
// By ID
WebElement elementById = driver.findElement(By.id("element-id"));

// By name
WebElement elementByName = driver.findElement(By.name("element-name"));

// By class name
WebElement elementByClass = driver.findElement(By.className("element-class"));

// By tag name
WebElement elementByTag = driver.findElement(By.tagName("div"));

// By link text
WebElement linkByText = driver.findElement(By.linkText("Click here"));

// By partial link text
WebElement linkByPartialText = driver.findElement(By.partialLinkText("Click"));

// By CSS selector
WebElement elementByCss = driver.findElement(By.cssSelector("div.container > p"));

// By XPath
WebElement elementByXPath = driver.findElement(By.xpath("//div[@class='container']/p"));

// Finding multiple elements (returns List<WebElement>)
List<WebElement> elements = driver.findElements(By.cssSelector(".item"));
```

### CSS Selector Cheatsheet
```
// Direct CSS Selectors
#id                 - select by ID
.classname          - select by class name
element             - select by tag name
element.class       - select by tag and class
element#id          - select by tag and ID

// Combinators
parent > child      - direct child
ancestor descendant - descendant
element + element   - adjacent sibling
element ~ element   - general sibling

// Attribute Selectors
[attribute]               - has attribute
[attribute="value"]       - exact match
[attribute*="value"]      - contains value
[attribute^="value"]      - starts with value
[attribute$="value"]      - ends with value

// Pseudo-classes
:first-child        - first child element
:last-child         - last child element
:nth-child(n)       - nth child element
:nth-of-type(n)     - nth element of its type
:not(selector)      - elements that don't match selector
```

### XPath Cheatsheet
```
// Absolute path (starts from root)
/html/body/div/p

// Relative path (starts from anywhere)
//div[@id='content']

// Element with specific attribute
//input[@name='username']

// Element with specific attribute value
//input[@type='submit']

// Element with text
//button[text()='Login']

// Element containing text
//div[contains(text(), 'Welcome')]

// Element with multiple conditions (AND)
//input[@type='text' and @name='username']

// Element with multiple conditions (OR)
//input[@type='text' or @type='password']

// Parent, child, sibling
//div[@id='parent']                // select the div
//div[@id='parent']/child::p       // select child p elements
//div[@id='parent']/..             // select parent of div
//div[@id='parent']/following-sibling::div  // select next div sibling 
//div[@id='parent']/preceding-sibling::div  // select previous div sibling

// Position
//ul/li[1]                         // first li element
//ul/li[last()]                    // last li element
//ul/li[position() < 3]            // first two li elements
```

## Browser Interactions

### Element Interactions
```java
// Clicking
WebElement button = driver.findElement(By.id("submit-button"));
button.click();

// Sending input
WebElement inputField = driver.findElement(By.name("username"));
inputField.sendKeys("user123");

// Clearing input
inputField.clear();

// Submit form
WebElement form = driver.findElement(By.id("login-form"));
form.submit();

// Get text
String text = driver.findElement(By.className("message")).getText();

// Get attribute
String href = driver.findElement(By.tagName("a")).getAttribute("href");

// Check states
boolean isEnabled = driver.findElement(By.id("button")).isEnabled();
boolean isSelected = driver.findElement(By.name("checkbox")).isSelected();
boolean isDisplayed = driver.findElement(By.className("element")).isDisplayed();

// Get CSS property
String color = driver.findElement(By.id("header")).getCssValue("color");

// Get element size and location
Dimension elementSize = driver.findElement(By.id("box")).getSize();
Point elementLocation = driver.findElement(By.id("box")).getLocation();
Rectangle rect = driver.findElement(By.id("box")).getRect();  // combines size and location
```

### Select Dropdown Interactions
```java
import org.openqa.selenium.support.ui.Select;

// Initialize Select object
WebElement dropdownElement = driver.findElement(By.id("dropdown"));
Select dropdown = new Select(dropdownElement);

// Select options
dropdown.selectByVisibleText("Option Text");
dropdown.selectByValue("option-value");
dropdown.selectByIndex(1);

// Get options
List<WebElement> allOptions = dropdown.getOptions();
WebElement firstSelectedOption = dropdown.getFirstSelectedOption();
List<WebElement> selectedOptions = dropdown.getAllSelectedOptions();

// Check if multiple select is allowed
boolean isMultiple = dropdown.isMultiple();

// Deselect (only for multi-select)
dropdown.deselectByVisibleText("Option Text");
dropdown.deselectByValue("option-value");
dropdown.deselectByIndex(1);
dropdown.deselectAll();
```

## Waits and Synchronization

### Implicit Wait
```java
// Sets a timeout for all element finds
driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
```

### Explicit Wait
```java
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

// Wait for element to be clickable
WebElement element = wait.until(ExpectedConditions.elementToBeClickable(By.id("button")));

// Wait for element to be visible
WebElement element = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("element")));

// Wait for element to be present in DOM
WebElement element = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("element")));

// Wait for element to be invisible
boolean isInvisible = wait.until(ExpectedConditions.invisibilityOfElementLocated(By.id("loader")));

// Wait for text to be present in element
boolean textPresent = wait.until(ExpectedConditions.textToBePresentInElementLocated(By.id("message"), "Success"));

// Wait for attribute to contain value
boolean hasAttribute = wait.until(ExpectedConditions.attributeContains(By.id("element"), "class", "active"));

// Wait for alert to be present
wait.until(ExpectedConditions.alertIsPresent());

// Wait for URL to contain
wait.until(ExpectedConditions.urlContains("dashboard"));

// Wait for page title to be
wait.until(ExpectedConditions.titleIs("Dashboard"));
```

### Fluent Wait
```java
Wait<WebDriver> fluentWait = new FluentWait<>(driver)
        .withTimeout(Duration.ofSeconds(30))
        .pollingEvery(Duration.ofMillis(500))
        .ignoring(NoSuchElementException.class)
        .ignoring(StaleElementReferenceException.class);

WebElement element = fluentWait.until(driver -> driver.findElement(By.id("element")));
```

### Custom Wait Conditions
```java
// Create custom wait condition
public static ExpectedCondition<Boolean> elementHasClass(final By locator, final String cssClass) {
    return new ExpectedCondition<Boolean>() {
        @Override
        public Boolean apply(WebDriver driver) {
            try {
                String classes = driver.findElement(locator).getAttribute("class");
                return classes != null && classes.contains(cssClass);
            } catch (Exception e) {
                return false;
            }
        }
        
        @Override
        public String toString() {
            return "element at " + locator + " to have class " + cssClass;
        }
    };
}

// Use custom wait condition
wait.until(elementHasClass(By.id("element"), "active"));
```

## Advanced Interactions

### Actions API
```java
import org.openqa.selenium.interactions.Actions;

Actions actions = new Actions(driver);

// Click
actions.click(element).perform();
actions.doubleClick(element).perform();
actions.contextClick(element).perform(); // Right-click

// Hover
actions.moveToElement(element).perform();

// Drag and drop
actions.dragAndDrop(sourceElement, targetElement).perform();
actions.dragAndDropBy(element, xOffset, yOffset).perform();

// Click and hold
actions.clickAndHold(element).perform();
actions.release().perform();

// Key actions
actions.keyDown(Keys.CONTROL).click(element).keyUp(Keys.CONTROL).perform();
actions.sendKeys(element, "Hello").perform();
actions.sendKeys(Keys.ENTER).perform();

// Chaining actions
actions
    .moveToElement(element1)
    .pause(Duration.ofMillis(500))
    .click()
    .moveToElement(element2)
    .click()
    .build()
    .perform();
```

### Keys and Keyboard Shortcuts
```java
import org.openqa.selenium.Keys;

// Common keyboard shortcuts
element.sendKeys(Keys.ENTER);
element.sendKeys(Keys.TAB);
element.sendKeys(Keys.ESCAPE);
element.sendKeys(Keys.SPACE);

// Function keys
element.sendKeys(Keys.F1); // F1-F12 available

// Navigation keys
element.sendKeys(Keys.HOME);
element.sendKeys(Keys.END);
element.sendKeys(Keys.PAGE_UP);
element.sendKeys(Keys.PAGE_DOWN);
element.sendKeys(Keys.ARROW_UP);
element.sendKeys(Keys.ARROW_DOWN);
element.sendKeys(Keys.ARROW_LEFT);
element.sendKeys(Keys.ARROW_RIGHT);

// Modifier keys combinations
element.sendKeys(Keys.chord(Keys.CONTROL, "a")); // Select all
element.sendKeys(Keys.chord(Keys.CONTROL, "c")); // Copy
element.sendKeys(Keys.chord(Keys.CONTROL, "v")); // Paste
element.sendKeys(Keys.chord(Keys.CONTROL, "x")); // Cut
element.sendKeys(Keys.chord(Keys.CONTROL, "z")); // Undo
```

## Frames and Windows

### Working with Frames
```java
// Switch to frame by index
driver.switchTo().frame(0);

// Switch to frame by name or ID
driver.switchTo().frame("frameName");

// Switch to frame by WebElement
WebElement frameElement = driver.findElement(By.id("frameId"));
driver.switchTo().frame(frameElement);

// Switch back to parent frame
driver.switchTo().parentFrame();

// Switch to default content (main document)
driver.switchTo().defaultContent();
```

### Working with Windows/Tabs
```java
// Get current window handle
String currentWindow = driver.getWindowHandle();

// Get all window handles
Set<String> allWindows = driver.getWindowHandles();

// Switch to a new window/tab
for (String windowHandle : allWindows) {
    if (!windowHandle.equals(currentWindow)) {
        driver.switchTo().window(windowHandle);
        break;
    }
}

// Open new tab and switch to it (Selenium 4)
driver.switchTo().newWindow(WindowType.TAB);

// Open new window and switch to it (Selenium 4)
driver.switchTo().newWindow(WindowType.WINDOW);

// Close current window/tab and switch back
driver.close();
driver.switchTo().window(currentWindow);
```

## JavaScript Execution

### Executing JavaScript
```java
import org.openqa.selenium.JavascriptExecutor;

JavascriptExecutor js = (JavascriptExecutor) driver;

// Execute JavaScript
js.executeScript("console.log('Hello from Selenium');");

// Return value from JavaScript
String title = (String) js.executeScript("return document.title;");
Long imgCount = (Long) js.executeScript("return document.images.length;");

// Pass arguments to JavaScript
String text = (String) js.executeScript("return arguments[0].innerText;", element);

// Scroll operations
js.executeScript("window.scrollBy(0, 500);"); // Scroll down 500px
js.executeScript("window.scrollTo(0, document.body.scrollHeight);"); // Scroll to bottom
js.executeScript("arguments[0].scrollIntoView(true);", element); // Scroll element into view

// Highlight element
js.executeScript(
    "arguments[0].style.border='3px solid red'", 
    element
);

// Click element using JavaScript
js.executeScript("arguments[0].click();", element);

// Set value for input
js.executeScript("arguments[0].value='test value';", inputElement);

// Get page load state
boolean isPageLoaded = (Boolean) js.executeScript("return document.readyState === 'complete';");
```

## Screenshots and Cookies

### Taking Screenshots
```java
import java.io.File;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.apache.commons.io.FileUtils;

// Take screenshot of entire page
File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(screenshot, new File("./screenshot.png"));

// Take screenshot of specific element (Selenium 4)
File elementScreenshot = element.getScreenshotAs(OutputType.FILE);
FileUtils.copyFile(elementScreenshot, new File("./element-screenshot.png"));

// Get screenshot as Base64 string
String screenshotBase64 = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BASE64);

// Get screenshot as byte array
byte[] screenshotBytes = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
```

### Managing Cookies
```java
// Get all cookies
Set<Cookie> cookies = driver.manage().getCookies();

// Get specific cookie
Cookie cookie = driver.manage().getCookieNamed("sessionId");

// Add cookie
Cookie newCookie = new Cookie("name", "value");
driver.manage().addCookie(newCookie);

// Adding cookie with more options
Cookie cookieWithOptions = new Cookie.Builder("name", "value")
    .domain("example.com")
    .path("/")
    .expiresOn(new Date(System.currentTimeMillis() + 3600 * 1000)) // 1 hour
    .isSecure(true)
    .isHttpOnly(true)
    .build();
driver.manage().addCookie(cookieWithOptions);

// Delete specific cookie
driver.manage().deleteCookie(cookie);
driver.manage().deleteCookieNamed("name");

// Delete all cookies
driver.manage().deleteAllCookies();
```

## Assertions with TestNG/JUnit

### TestNG Assertions
```java
import org.testng.Assert;

// Basic assertions
Assert.assertEquals(actual, expected, "Message on failure");
Assert.assertNotEquals(actual, expected);
Assert.assertTrue(condition, "Message on failure");
Assert.assertFalse(condition);
Assert.assertNull(object);
Assert.assertNotNull(object);

// Collection assertions
Assert.assertEquals(actualList, expectedList);
Assert.assertTrue(list.contains(element));

// String assertions
Assert.assertEquals(actual, expected, "Message");
Assert.assertTrue(string.contains(substring));
Assert.assertTrue(string.matches(regex));

// Soft assertions
SoftAssert softAssert = new SoftAssert();
softAssert.assertEquals(actual1, expected1);
softAssert.assertEquals(actual2, expected2);
// Will continue executing even if assertions fail
softAssert.assertAll(); // Must be called to verify assertions
```

### JUnit 5 Assertions
```java
import org.junit.jupiter.api.Assertions;

// Basic assertions
Assertions.assertEquals(expected, actual, "Message on failure");
Assertions.assertNotEquals(expected, actual);
Assertions.assertTrue(condition, "Message on failure");
Assertions.assertFalse(condition);
Assertions.assertNull(object);
Assertions.assertNotNull(object);

// Exception assertions
Assertions.assertThrows(ExpectedException.class, () -> {
    // Code that should throw exception
});

// Collection assertions
Assertions.assertIterableEquals(expectedList, actualList);
Assertions.assertTrue(list.contains(element));

// Grouped assertions (all executed)
Assertions.assertAll(
    () -> Assertions.assertEquals(expected1, actual1),
    () -> Assertions.assertEquals(expected2, actual2)
);
```

## Page Object Model

### Basic Page Object
```java
public class LoginPage {
    private WebDriver driver;
    
    // Locators
    private By usernameField = By.id("username");
    private By passwordField = By.id("password");
    private By loginButton = By.id("login-button");
    private By errorMessage = By.className("error-message");
    
    // Constructor
    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }
    
    // Page methods
    public void enterUsername(String username) {
        driver.findElement(usernameField).sendKeys(username);
    }
    
    public void enterPassword(String password) {
        driver.findElement(passwordField).sendKeys(password);
    }
    
    public void clickLoginButton() {
        driver.findElement(loginButton).click();
    }
    
    public String getErrorMessage() {
        return driver.findElement(errorMessage).getText();
    }
    
    // Business logic methods
    public HomePage loginSuccessfully(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        clickLoginButton();
        return new HomePage(driver); // Return the next page
    }
    
    public LoginPage loginWithInvalidCredentials(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        clickLoginButton();
        return this; // Return same page for failed login
    }
}
```

### Page Factory Model
```java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class LoginPage {
    private WebDriver driver;
    
    // Elements using annotations
    @FindBy(id = "username")
    private WebElement usernameField;
    
    @FindBy(id = "password")
    private WebElement passwordField;
    
    @FindBy(id = "login-button")
    private WebElement loginButton;
    
    @FindBy(className = "error-message")
    private WebElement errorMessage;
    
    // Constructor with initialization
    public LoginPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }
    
    // Page methods
    public void enterUsername(String username) {
        usernameField.sendKeys(username);
    }
    
    public void enterPassword(String password) {
        passwordField.sendKeys(password);
    }
    
    public void clickLoginButton() {
        loginButton.click();
    }
    
    public String getErrorMessage() {
        return errorMessage.getText();
    }
    
    // Business logic
    public HomePage loginSuccessfully(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        clickLoginButton();
        return new HomePage(driver);
    }
}
```

### Advanced FindBy Examples
```java
// Different locators
@FindBy(id = "elementId")
private WebElement elementById;

@FindBy(name = "elementName")
private WebElement elementByName;

@FindBy(className = "class-name")
private WebElement elementByClassName;

@FindBy(tagName = "div")
private WebElement elementByTag;

@FindBy(linkText = "Click Here")
private WebElement elementByLinkText;

@FindBy(partialLinkText = "Click")
private WebElement elementByPartialLinkText;

@FindBy(css = "div.container > p")
private WebElement elementByCss;

@FindBy(xpath = "//div[@class='container']/p")
private WebElement elementByXPath;

// Find multiple elements
@FindBy(css = ".item")
private List<WebElement> multipleElements;

// Using multiple conditions with @FindBys
@FindBys({
    @FindBy(id = "parent"),
    @FindBy(className = "child")
})
private WebElement nestedElement; // Equivalent to CSS: #parent .child

// Using OR condition with @FindAll
@FindAll({
    @FindBy(id = "element1"),
    @FindBy(name = "element2")
})
private WebElement eitherElement; // Matches either ID or name
```

## Handling Alerts

### Alert Handling
```java
import org.openqa.selenium.Alert;

// Switch to alert
Alert alert = driver.switchTo().alert();

// Get alert text
String alertText = alert.getText();

// Accept alert (click OK)
alert.accept();

// Dismiss alert (click Cancel)
alert.dismiss();

// Send input to prompt alert
alert.sendKeys("Text input");

// Wait for alert to be present
Alert alert = wait.until(ExpectedConditions.alertIsPresent());
```

## WebDriver Manager

### WebDriverManager Options
```java
// Basic setup
WebDriverManager.chromedriver().setup();

// Specify version
WebDriverManager.chromedriver().driverVersion("111.0.5563.64").setup();

// Using latest version
WebDriverManager.chromedriver().useBetaVersions().setup();

// Architecture
WebDriverManager.chromedriver().arch64().setup();
WebDriverManager.chromedriver().arch32().setup();

// Proxy configuration
WebDriverManager.chromedriver()
    .proxy("https://user:pass@server:port")
    .setup();

// Cache options
WebDriverManager.chromedriver().clearDriverCache().setup();
WebDriverManager.chromedriver().forceDownload().setup();

// Timeout configuration
WebDriverManager.chromedriver()
    .timeout(30)  // seconds for connection/read timeout
    .setup();

// Custom download path
WebDriverManager.chromedriver()
    .targetPath("/path/to/save/driver")
    .setup();
```

## Common Patterns

### Taking Screenshot on Failure
```java
@Test
public void testExample() {
    try {
        // Test code here
        WebElement element = driver.findElement(By.id("non-existent"));
    } catch (Exception e) {
        takeScreenshot("test-failure");
        throw e;  // rethrow to fail the test
    }
}

private void takeScreenshot(String fileName) {
    try {
        File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        FileUtils.copyFile(screenshot, new File("./screenshots/" + fileName + "_" + 
            System.currentTimeMillis() + ".png"));
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

### Wait Wrapper Method
```java
// Generic wait wrapper
public WebElement waitForElement(By locator, int timeoutInSeconds) {
    WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(timeoutInSeconds));
    return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
}

// Usage
WebElement element = waitForElement(By.id("dynamicElement"), 10);
element.click();
```

### Base Test Class
```java
public class BaseTest {
    protected WebDriver driver;
    protected WebDriverWait wait;
    
    @BeforeMethod
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }
    
    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
    
    // Common utilities
    protected void navigateTo(String url) {
        driver.get(url);
    }
    
    protected WebElement waitForElement(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }
    
    protected void click(By locator) {
        waitForElement(locator).click();
    }
    
    protected void type(By locator, String text) {
        WebElement element = waitForElement(locator);
        element.clear();
        element.sendKeys(text);
    }
    
    protected String getText(By locator) {
        return waitForElement(locator).getText();
    }
    
    protected void takeScreenshot(String fileName) {
        try {
            File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(screenshot, new File("./screenshots/" + fileName + "_" + 
                System.currentTimeMillis() + ".png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Data Provider Example (TestNG)
```java
@DataProvider(name = "loginData")
public Object[][] provideLoginData() {
    return new Object[][] {
        {"user1", "pass1", true},
        {"user2", "wrongpass", false},
        {"invaliduser", "pass", false}
    };
}

@Test(dataProvider = "loginData")
public void testLogin(String username, String password, boolean shouldPass) {
    LoginPage loginPage = new LoginPage(driver);
    driver.get("https://example.com/login");
    
    loginPage.enterUsername(username);
    loginPage.enterPassword(password);
    loginPage.clickLoginButton();
    
    if (shouldPass) {
        Assert.assertEquals(driver.getTitle(), "Dashboard");
    } else {
        Assert.assertTrue(loginPage.getErrorMessage().contains("Invalid credentials"));
    }
}
```

## Debugging Tips

### Handling StaleElementReferenceException
```java
public WebElement findElementWithRetry(By locator, int maxAttempts) {
    int attempts = 0;
    while (attempts < maxAttempts) {
        try {
            return driver.findElement(locator);
        } catch (StaleElementReferenceException e) {
            attempts++;
            if (attempts == maxAttempts) {
                throw e;
            }
        }
    }
    throw new NoSuchElementException("Element not found after " + maxAttempts + " attempts");
}
```

### Highlighting Elements
```java
public void highlightElement(WebElement element) {
    JavascriptExecutor js = (JavascriptExecutor) driver;
    String originalStyle = element.getAttribute("style");
    
    js.executeScript(
        "arguments[0].setAttribute('style', 'border: 2px solid red; background: yellow;');", 
        element
    );
    
    try {
        Thread.sleep(500); // Pause to see the highlight
    } catch (InterruptedException e) {
        Thread.currentThread().interrupt();
    }
    
    js.executeScript(
        "arguments[0].setAttribute('style', '" + originalStyle + "');", 
        element
    );
}

// Usage
WebElement element = driver.findElement(By.id("element"));
highlightElement(element);
element.click();
```
