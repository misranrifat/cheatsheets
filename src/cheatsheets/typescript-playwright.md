# TypeScript Playwright Cheatsheet

## Table of Contents
- [Installation and Setup](#installation-and-setup)
- [Basic Structure](#basic-structure)
- [Configuration](#configuration)
- [Browser and Context Management](#browser-and-context-management)
- [Navigation](#navigation)
- [Locators](#locators)
- [Actions](#actions)
- [Assertions](#assertions)
- [Waits](#waits)
- [Network Interception](#network-interception)
- [Screenshots and Videos](#screenshots-and-videos)
- [Debugging](#debugging)
- [Page Object Model](#page-object-model)
- [Testing with Playwright Test Runner](#testing-with-playwright-test-runner)
- [Advanced Features](#advanced-features)
  - [Multi-Browser Parallel Execution](#multi-browser-parallel-execution)
  - [Mobile Device Testing](#mobile-device-testing)
  - [CI/CD Integration](#cicd-integration)
    - [GitHub Actions](#github-actions)
    - [GitLab CI/CD](#gitlab-cicd)
    - [Jenkins Pipeline](#jenkins-pipeline)
    - [Allure Report Integration](#allure-report-integration)
  - [API Testing](#api-testing)

## Installation and Setup

### Install Playwright
```bash
# Create new project with TypeScript
npm init playwright@latest

# Or add to existing project
npm install -D @playwright/test
npx playwright install
```

### Install Specific Browsers
```bash
# Install all browsers
npx playwright install

# Install specific browser
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit

# Install with dependencies
npx playwright install --with-deps
```

### TypeScript Configuration
```json
{
  "compilerOptions": {
    "target": "ES2019",
    "module": "commonjs",
    "moduleResolution": "node",
    "esModuleInterop": true,
    "strict": true,
    "skipLibCheck": true,
    "types": ["node", "@playwright/test"]
  }
}
```

## Basic Structure

### Simple Script
```typescript
import { chromium, Browser, Page } from 'playwright';

(async () => {
  const browser: Browser = await chromium.launch();
  const page: Page = await browser.newPage();

  await page.goto('https://example.com');
  console.log(await page.title());

  await browser.close();
})();
```

### With Browser Context
```typescript
import { chromium } from 'playwright';

(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  await page.goto('https://example.com');

  await context.close();
  await browser.close();
})();
```

## Configuration

### playwright.config.ts
```typescript
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',

  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 10000,
    navigationTimeout: 30000,
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],

  webServer: {
    command: 'npm run start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

## Browser and Context Management

### Launch Options
```typescript
import { chromium, LaunchOptions } from 'playwright';

const launchOptions: LaunchOptions = {
  headless: false,           // Run in headed mode
  slowMo: 50,               // Slow down by 50ms
  devtools: true,           // Open devtools
  args: ['--start-maximized'],
  timeout: 30000,
};

const browser = await chromium.launch(launchOptions);
```

### Browser Context Options
```typescript
import { Browser, BrowserContextOptions } from 'playwright';

const contextOptions: BrowserContextOptions = {
  viewport: { width: 1920, height: 1080 },
  userAgent: 'Custom User Agent',
  locale: 'en-US',
  timezoneId: 'America/New_York',
  geolocation: { latitude: 40.7128, longitude: -74.0060 },
  permissions: ['geolocation', 'notifications'],
  storageState: 'auth.json',  // Load saved auth state
  colorScheme: 'dark',
  recordVideo: {
    dir: 'videos/',
    size: { width: 1280, height: 720 }
  },
};

const context = await browser.newContext(contextOptions);
```

### Multiple Contexts and Pages
```typescript
// Create isolated contexts
const context1 = await browser.newContext();
const context2 = await browser.newContext();

// Multiple pages in same context
const page1 = await context1.newPage();
const page2 = await context1.newPage();

// Handle new pages (e.g., popups)
context.on('page', async (page) => {
  console.log('New page opened:', await page.url());
});

// Wait for new page
const [newPage] = await Promise.all([
  context.waitForEvent('page'),
  page.click('a[target="_blank"]')
]);
```

## Navigation

### Basic Navigation
```typescript
// Navigate to URL
await page.goto('https://example.com');

// With options
await page.goto('https://example.com', {
  waitUntil: 'networkidle',  // 'load' | 'domcontentloaded' | 'networkidle'
  timeout: 30000,
});

// Get current URL
const url = page.url();

// Navigation methods
await page.goBack();
await page.goForward();
await page.reload();
```

## Locators

### Modern Locator API
```typescript
// Recommended approach - use locators
const button = page.locator('button.submit');
const input = page.locator('input[name="username"]');

// By role (accessibility-first)
const submitButton = page.getByRole('button', { name: 'Submit' });
const heading = page.getByRole('heading', { name: 'Welcome' });
const link = page.getByRole('link', { name: 'Learn more' });
const checkbox = page.getByRole('checkbox', { name: 'Accept terms' });

// By text
const element = page.getByText('Click me');
const exactText = page.getByText('Exact text', { exact: true });
const regexText = page.getByText(/submit/i);

// By label (for form inputs)
const nameInput = page.getByLabel('Full name');
const emailInput = page.getByLabel(/email/i);

// By placeholder
const searchInput = page.getByPlaceholder('Search...');

// By test ID
const submitBtn = page.getByTestId('submit-button');

// By title
const tooltip = page.getByTitle('More information');

// By alt text (for images)
const logo = page.getByAltText('Company logo');
```

### Locator Filters and Chains
```typescript
// Filter locators
const activeButton = page.locator('button').filter({ hasText: 'Submit' });
const visibleInput = page.locator('input').filter({ has: page.locator('.icon') });

// Chain locators
const form = page.locator('form');
const submitButton = form.locator('button[type="submit"]');

// Nth element
const firstItem = page.locator('.item').first();
const lastItem = page.locator('.item').last();
const thirdItem = page.locator('.item').nth(2);

// Count elements
const count = await page.locator('.item').count();

// Get all elements
const items = await page.locator('.item').all();
for (const item of items) {
  console.log(await item.textContent());
}
```

### CSS and XPath Selectors
```typescript
// CSS selectors
page.locator('div.class');
page.locator('#id');
page.locator('[data-testid="submit"]');
page.locator('button:visible');
page.locator('button:has-text("Submit")');

// XPath selectors
page.locator('xpath=//button');
page.locator('xpath=//button[contains(text(), "Submit")]');

// Descendant combinator
page.locator('form >> button');
```

## Actions

### Mouse Actions
```typescript
// Click
await page.locator('button').click();

// Click with options
await page.locator('button').click({
  button: 'right',        // 'left' | 'right' | 'middle'
  clickCount: 2,          // Double click
  delay: 100,             // Hold for 100ms
  position: { x: 10, y: 5 },
  modifiers: ['Control'], // ['Alt', 'Control', 'Meta', 'Shift']
  force: true,            // Skip actionability checks
});

// Hover
await page.locator('.menu').hover();

// Drag and drop
await page.locator('#source').dragTo(page.locator('#target'));

// Mouse movements
await page.mouse.move(100, 200);
await page.mouse.down();
await page.mouse.move(300, 400);
await page.mouse.up();
```

### Keyboard Actions
```typescript
// Type text (clears input first)
await page.locator('input').fill('Hello World');

// Press a key
await page.locator('input').press('Enter');
await page.keyboard.press('ArrowDown');

// Key combinations
await page.keyboard.press('Control+A');
await page.keyboard.press('Control+C');
await page.keyboard.press('Meta+V');  // Command on Mac

// Type without clearing
await page.locator('input').type('Additional text', { delay: 100 });

// Advanced keyboard control
await page.keyboard.down('Shift');
await page.keyboard.press('ArrowRight');
await page.keyboard.press('ArrowRight');
await page.keyboard.up('Shift');
```

### Form Actions
```typescript
// Fill input
await page.locator('input[name="email"]').fill('user@example.com');

// Clear input
await page.locator('input[name="email"]').clear();

// Check/uncheck
await page.locator('input[type="checkbox"]').check();
await page.locator('input[type="checkbox"]').uncheck();
await page.locator('input[type="checkbox"]').setChecked(true);

// Radio buttons
await page.getByRole('radio', { name: 'Option 1' }).check();

// Select dropdown
await page.locator('select').selectOption('value');
await page.locator('select').selectOption({ label: 'Option Label' });
await page.locator('select').selectOption({ index: 2 });
await page.locator('select').selectOption(['value1', 'value2']);  // Multiple

// File upload
await page.locator('input[type="file"]').setInputFiles('path/to/file.pdf');
await page.locator('input[type="file"]').setInputFiles([
  'file1.pdf',
  'file2.pdf'
]);

// Upload from buffer
await page.locator('input[type="file"]').setInputFiles({
  name: 'file.txt',
  mimeType: 'text/plain',
  buffer: Buffer.from('File content'),
});
```

## Assertions

### Playwright Test Assertions
```typescript
import { test, expect } from '@playwright/test';

test('example test', async ({ page }) => {
  await page.goto('https://example.com');

  // Element visibility
  await expect(page.locator('.status')).toBeVisible();
  await expect(page.locator('.spinner')).toBeHidden();
  await expect(page.locator('.spinner')).not.toBeVisible();

  // Element state
  await expect(page.locator('button')).toBeEnabled();
  await expect(page.locator('button')).toBeDisabled();
  await expect(page.locator('input[type="checkbox"]')).toBeChecked();
  await expect(page.locator('input')).toBeEditable();
  await expect(page.locator('input')).toBeFocused();
  await expect(page.locator('input')).toBeEmpty();

  // Element content
  await expect(page.locator('h1')).toHaveText('Welcome');
  await expect(page.locator('h1')).toContainText('Wel');
  await expect(page.locator('h1')).toHaveText(/welcome/i);
  await expect(page.locator('div')).toHaveHTML('<span>Text</span>');

  // Element attributes
  await expect(page.locator('img')).toHaveAttribute('alt', 'Logo');
  await expect(page.locator('div')).toHaveClass('active');
  await expect(page.locator('div')).toHaveClass(/active/);
  await expect(page.locator('div')).toHaveCSS('color', 'rgb(255, 0, 0)');
  await expect(page.locator('div')).toHaveId('main');
  await expect(page.locator('input')).toHaveValue('test');
  await expect(page.locator('select')).toHaveValues(['option1', 'option2']);

  // Element count
  await expect(page.locator('.item')).toHaveCount(5);

  // Page assertions
  await expect(page).toHaveTitle('Page Title');
  await expect(page).toHaveTitle(/Title/);
  await expect(page).toHaveURL('https://example.com');
  await expect(page).toHaveURL(/example/);

  // Custom timeout
  await expect(page.locator('button')).toBeVisible({ timeout: 5000 });
});
```

### Soft Assertions
```typescript
test('soft assertions', async ({ page }) => {
  await page.goto('https://example.com');

  // Continue test even if assertion fails
  await expect.soft(page.locator('h1')).toHaveText('Wrong text');
  await expect.soft(page.locator('h2')).toHaveText('Also wrong');

  // Test continues and reports all failures at the end
});
```

## Waits

### Auto-Waiting
```typescript
// Playwright auto-waits for elements before actions
await page.locator('button').click();  // Waits for button to be actionable

// Explicit waits
await page.locator('.loading').waitFor({ state: 'hidden' });
await page.locator('.content').waitFor({ state: 'visible' });
await page.locator('.element').waitFor({ state: 'attached' });
await page.locator('.element').waitFor({ state: 'detached' });

// Wait for URL
await page.waitForURL('**/dashboard');
await page.waitForURL(/dashboard/);
await page.waitForURL('https://example.com/dashboard', {
  timeout: 30000,
  waitUntil: 'networkidle',
});

// Wait for load state
await page.waitForLoadState('load');           // Page load event
await page.waitForLoadState('domcontentloaded');
await page.waitForLoadState('networkidle');    // No network connections

// Wait for function
await page.waitForFunction(() => window.innerWidth < 1000);
await page.waitForFunction(() => document.querySelector('.loaded'));

// Wait for timeout (avoid if possible)
await page.waitForTimeout(1000);
```

### Wait for Events
```typescript
// Wait for navigation
await Promise.all([
  page.waitForNavigation(),
  page.click('a.link'),
]);

// Wait for response
const [response] = await Promise.all([
  page.waitForResponse('**/api/users'),
  page.click('button.load'),
]);
console.log(await response.json());

// Wait for request
const [request] = await Promise.all([
  page.waitForRequest('**/api/submit'),
  page.click('button.submit'),
]);

// Wait for selector (prefer locator.waitFor instead)
await page.waitForSelector('.element', { state: 'visible' });
```

## Network Interception

### Route Handling
```typescript
// Block images
await page.route('**/*.{png,jpg,jpeg,svg}', route => route.abort());

// Mock API response
await page.route('**/api/users', async route => {
  await route.fulfill({
    status: 200,
    contentType: 'application/json',
    body: JSON.stringify([
      { id: 1, name: 'John Doe' },
      { id: 2, name: 'Jane Smith' }
    ]),
  });
});

// Modify request
await page.route('**/api/submit', async route => {
  const request = route.request();
  const postData = request.postDataJSON();

  await route.continue({
    method: 'POST',
    postData: JSON.stringify({ ...postData, modified: true }),
    headers: {
      ...request.headers(),
      'X-Custom-Header': 'value',
    },
  });
});

// Continue with modified headers
await page.route('**/*', async route => {
  await route.continue({
    headers: {
      ...route.request().headers(),
      'Authorization': 'Bearer token',
    },
  });
});

// Conditional routing
await page.route('**/api/**', async route => {
  if (route.request().method() === 'GET') {
    await route.continue();
  } else {
    await route.abort();
  }
});
```

### Network Monitoring
```typescript
// Listen for requests
page.on('request', request => {
  console.log('>>', request.method(), request.url());
});

// Listen for responses
page.on('response', response => {
  console.log('<<', response.status(), response.url());
});

// Get request/response details
const [response] = await Promise.all([
  page.waitForResponse('**/api/data'),
  page.click('button.load'),
]);

const status = response.status();
const headers = response.headers();
const body = await response.json();
const text = await response.text();
const buffer = await response.body();
```

## Screenshots and Videos

### Screenshots
```typescript
// Full page screenshot
await page.screenshot({ path: 'screenshot.png', fullPage: true });

// Viewport screenshot
await page.screenshot({ path: 'viewport.png' });

// Element screenshot
await page.locator('.header').screenshot({ path: 'header.png' });

// Screenshot options
await page.screenshot({
  path: 'screenshot.png',
  type: 'jpeg',              // 'png' | 'jpeg'
  quality: 90,               // 0-100 for JPEG
  omitBackground: true,      // Transparent background
  clip: { x: 0, y: 0, width: 500, height: 500 },
  animations: 'disabled',    // Disable CSS animations
  caret: 'hide',            // Hide text caret
  scale: 'device',          // 'css' | 'device'
});

// Screenshot to buffer
const buffer = await page.screenshot();
```

### Videos
```typescript
// Enable video recording in context
const context = await browser.newContext({
  recordVideo: {
    dir: 'videos/',
    size: { width: 1280, height: 720 },
  },
});

const page = await context.newPage();

// Perform actions...

// Close page to save video
await page.close();

// Get video path
const path = await page.video()?.path();
```

## Debugging

### Playwright Inspector
```bash
# Run with inspector
PWDEBUG=1 npx playwright test

# Or in code
await page.pause();
```

### Tracing
```typescript
import { test } from '@playwright/test';

test('example with tracing', async ({ browser }) => {
  const context = await browser.newContext();

  // Start tracing
  await context.tracing.start({
    screenshots: true,
    snapshots: true,
    sources: true,
  });

  const page = await context.newPage();
  await page.goto('https://example.com');

  // Stop and save trace
  await context.tracing.stop({ path: 'trace.zip' });
});
```

```bash
# View trace
npx playwright show-trace trace.zip
```

### Console and Errors
```typescript
// Listen for console messages
page.on('console', msg => {
  console.log(`Console ${msg.type()}: ${msg.text()}`);
});

// Listen for page errors
page.on('pageerror', exception => {
  console.error('Page error:', exception);
});

// Evaluate in console
const result = await page.evaluate(() => window.innerHeight);
const title = await page.evaluate(() => document.title);

// With TypeScript typing
const height = await page.evaluate<number>(() => window.innerHeight);
```

## Page Object Model

### Page Object Class
```typescript
import { Page, Locator } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly usernameInput: Locator;
  readonly passwordInput: Locator;
  readonly loginButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.usernameInput = page.getByLabel('Username');
    this.passwordInput = page.getByLabel('Password');
    this.loginButton = page.getByRole('button', { name: 'Login' });
    this.errorMessage = page.locator('.error-message');
  }

  async navigate() {
    await this.page.goto('/login');
  }

  async login(username: string, password: string) {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  async getErrorMessage(): Promise<string> {
    return await this.errorMessage.textContent() || '';
  }
}
```

### Using Page Objects
```typescript
import { test, expect } from '@playwright/test';
import { LoginPage } from './pages/login-page';

test('login test', async ({ page }) => {
  const loginPage = new LoginPage(page);

  await loginPage.navigate();
  await loginPage.login('testuser', 'password123');

  await expect(page).toHaveURL('/dashboard');
});
```

## Testing with Playwright Test Runner

### Basic Test
```typescript
import { test, expect } from '@playwright/test';

test('basic test', async ({ page }) => {
  await page.goto('https://example.com');

  const title = await page.title();
  expect(title).toBe('Example Domain');

  await expect(page.locator('h1')).toHaveText('Example Domain');
});
```

### Test Hooks
```typescript
import { test, expect } from '@playwright/test';

test.describe('test suite', () => {
  test.beforeAll(async ({ browser }) => {
    // Runs once before all tests
  });

  test.beforeEach(async ({ page }) => {
    // Runs before each test
    await page.goto('https://example.com');
  });

  test.afterEach(async ({ page }) => {
    // Runs after each test
    await page.close();
  });

  test.afterAll(async ({ browser }) => {
    // Runs once after all tests
  });

  test('first test', async ({ page }) => {
    // Test code
  });

  test('second test', async ({ page }) => {
    // Test code
  });
});
```

### Test Fixtures
```typescript
import { test as base, expect } from '@playwright/test';
import { LoginPage } from './pages/login-page';

// Extend base test with custom fixture
type MyFixtures = {
  loginPage: LoginPage;
};

const test = base.extend<MyFixtures>({
  loginPage: async ({ page }, use) => {
    const loginPage = new LoginPage(page);
    await loginPage.navigate();
    await use(loginPage);
  },
});

// Use custom fixture in tests
test('test with custom fixture', async ({ loginPage }) => {
  await loginPage.login('user', 'pass');
  // Test continues...
});
```

### Parameterized Tests
```typescript
const testData = [
  { username: 'user1', password: 'pass1', expected: 'User 1' },
  { username: 'user2', password: 'pass2', expected: 'User 2' },
  { username: 'user3', password: 'pass3', expected: 'User 3' },
];

for (const data of testData) {
  test(`login with ${data.username}`, async ({ page }) => {
    await page.goto('/login');
    await page.fill('#username', data.username);
    await page.fill('#password', data.password);
    await page.click('button[type="submit"]');

    await expect(page.locator('.welcome')).toHaveText(data.expected);
  });
}
```

### Test Tags and Annotations
```typescript
import { test, expect } from '@playwright/test';

// Tag tests
test('test with tag @smoke', async ({ page }) => {
  // Run with: npx playwright test --grep @smoke
});

// Skip test
test.skip('skipped test', async ({ page }) => {
  // This test will be skipped
});

// Conditional skip
test('conditional skip', async ({ page, browserName }) => {
  test.skip(browserName === 'webkit', 'Not working in WebKit');
  // Test code...
});

// Only run this test
test.only('focused test', async ({ page }) => {
  // Only this test will run
});

// Mark as failing
test('known issue', async ({ page }) => {
  test.fail();
  // Test is expected to fail
});

// Test metadata
test('test with info', async ({ page }) => {
  test.info().annotations.push({ type: 'issue', description: 'JIRA-123' });
});
```

## Advanced Features

### Authentication State
```typescript
import { test as setup } from '@playwright/test';

// Save authentication state
setup('authenticate', async ({ page }) => {
  await page.goto('/login');
  await page.fill('#username', 'user');
  await page.fill('#password', 'password');
  await page.click('button[type="submit"]');

  await page.waitForURL('/dashboard');

  // Save storage state
  await page.context().storageState({ path: 'auth.json' });
});

// Use saved authentication
test.use({ storageState: 'auth.json' });

test('authenticated test', async ({ page }) => {
  // Already logged in
  await page.goto('/dashboard');
});
```

### Handle Dialogs
```typescript
// Handle alert, confirm, prompt
page.on('dialog', async dialog => {
  console.log(dialog.message());
  await dialog.accept();      // Or dialog.dismiss()
});

// Handle prompt with input
page.on('dialog', async dialog => {
  if (dialog.type() === 'prompt') {
    await dialog.accept('My input');
  }
});

// Trigger dialog
await page.evaluate(() => alert('Hello'));
```

### Handle Frames and iframes
```typescript
// Get frame by name or URL
const frame = page.frame('frameName');
const frameByUrl = page.frame({ url: /iframe-url/ });

// Modern approach with frameLocator
const iframe = page.frameLocator('#my-iframe');
await iframe.locator('button').click();

// Work with frame
const frames = page.frames();
for (const frame of frames) {
  console.log(await frame.title());
}
```

### Mobile Emulation
```typescript
import { devices } from '@playwright/test';

const iPhone = devices['iPhone 12'];

const context = await browser.newContext({
  ...iPhone,
  locale: 'en-US',
  geolocation: { latitude: 40.7128, longitude: -74.0060 },
  permissions: ['geolocation'],
});

// Or in test config
test.use({
  ...devices['iPhone 12'],
});
```

### Multi-Browser Parallel Execution
```typescript
// In playwright.config.ts - configure multiple browsers
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  fullyParallel: true,  // Run tests in parallel
  workers: 4,           // Number of parallel workers

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
    {
      name: 'iPad',
      use: { ...devices['iPad Pro'] },
    },
  ],
});
```

```bash
# Run tests across all configured browsers in parallel
npx playwright test

# Run on specific browser
npx playwright test --project=chromium

# Run on multiple specific browsers
npx playwright test --project=chromium --project=firefox

# Run mobile tests only
npx playwright test --project="Mobile Chrome" --project="Mobile Safari"
```

### Programmatic Parallel Execution
```typescript
import { chromium, firefox, webkit, Browser } from 'playwright';

async function runInBrowser(browserType: 'chromium' | 'firefox' | 'webkit') {
  const browsers = { chromium, firefox, webkit };
  const browser: Browser = await browsers[browserType].launch();
  const page = await browser.newPage();

  await page.goto('https://example.com');
  const title = await page.title();

  await browser.close();
  return { browser: browserType, title };
}

// Run tests in parallel across all browsers
async function runAllBrowsers() {
  const results = await Promise.all([
    runInBrowser('chromium'),
    runInBrowser('firefox'),
    runInBrowser('webkit'),
  ]);

  console.log(results);
}

runAllBrowsers();
```

### Mobile Device Testing
```typescript
import { test, devices } from '@playwright/test';

// Test on specific mobile device
test.use({ ...devices['iPhone 13 Pro'] });

test('mobile test', async ({ page }) => {
  await page.goto('https://example.com');
  // Test mobile-specific features
});

// Test multiple mobile devices
const mobileDevices = [
  'iPhone 12',
  'iPhone 13 Pro',
  'Pixel 5',
  'Galaxy S21',
  'iPad Pro',
];

for (const deviceName of mobileDevices) {
  test(`test on ${deviceName}`, async ({ browser }) => {
    const context = await browser.newContext({
      ...devices[deviceName],
    });
    const page = await context.newPage();

    await page.goto('https://example.com');
    // Perform tests

    await context.close();
  });
}
```

### Custom Mobile Configuration
```typescript
// Custom mobile viewport
const context = await browser.newContext({
  viewport: { width: 375, height: 667 },
  deviceScaleFactor: 2,
  isMobile: true,
  hasTouch: true,
  userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) ...',
});

// Tablet configuration
const tabletContext = await browser.newContext({
  viewport: { width: 768, height: 1024 },
  deviceScaleFactor: 2,
  isMobile: false,
  hasTouch: true,
});

// Test landscape orientation
const page = await context.newPage();
await page.setViewportSize({ width: 667, height: 375 });

// Check if mobile
const isMobile = await page.evaluate(() => {
  return window.matchMedia('(max-width: 768px)').matches;
});
```

### API Testing
```typescript
import { test, expect } from '@playwright/test';

test('API test', async ({ request }) => {
  // GET request
  const response = await request.get('https://api.example.com/users');
  expect(response.ok()).toBeTruthy();
  expect(response.status()).toBe(200);

  const data = await response.json();
  expect(data).toHaveLength(10);

  // POST request
  const createResponse = await request.post('https://api.example.com/users', {
    data: {
      name: 'John Doe',
      email: 'john@example.com',
    },
  });

  expect(createResponse.ok()).toBeTruthy();
  const user = await createResponse.json();
  expect(user.id).toBeDefined();

  // With headers
  await request.get('https://api.example.com/protected', {
    headers: {
      'Authorization': 'Bearer token',
    },
  });
});
```

### CI/CD Integration

#### GitHub Actions
```yaml
# .github/workflows/playwright.yml
name: Playwright Tests

on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      - name: Run Playwright tests
        run: npx playwright test

      - name: Upload test results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30

      - name: Upload test traces
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-traces
          path: test-results/
          retention-days: 30
```

```yaml
# Multi-browser matrix strategy
name: Playwright Tests - Multi-Browser

on: [push, pull_request]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ${{ matrix.os }}
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        browser: [chromium, firefox, webkit]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps ${{ matrix.browser }}

      - name: Run tests on ${{ matrix.browser }}
        run: npx playwright test --project=${{ matrix.browser }}

      - name: Upload results
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-results-${{ matrix.os }}-${{ matrix.browser }}
          path: playwright-report/
```

#### GitLab CI/CD
```yaml
# .gitlab-ci.yml
image: mcr.microsoft.com/playwright:v1.40.0-focal

stages:
  - test
  - report

variables:
  npm_config_cache: "$CI_PROJECT_DIR/.npm"
  PLAYWRIGHT_BROWSERS_PATH: 0

cache:
  paths:
    - .npm
    - node_modules

install:
  stage: .pre
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules
    expire_in: 1 hour

playwright-tests:
  stage: test
  script:
    - npx playwright test
  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    reports:
      junit: test-results/junit.xml
    expire_in: 30 days

playwright-tests-parallel:
  stage: test
  parallel:
    matrix:
      - BROWSER: [chromium, firefox, webkit]
  script:
    - npx playwright test --project=$BROWSER
  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    expire_in: 30 days
```

```yaml
# With Docker service
test:
  image: mcr.microsoft.com/playwright:v1.40.0-focal
  stage: test
  services:
    - docker:dind
  variables:
    DOCKER_HOST: tcp://docker:2375
    DOCKER_DRIVER: overlay2
  before_script:
    - npm ci
    - npx playwright install
  script:
    - npx playwright test
  artifacts:
    when: always
    paths:
      - playwright-report/
      - test-results/
    expire_in: 1 week
```

#### Jenkins Pipeline
```groovy
// Jenkinsfile - Declarative Pipeline
pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright:v1.40.0-focal'
            args '-u root:root'
        }
    }

    environment {
        HOME = "${WORKSPACE}"
        CI = 'true'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Install Playwright Browsers') {
            steps {
                sh 'npx playwright install --with-deps'
            }
        }

        stage('Run Playwright Tests') {
            steps {
                sh 'npx playwright test'
            }
        }

        stage('Publish Results') {
            steps {
                publishHTML([
                    reportDir: 'playwright-report',
                    reportFiles: 'index.html',
                    reportName: 'Playwright Test Report',
                    keepAll: true,
                    alwaysLinkToLastBuild: true
                ])
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'playwright-report/**/*', allowEmptyArchive: true
            archiveArtifacts artifacts: 'test-results/**/*', allowEmptyArchive: true
        }

        failure {
            emailext(
                subject: "Playwright Tests Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Check console output at ${env.BUILD_URL}",
                to: 'team@example.com'
            )
        }
    }
}
```

```groovy
// Jenkinsfile - Parallel Execution
pipeline {
    agent any

    stages {
        stage('Setup') {
            steps {
                sh 'npm ci'
                sh 'npx playwright install --with-deps'
            }
        }

        stage('Parallel Browser Tests') {
            parallel {
                stage('Chromium') {
                    steps {
                        sh 'npx playwright test --project=chromium'
                    }
                }
                stage('Firefox') {
                    steps {
                        sh 'npx playwright test --project=firefox'
                    }
                }
                stage('WebKit') {
                    steps {
                        sh 'npx playwright test --project=webkit'
                    }
                }
            }
        }

        stage('Generate Report') {
            steps {
                sh 'npx playwright show-report'
            }
        }
    }

    post {
        always {
            junit 'test-results/*.xml'
            publishHTML([
                reportDir: 'playwright-report',
                reportFiles: 'index.html',
                reportName: 'Playwright Report'
            ])
        }
    }
}
```

```groovy
// Jenkinsfile - Scripted Pipeline
node {
    docker.image('mcr.microsoft.com/playwright:v1.40.0-focal').inside('-u root:root') {
        stage('Checkout') {
            checkout scm
        }

        stage('Install') {
            sh '''
                npm ci
                npx playwright install --with-deps
            '''
        }

        stage('Test') {
            try {
                sh 'npx playwright test'
            } catch (Exception e) {
                currentBuild.result = 'UNSTABLE'
                throw e
            } finally {
                publishHTML([
                    reportDir: 'playwright-report',
                    reportFiles: 'index.html',
                    reportName: 'Playwright Report',
                    keepAll: true
                ])
            }
        }
    }
}
```

#### CI/CD Configuration Best Practices
```typescript
// playwright.config.ts - CI-optimized configuration
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',

  // CI-specific settings
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,

  // Reporter configuration for CI
  reporter: [
    ['html', { open: 'never' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['list'],
  ],

  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',

    // CI environment detection
    headless: true,
    viewport: { width: 1280, height: 720 },
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],

  // Local dev server for CI
  webServer: process.env.CI ? undefined : {
    command: 'npm run start',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
    timeout: 120000,
  },
});
```

#### Docker Configuration for CI
```dockerfile
# Dockerfile for CI environments
FROM mcr.microsoft.com/playwright:v1.40.0-focal

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npx playwright install --with-deps

CMD ["npx", "playwright", "test"]
```

```yaml
# docker-compose.yml for local CI testing
version: '3.8'

services:
  playwright:
    build: .
    volumes:
      - ./test-results:/app/test-results
      - ./playwright-report:/app/playwright-report
    environment:
      - CI=true
      - BASE_URL=http://web:3000
    depends_on:
      - web

  web:
    image: nginx:alpine
    ports:
      - "3000:80"
    volumes:
      - ./dist:/usr/share/nginx/html
```

#### Environment Variables for CI
```bash
# .env.ci
CI=true
BASE_URL=https://staging.example.com
HEADLESS=true
BROWSER=chromium
WORKERS=2
RETRIES=2
TIMEOUT=30000
PARALLEL=true

# Use in CI pipeline
export $(cat .env.ci | xargs)
npx playwright test
```

#### Allure Report Integration
```bash
# Install Allure reporter
npm install -D allure-playwright allure-commandline
```

```typescript
// playwright.config.ts - Add Allure reporter
import { defineConfig } from '@playwright/test';

export default defineConfig({
  reporter: [
    ['list'],
    ['allure-playwright', {
      outputFolder: 'allure-results',
      detail: true,
      suiteTitle: false,
      environmentInfo: {
        'Node Version': process.version,
        'OS': process.platform,
      },
    }],
  ],

  use: {
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    trace: 'on-first-retry',
  },
});
```

```typescript
// Using Allure annotations in tests
import { test, expect } from '@playwright/test';
import { allure } from 'allure-playwright';

test('example with Allure annotations', async ({ page }) => {
  await allure.epic('E-commerce');
  await allure.feature('Shopping Cart');
  await allure.story('Add items to cart');
  await allure.owner('QA Team');
  await allure.severity('critical');
  await allure.tag('smoke', 'regression');

  await test.step('Navigate to product page', async () => {
    await page.goto('https://example.com/products');
    await allure.attachment('Product Page', page.url(), 'text/plain');
  });

  await test.step('Add product to cart', async () => {
    await page.click('.add-to-cart');
    await expect(page.locator('.cart-count')).toHaveText('1');
  });

  await test.step('Verify cart contents', async () => {
    await page.goto('/cart');
    await expect(page.locator('.cart-item')).toBeVisible();

    // Add screenshot to Allure report
    const screenshot = await page.screenshot();
    await allure.attachment('Cart Screenshot', screenshot, 'image/png');
  });
});

// Custom test info
test('test with parameters', async ({ page }) => {
  await allure.parameter('URL', 'https://example.com');
  await allure.parameter('Browser', 'Chromium');
  await allure.parameter('Environment', 'Staging');

  await allure.link('https://jira.example.com/TICKET-123', 'JIRA Ticket');
  await allure.issue('BUG-456', 'https://jira.example.com/BUG-456');
  await allure.tms('TEST-789', 'https://testmanagement.example.com/TEST-789');

  // Test implementation
  await page.goto('https://example.com');
});
```

```bash
# Generate and view Allure report
npx playwright test
npx allure generate allure-results --clean -o allure-report
npx allure open allure-report

# Or use combined command
npm run test:allure
```

```json
// package.json - Add Allure scripts
{
  "scripts": {
    "test": "playwright test",
    "test:allure": "playwright test && allure generate allure-results --clean && allure open",
    "allure:generate": "allure generate allure-results --clean -o allure-report",
    "allure:open": "allure open allure-report",
    "allure:serve": "allure serve allure-results"
  }
}
```

```yaml
# GitHub Actions with Allure
name: Playwright Tests with Allure

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '18'

      - name: Install dependencies
        run: |
          npm ci
          npx playwright install --with-deps

      - name: Run Playwright tests
        run: npx playwright test

      - name: Generate Allure Report
        if: always()
        run: |
          npm install -g allure-commandline
          allure generate allure-results --clean -o allure-report

      - name: Upload Allure Report
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: allure-report
          path: allure-report/
          retention-days: 30

      - name: Deploy Allure Report to GitHub Pages
        if: always()
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./allure-report
          publish_branch: gh-pages
```

```yaml
# GitLab CI with Allure
test-with-allure:
  image: mcr.microsoft.com/playwright:v1.40.0-focal
  stage: test
  script:
    - npm ci
    - npx playwright test
    - npm install -g allure-commandline
    - allure generate allure-results --clean -o allure-report
  artifacts:
    when: always
    paths:
      - allure-report/
      - allure-results/
    expire_in: 30 days
  allow_failure: false

pages:
  stage: deploy
  dependencies:
    - test-with-allure
  script:
    - mkdir -p public
    - cp -r allure-report/* public/
  artifacts:
    paths:
      - public
  only:
    - main
```

```groovy
// Jenkins with Allure
pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/playwright:v1.40.0-focal'
        }
    }

    stages {
        stage('Install') {
            steps {
                sh 'npm ci'
                sh 'npx playwright install --with-deps'
            }
        }

        stage('Test') {
            steps {
                sh 'npx playwright test'
            }
        }

        stage('Generate Allure Report') {
            steps {
                script {
                    allure([
                        includeProperties: false,
                        jdk: '',
                        properties: [],
                        reportBuildPolicy: 'ALWAYS',
                        results: [[path: 'allure-results']]
                    ])
                }
            }
        }
    }

    post {
        always {
            allure includeProperties: false,
                   jdk: '',
                   results: [[path: 'allure-results']]
        }
    }
}
```

```typescript
// Advanced Allure features
import { test } from '@playwright/test';
import { allure } from 'allure-playwright';

test('advanced Allure features', async ({ page }) => {
  // Test description
  await allure.description('This test verifies the login functionality');
  await allure.descriptionHtml('<h3>Login Test</h3><p>Validates user authentication</p>');

  // Links
  await allure.link('https://example.com/docs', 'Documentation', 'docs');
  await allure.issue('ISSUE-123', 'https://jira.example.com/ISSUE-123');
  await allure.tms('TC-456', 'https://testmanagement.com/TC-456');

  // Parameters
  await allure.parameter('username', 'testuser@example.com', {
    mode: 'hidden',  // Hide sensitive data
  });
  await allure.parameter('environment', 'staging');

  // Steps with attachments
  await test.step('Login step', async () => {
    await page.goto('https://example.com/login');

    const requestData = JSON.stringify({ username: 'test', password: '***' });
    await allure.attachment('Login Request', requestData, 'application/json');

    await page.fill('#username', 'testuser');
    await page.fill('#password', 'password');
    await page.click('button[type="submit"]');
  });

  // Add log entries
  await allure.logStep('Verifying login success');

  // Attach test data
  const testData = { userId: 123, role: 'admin' };
  await allure.attachment('Test Data', JSON.stringify(testData), 'application/json');

  // Attach page HTML
  const html = await page.content();
  await allure.attachment('Page HTML', html, 'text/html');
});
```

```typescript
// Custom Allure categories for failure grouping
// allure-results/categories.json
[
  {
    "name": "Product Defects",
    "matchedStatuses": ["failed"],
    "messageRegex": ".*AssertionError.*"
  },
  {
    "name": "Test Defects",
    "matchedStatuses": ["broken"],
    "messageRegex": ".*Error.*"
  },
  {
    "name": "Timeout Issues",
    "matchedStatuses": ["broken"],
    "messageRegex": ".*timeout.*"
  }
]
```

### Run Commands
```bash
# Run all tests
npx playwright test

# Run specific file
npx playwright test tests/example.spec.ts

# Run tests in headed mode
npx playwright test --headed

# Run tests in specific browser
npx playwright test --project=chromium
npx playwright test --project=firefox

# Run tests with tag
npx playwright test --grep @smoke

# Run tests in debug mode
npx playwright test --debug

# Generate test report
npx playwright show-report

# Record new test
npx playwright codegen https://example.com

# CI-specific commands
npx playwright test --reporter=junit,html
npx playwright test --workers=1
npx playwright test --retries=2
npx playwright test --max-failures=10
```
