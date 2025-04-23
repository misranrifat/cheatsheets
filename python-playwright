# Python Playwright Cheatsheet

## Installation & Setup

```bash
# Install Playwright
pip install playwright

# Install browser binaries
playwright install
```

### Basic Script Structure

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    
    # Your code here
    
    browser.close()
```

### Async Version

```python
from playwright.async_api import async_playwright
import asyncio

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        
        # Your async code here
        
        await browser.close()

asyncio.run(main())
```

## Browser Launch Options

```python
# Headful mode (visible browser)
browser = p.chromium.launch(headless=False)

# Slow motion mode (slows down operations)
browser = p.chromium.launch(slow_mo=100)  # milliseconds

# With specific arguments
browser = p.chromium.launch(
    args=["--disable-web-security"]
)

# Different browsers
chromium = p.chromium.launch()
firefox = p.firefox.launch()
webkit = p.webkit.launch()
```

## Context & Pages

```python
# Create a browser context (like an incognito session)
context = browser.new_context(
    viewport={"width": 1920, "height": 1080},
    user_agent="Custom User Agent",
    locale="en-US",
    timezone_id="America/New_York",
    geolocation={"latitude": 40.7128, "longitude": -74.0060},
    permissions=["geolocation"]
)

# Create multiple pages in the same context
page1 = context.new_page()
page2 = context.new_page()

# Close context when done
context.close()
```

## Navigation

```python
# Navigate to URL
page.goto("https://example.com")

# With options
page.goto("https://example.com", 
          wait_until="networkidle",  # "load", "domcontentloaded", "networkidle"
          timeout=30000)  # milliseconds

# Navigation history
page.go_back()
page.go_forward()
page.reload()

# Get current URL
current_url = page.url
```

## Waiting

```python
# Wait for specific time
page.wait_for_timeout(1000)  # milliseconds

# Wait for navigation to complete
with page.expect_navigation():
    page.click("a.nav-link")

# Wait for element to be visible
page.wait_for_selector("div.loaded", state="visible")

# Wait for element to be hidden
page.wait_for_selector(".spinner", state="hidden")

# Wait for network request
with page.expect_request("**/api/data") as request_info:
    page.click(".load-data-button")
request = request_info.value

# Wait for response
with page.expect_response("**/api/data") as response_info:
    page.click(".load-data-button")
response = response_info.value

# Wait for page load state
page.wait_for_load_state("networkidle")  # "load", "domcontentloaded", "networkidle"

# Wait for function to return true
page.wait_for_function("() => document.querySelector('.status').textContent === 'Ready'")
```

## Selectors

```python
# Basic selectors
page.click("div")  # Tag selector
page.click(".class-name")  # Class selector
page.click("#id")  # ID selector
page.click("[attribute=value]")  # Attribute selector
page.click("div.class")  # Combined selector

# Text selectors
page.click("text=Click me")  # Element containing this text
page.click("text=/Submit|Cancel/")  # Text matching regex

# CSS and XPath
page.click("css=button.primary")
page.click("xpath=//button[contains(text(), 'Submit')]")

# Combining selectors
page.click(".form-group >> .button")  # Descendant
page.click(".form >> nth=0")  # First match
page.click(".item >> visible=true")  # Only visible elements

# React/Vue selectors
page.click("_react=SubmitButton")
page.click("_vue=submit-button")

# Advanced selectors
page.click("article:has(.highlighted)")  # Element containing another
page.click("article:has-text('Featured')")  # Element with specific text
page.click("#menu :nth-match(:text('Item'), 2)")  # Second item with text
```

## Reading Elements

```python
# Get text content
text = page.text_content(".message")

# Get inner text (excluding hidden elements)
text = page.inner_text(".message")

# Get HTML
html = page.inner_html(".container")

# Get attribute
href = page.get_attribute("a.link", "href")

# Count elements
count = page.locator(".item").count()

# Check if element exists
is_visible = page.is_visible(".notification")
is_hidden = page.is_hidden(".notification")
is_enabled = page.is_enabled("button.submit")
is_checked = page.is_checked("input[type=checkbox]")
is_editable = page.is_editable("input.name")

# Get element properties
value = page.evaluate("el => el.value", page.locator("input"))
```

## Actions

```python
# Click
page.click("button.submit")
page.click("button", modifiers=["Shift"])  # With modifiers
page.click("button", button="right")  # Right-click
page.click("button", position={"x": 10, "y": 15})  # Click at position
page.dblclick("button.edit")  # Double-click

# Type and clear
page.fill("input#name", "John Doe")  # Clear and type
page.type("input#search", "query")  # Type without clearing
page.clear("input#username")  # Clear field

# Press keys
page.press("input", "Enter")
page.press("body", "Control+a")  # Select all
page.keyboard.press("Control+c")  # Copy
page.keyboard.type("Hello world")  # Type with keyboard

# Drag and drop
page.drag_and_drop("#source", "#target")

# Check/uncheck
page.check("input[type=checkbox]")
page.uncheck("input[type=checkbox]")

# Select options
page.select_option("select#country", "US")  # By value
page.select_option("select#country", label="United States")  # By label
page.select_option("select#colors", ["red", "blue"])  # Multiple options

# File upload
page.set_input_files("input[type=file]", "path/to/file.pdf")
page.set_input_files("input[type=file]", ["file1.jpg", "file2.jpg"])  # Multiple files

# Focus element
page.focus("input#email")

# Hover
page.hover(".tooltip")
```

## Assertions

```python
# Install pytest-playwright for better assertions
# pip install pytest-playwright

# Expect library
from playwright.sync_api import expect

# Element state
expect(page.locator(".status")).to_be_visible()
expect(page.locator(".spinner")).to_be_hidden()
expect(page.locator("button")).to_be_enabled()
expect(page.locator("button")).to_be_disabled()
expect(page.locator("input[type=checkbox]")).to_be_checked()
expect(page.locator("#terms")).not_to_be_checked()
expect(page.locator("input")).to_be_editable()
expect(page.locator("input")).to_be_empty()
expect(page.locator("input")).to_be_focused()

# Element content
expect(page.locator("h1")).to_have_text("Welcome")
expect(page.locator("h1")).to_contain_text("Welcome")
expect(page.locator("div")).to_have_text(/Hello \w+/)  # Regex
expect(page.locator("img")).to_have_attribute("alt", "Logo")
expect(page.locator("div")).to_have_class("highlighted")
expect(page.locator("img")).to_have_css("border-radius", "50%")
expect(page.locator("ul")).to_have_count(5)
expect(page.locator("div")).to_have_id("main")
expect(page.locator("select")).to_have_values(["option1", "option2"])
expect(page.locator("input")).to_have_value("example")

# Page assertions
expect(page).to_have_title("My Page")
expect(page).to_have_url("https://example.com")
```

## Screenshots & Video

```python
# Take screenshot
page.screenshot(path="screenshot.png")
page.screenshot(path="full.png", full_page=True)  # Full page
page.locator(".element").screenshot(path="element.png")  # Element screenshot

# Start video recording (context level)
context = browser.new_context(record_video_dir="videos/")

# Save video
context.close()  # Video is saved on context close
```

## Cookies & Storage

```python
# Get cookies
cookies = context.cookies()

# Set cookies
context.add_cookies([
    {
        "name": "sessionid",
        "value": "123456",
        "domain": "example.com",
        "path": "/",
        "expires": -1,  # Session cookie
        "httpOnly": True,
        "secure": True,
        "sameSite": "Lax"  # "Strict", "Lax", or "None"
    }
])

# Clear cookies
context.clear_cookies()

# Local storage
page.evaluate("localStorage.setItem('key', 'value')")
value = page.evaluate("localStorage.getItem('key')")
page.evaluate("localStorage.clear()")

# Session storage
page.evaluate("sessionStorage.setItem('key', 'value')")
```

## Network

```python
# Intercept and modify requests
def handle_route(route, request):
    if request.resource_type == "image":
        route.abort()  # Block images
    elif "api/users" in request.url:
        # Modify request
        route.continue_(
            method="POST",
            headers={**request.headers, "Authorization": "Bearer token"},
            post_data="modified data"
        )
    elif "api/data" in request.url:
        # Mock response
        route.fulfill(
            status=200,
            content_type="application/json",
            body=json.dumps({"mocked": True})
        )
    else:
        route.continue_()  # Allow request to proceed normally

page.route("**/*", handle_route)

# Stop route interception
page.unroute("**/*")

# Listen to network events
page.on("request", lambda request: print(">>", request.method, request.url))
page.on("response", lambda response: print("<<", response.status, response.url))
```

## Authentication

```python
# Basic approach - perform login
page.goto("https://example.com/login")
page.fill("input#username", "user")
page.fill("input#password", "pass")
page.click("button[type=submit]")

# Save authentication state
storage_state = context.storage_state()
with open("auth.json", "w") as f:
    f.write(json.dumps(storage_state))

# Reuse authentication
context = browser.new_context(storage_state="auth.json")
```

## Page Events

```python
# Listen for page events
page.on("dialog", lambda dialog: dialog.accept())  # Handle dialogs
page.on("console", lambda msg: print(f"Console: {msg.text})"))  # Log console messages
page.on("pageerror", lambda err: print(f"Error: {err}"))  # Catch page errors
page.on("download", lambda download: print(f"Download: {download.path()}"))  # Handle downloads
page.on("filechooser", lambda file_chooser: file_chooser.set_files("myfile.pdf"))
```

## JavaScript Execution

```python
# Evaluate JavaScript in page context
result = page.evaluate("1 + 2")
document_title = page.evaluate("document.title")
element_count = page.evaluate("document.querySelectorAll('.item').length")

# Pass arguments to JavaScript
result = page.evaluate("([x, y]) => x + y", [1, 2])

# Evaluate on element
text = page.evaluate("el => el.textContent", page.locator(".message"))

# Evaluate function
page.evaluate_function("""() => {
    window.scrollTo(0, document.body.scrollHeight);
}""")
```

## Mobile Emulation

```python
# Create context with mobile device settings
iphone = p.devices["iPhone 12"]
context = browser.new_context(
    **iphone,
    locale="en-US",
)

# Emulate specific device settings
context = browser.new_context(
    viewport={"width": 375, "height": 812},
    device_scale_factor=2,
    is_mobile=True,
    has_touch=True,
)

# Emulate orientation
context = browser.new_context(
    viewport={"width": 375, "height": 812},
    screen={"width": 375, "height": 812},
)
page = context.new_page()
page.set_viewport_size({"width": 812, "height": 375})  # Landscape
```

## Testing with pytest-playwright

```python
# In test_example.py
from playwright.sync_api import Page, expect

def test_homepage_title(page: Page):
    page.goto("https://example.com")
    expect(page).to_have_title("Example Domain")

def test_click_button(page: Page):
    page.goto("https://example.com")
    page.click("button#submit")
    expect(page.locator(".success")).to_be_visible()
```

Run tests:
```bash
# Install pytest-playwright
pip install pytest-playwright

# Run tests (basic)
pytest

# Run with specific browser
pytest --browser chromium
pytest --browser firefox --browser webkit

# Run headed (visible browser)
pytest --headed

# Run slower
pytest --slowmo 500

# Debug mode
pytest --browser chromium --headed --slowmo 500 --video on
```

## Debugging

```python
# Open inspector
playwright show-trace trace.zip

# Generate trace
browser = p.chromium.launch(headless=False)
context = browser.new_context(record_har_path="recording.har")
page = context.new_page()

# With trace recording
context = browser.new_context()
await context.tracing.start(screenshots=True, snapshots=True)

# Do your actions...

# Stop and save trace
await context.tracing.stop(path="trace.zip")

# Pause execution for debugging
page.pause()
```

## Parallel Execution

```python
from playwright.sync_api import sync_playwright
import concurrent.futures

def run_browser(browser_type):
    with sync_playwright() as p:
        browser_obj = getattr(p, browser_type)
        browser = browser_obj.launch()
        page = browser.new_page()
        page.goto("https://example.com")
        title = page.title()
        browser.close()
        return f"{browser_type}: {title}"

with concurrent.futures.ThreadPoolExecutor() as executor:
    browsers = ["chromium", "firefox", "webkit"]
    results = executor.map(run_browser, browsers)
    
    for result in results:
        print(result)
```
