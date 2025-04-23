# Comprehensive Cypress Cheatsheet

## Table of Contents
- [Installation and Setup](#installation-and-setup)
- [Basic Structure](#basic-structure)
- [Core Concepts](#core-concepts)
- [Test Writing](#test-writing)
- [Selectors](#selectors)
- [Navigation](#navigation)
- [Assertions](#assertions)
- [Actions](#actions)
- [Network Requests](#network-requests)
- [Fixtures and Data](#fixtures-and-data)
- [Custom Commands](#custom-commands)
- [Aliases](#aliases)
- [Cookies and Local Storage](#cookies-and-local-storage)
- [Environment Variables](#environment-variables)
- [Configuration](#configuration)
- [Plugins](#plugins)
- [Task Runner](#task-runner)

## Installation and Setup

### Basic Installation
```bash
# Install Cypress via npm
npm install cypress --save-dev

# Install Cypress via yarn
yarn add cypress --dev

# Open Cypress
npx cypress open

# Run Cypress tests headlessly
npx cypress run
```

### Project Structure
```
cypress/
├── fixtures/        # Test data, mocks
├── integration/     # Test files (v9 and below)
├── e2e/             # Test files (v10+)
├── plugins/         # Plugin files (v9 and below)
├── support/         # Support files, custom commands
│   ├── commands.js  # Custom commands
│   └── e2e.js       # Global configuration (v10+)
└── videos/          # Recorded videos
└── screenshots/     # Captured screenshots
cypress.config.js    # Configuration file (v10+)
cypress.json         # Configuration file (v9 and below)
```

## Basic Structure

### Test Structure
```javascript
// File: cypress/e2e/example.cy.js

describe('My First Test', () => {
  before(() => {
    // Runs once before all tests
  });
  
  beforeEach(() => {
    // Runs before each test
    cy.visit('https://example.com');
  });
  
  it('should display the homepage', () => {
    cy.get('h1').should('contain', 'Example Domain');
  });
  
  it('should have a visible link', () => {
    cy.get('a').should('be.visible');
  });
  
  afterEach(() => {
    // Runs after each test
  });
  
  after(() => {
    // Runs once after all tests
  });
});
```

### Nested Describes
```javascript
describe('Parent Suite', () => {
  describe('Child Suite 1', () => {
    it('test 1', () => {
      // Test code
    });
  });
  
  describe('Child Suite 2', () => {
    it('test 2', () => {
      // Test code
    });
  });
});
```

## Core Concepts

### Chain of Commands
Cypress commands are asynchronous and chained:
```javascript
cy.get('.button')  // Get the element
  .should('be.visible')  // Assert that it's visible
  .click()  // Click it
  .should('have.class', 'active');  // Assert that it now has 'active' class
```

### Automatic Waiting
Cypress automatically waits for elements to exist before acting on them:
```javascript
// Cypress will wait for the button to appear before clicking
cy.get('.button-that-loads-slowly').click();
```

### Retry-ability
Assertions are retried until they pass or timeout:
```javascript
// This will retry until the text appears or timeout (default 4s)
cy.get('#dynamic-content').should('contain', 'Text that loads dynamically');
```

## Test Writing

### Test Syntax
```javascript
// Simple test
it('should have a title', () => {
  cy.visit('/');
  cy.title().should('include', 'My App');
});

// Skipping tests
it.skip('is a test I want to skip', () => {
  // This test will be skipped
});

// Only run this test
it.only('is the only test that will run', () => {
  // Only this test will run in the file
});
```

### Grouping Tests
```javascript
context('Login Page', () => {
  // context is an alias for describe
  it('should display login form', () => {
    // Test code
  });
});
```

## Selectors

### Element Selection
```javascript
// By CSS selector
cy.get('#id');
cy.get('.class');
cy.get('[attribute=value]');

// By text content
cy.contains('Submit');
cy.contains('span', 'Submit');  // Find a span containing "Submit"

// More specific selectors
cy.get('ul li:first');
cy.get('ul li:last');
cy.get('ul li:eq(1)');  // Zero-based index, gets second li

// Combining selectors
cy.get('#form .input[name="email"]');

// Finding children
cy.get('form').find('input');

// Finding parents
cy.get('input').parent();
cy.get('input').parents('form');

// Finding siblings
cy.get('li.active').siblings();

// By position
cy.get('li').first();
cy.get('li').last();
cy.get('li').eq(2);  // Gets the third li element (zero-indexed)
```

### Filter Elements
```javascript
// Filter by attribute
cy.get('button').filter('[type="submit"]');

// Filter by visibility
cy.get('div').filter(':visible');

// Filter by text content
cy.get('li').filter(':contains("Item")');

// Filter by index
cy.get('li').filter((index) => index % 2 === 0);  // Even indices
```

### Custom Selectors
```javascript
// Define a custom selector for React components
Cypress.Commands.add('getByTestId', (testId) => {
  return cy.get(`[data-testid="${testId}"]`);
});

// Usage
cy.getByTestId('submit-button').click();
```

## Navigation

### Basic Navigation
```javascript
// Visit a URL
cy.visit('https://example.com');
cy.visit('/relative/path');

// Visit with options
cy.visit('/', {
  timeout: 30000,  // Increase timeout to 30 seconds
  failOnStatusCode: false,  // Don't fail on 404, 500, etc.
  headers: {
    'X-Custom-Header': 'Custom Value'
  },
  auth: {
    username: 'user',
    password: 'pass'
  }
});

// Go back/forward
cy.go('back');
cy.go('forward');
cy.go(-1);  // Back
cy.go(1);   // Forward

// Reload page
cy.reload();
cy.reload(true);  // Force reload (bypass cache)
```

### URL Assertions
```javascript
// Assert on URL
cy.url().should('include', '/dashboard');
cy.url().should('eq', 'https://example.com/dashboard');

// Hash assertions
cy.hash().should('eq', '#about');

// Assert on specific parts of the URL
cy.location('pathname').should('eq', '/dashboard');
cy.location('search').should('include', '?id=123');
cy.location('hostname').should('eq', 'example.com');
```

## Assertions

### Common Assertions
```javascript
// Built-in Assertions
cy.get('#element').should('exist');
cy.get('#element').should('not.exist');
cy.get('#element').should('be.visible');
cy.get('#element').should('not.be.visible');
cy.get('#element').should('be.enabled');
cy.get('#element').should('be.disabled');
cy.get('#element').should('have.class', 'active');
cy.get('#element').should('not.have.class', 'disabled');
cy.get('#element').should('have.attr', 'type', 'text');
cy.get('#element').should('have.text', 'Exact text');
cy.get('#element').should('contain', 'Partial text');
cy.get('#element').should('have.value', 'Input value');
cy.get('#element').should('be.checked');  // For checkboxes/radios
cy.get('#element').should('be.selected');  // For select options

// Multiple assertions
cy.get('#element')
  .should('be.visible')
  .and('contain', 'Text')
  .and('have.class', 'active');

// Length assertions
cy.get('li').should('have.length', 5);
cy.get('li').should('have.length.gt', 3);  // Greater than
cy.get('li').should('have.length.gte', 3);  // Greater than or equal
cy.get('li').should('have.length.lt', 10);  // Less than
cy.get('li').should('have.length.lte', 10);  // Less than or equal
```

### Expect Assertions
```javascript
// BDD-style assertions
cy.get('#count').then(($el) => {
  const count = parseInt($el.text());
  expect(count).to.be.greaterThan(0);
  expect(count).to.be.lessThan(10);
  expect(count).to.equal(5);
});

// Common expect assertions
expect(true).to.be.true;
expect(5).to.equal(5);
expect('text').to.include('ex');
expect({ name: 'John' }).to.deep.equal({ name: 'John' });
expect([1, 2, 3]).to.have.members([3, 2, 1]);
expect([1, 2, 3]).to.include(2);
```

### Custom Assertions
```javascript
// Add custom assertion
chai.use((_chai, utils) => {
  _chai.Assertion.addMethod('withData', function(attr, value) {
    const $el = this._obj[0];
    const dataAttr = `data-${attr}`;
    this.assert(
      $el.getAttribute(dataAttr) === value,
      `expected ${$el} to have data-${attr}="${value}"`,
      `expected ${$el} not to have data-${attr}="${value}"`
    );
  });
});

// Usage
cy.get('button').should('withData', 'action', 'save');
```

## Actions

### Mouse Actions
```javascript
// Click actions
cy.get('button').click();
cy.get('button').dblclick();
cy.get('button').rightclick();

// Click with modifiers
cy.get('button').click({ shiftKey: true });
cy.get('button').click({ ctrlKey: true });
cy.get('button').click({ metaKey: true });
cy.get('button').click({ altKey: true });

// Click position
cy.get('button').click('topLeft');
cy.get('button').click('top');
cy.get('button').click('topRight');
cy.get('button').click('left');
cy.get('button').click('center');  // Default
cy.get('button').click('right');
cy.get('button').click('bottomLeft');
cy.get('button').click('bottom');
cy.get('button').click('bottomRight');

// Click coordinates
cy.get('canvas').click(10, 15);  // 10px from left, 15px from top

// Click options
cy.get('button').click({ force: true });  // Click even if element is not visible
cy.get('button').click({ multiple: true });  // Click even if multiple elements matched

// Hover (trigger mouse over)
cy.get('.dropdown').trigger('mouseover');
// Alternative for hover
cy.get('.dropdown').realHover();  // Requires cypress-real-events plugin
```

### Keyboard Actions
```javascript
// Type text
cy.get('input').type('Hello, World!');

// Special characters in typing
cy.get('input').type('user{enter}');  // Type "user" and press Enter
cy.get('input').type('{selectall}{backspace}');  // Clear field

// Special key sequences
cy.get('input').type('{ctrl+a}{del}');  // Select all and delete
cy.get('body').type('{ctrl+f}');  // Trigger search

// Available special keys
// {backspace}, {del}, {enter}, {esc}, {alt}, {ctrl}, {meta}, {shift}
// {uparrow}, {downarrow}, {leftarrow}, {rightarrow}
// {home}, {end}, {insert}, {pageup}, {pagedown}
// {selectall}

// Type with delay (milliseconds)
cy.get('input').type('Slow typing...', { delay: 100 });

// Clear field
cy.get('input').clear();

// Focus and blur
cy.get('input').focus();
cy.get('input').blur();

// Submit form
cy.get('form').submit();
```

### Form Actions
```javascript
// Check/uncheck checkboxes and radio buttons
cy.get('[type="checkbox"]').check();
cy.get('[type="checkbox"]').uncheck();
cy.get('[type="radio"]').check();

// Check/uncheck multiple by value
cy.get('[type="checkbox"]').check(['value1', 'value2']);
cy.get('[type="checkbox"]').uncheck(['value1', 'value2']);

// Select dropdown options
cy.get('select').select('Option Text');
cy.get('select').select('option-value');  // By value attribute
cy.get('select').select(2);  // By index (zero-based)

// Select multiple options
cy.get('select[multiple]').select(['option1', 'option2']);

// File upload
cy.get('input[type="file"]').selectFile('cypress/fixtures/example.json');
cy.get('input[type="file"]').selectFile(['file1.pdf', 'file2.jpg']);  // Multiple files

// Drag and drop (requires @4.x)
cy.get('#drag-source').drag('#drop-target');

// Alternative for drag and drop
cy.get('#draggable').trigger('mousedown', { which: 1 })
  .trigger('mousemove', { clientX: 100, clientY: 100 })
  .trigger('mouseup');
```

## Network Requests

### Making Requests
```javascript
// GET request
cy.request('https://api.example.com/users');

// POST request
cy.request('POST', 'https://api.example.com/users', {
  name: 'John',
  email: 'john@example.com'
});

// Request with options
cy.request({
  method: 'GET',
  url: 'https://api.example.com/private',
  headers: {
    'Authorization': 'Bearer token123'
  },
  failOnStatusCode: false  // Don't fail on 4xx/5xx
});

// Request with form data
cy.request({
  method: 'POST',
  url: '/upload',
  body: formData,
  form: true
});
```

### Network Interception
```javascript
// Stub network requests
cy.intercept('GET', '/api/users', { fixture: 'users.json' });

// Stub with dynamic response
cy.intercept('GET', '/api/users', (req) => {
  req.reply({
    statusCode: 200,
    body: {
      users: [
        { id: 1, name: 'John' },
        { id: 2, name: 'Jane' }
      ]
    }
  });
});

// Stub with delay
cy.intercept('GET', '/api/users', {
  body: { users: [] },
  delay: 1000  // 1 second delay
});

// Intercept and modify request
cy.intercept('POST', '/api/submit', (req) => {
  req.body.timestamp = Date.now();
  req.continue();
});

// Intercept and modify response
cy.intercept('GET', '/api/data', (req) => {
  req.continue((res) => {
    res.body.extra = 'Modified by Cypress';
    return res;
  });
});

// Match requests using wildcards and regex
cy.intercept('GET', '/api/users/*');
cy.intercept('GET', /\/api\/users\/\d+/);

// Spy on requests without stubbing
cy.intercept('GET', '/api/users').as('getUsers');

// Wait for intercepted request
cy.wait('@getUsers');
cy.wait('@getUsers').its('response.statusCode').should('eq', 200);

// Assert on intercepted request details
cy.wait('@getUsers').then((interception) => {
  expect(interception.request.url).to.include('/api/users');
  expect(interception.response.body).to.have.property('users');
});
```

## Fixtures and Data

### Using Fixtures
```javascript
// Load fixture file
cy.fixture('users.json').then((users) => {
  // Use the data
  cy.log(users[0].name);
});

// Alias a fixture
cy.fixture('users.json').as('usersData');
cy.get('@usersData').then((users) => {
  // Use the data
});

// Use fixture in a request
cy.intercept('GET', '/api/users', { fixture: 'users.json' });

// Modify fixture data on the fly
cy.fixture('users.json').then((users) => {
  users[0].name = 'Modified Name';
  cy.intercept('GET', '/api/users', { body: users });
});
```

### Dynamic Data
```javascript
// Generate random data
const randomEmail = `user${Math.floor(Math.random() * 10000)}@example.com`;
cy.get('input[name="email"]').type(randomEmail);

// Using a third-party library like Faker
// First install: npm install @faker-js/faker --save-dev
import { faker } from '@faker-js/faker';

it('registers a new user', () => {
  const user = {
    name: faker.person.fullName(),
    email: faker.internet.email(),
    address: faker.location.streetAddress()
  };
  
  cy.get('[name="name"]').type(user.name);
  cy.get('[name="email"]').type(user.email);
  cy.get('[name="address"]').type(user.address);
});
```

## Custom Commands

### Creating Custom Commands
```javascript
// In cypress/support/commands.js
Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login');
  cy.get('#email').type(email);
  cy.get('#password').type(password);
  cy.get('button[type="submit"]').click();
  cy.url().should('include', '/dashboard');
});

// Using the command
cy.login('user@example.com', 'password123');

// Command with options
Cypress.Commands.add('clickLink', (label, options = {}) => {
  cy.contains('a', label).click(options);
});

// Overwriting existing commands
Cypress.Commands.overwrite('visit', (originalFn, url, options) => {
  const defaultOptions = {
    timeout: 60000,
    headers: {
      'X-Custom-Header': 'Custom Value'
    }
  };
  
  return originalFn(url, { ...defaultOptions, ...options });
});
```

### Parent Commands
```javascript
// Create a custom parent command
Cypress.Commands.add('findByDataTest', (selector) => {
  return cy.get(`[data-test="${selector}"]`);
});

// Usage
cy.findByDataTest('submit-button').click();
```

### Child Commands
```javascript
// Create a custom child command
Cypress.Commands.add('shouldHaveText', { prevSubject: true }, (subject, text) => {
  expect(subject.text().trim()).to.equal(text);
  return subject;
});

// Usage
cy.get('h1').shouldHaveText('Welcome');
```

### Dual Commands
```javascript
// Create a command that works as both parent and child
Cypress.Commands.add('getText', { prevSubject: 'optional' }, (subject, selector) => {
  if (subject) {
    return cy.wrap(subject).find(selector).invoke('text');
  } else {
    return cy.get(selector).invoke('text');
  }
});

// Usage as parent
cy.getText('.heading');

// Usage as child
cy.get('article').getText('.heading');
```

## Aliases

### Creating and Using Aliases
```javascript
// Create alias for DOM element
cy.get('.user-list').as('userList');
cy.get('@userList').find('li').should('have.length', 5);

// Create alias for network request
cy.intercept('GET', '/api/users').as('getUsers');
cy.wait('@getUsers');

// Create alias for fixture data
cy.fixture('users.json').as('usersData');
cy.get('@usersData').then((users) => {
  // Use the data
});

// Share context between hooks with aliases
beforeEach(() => {
  cy.fixture('user.json').as('user');
});

it('uses aliased fixture', function() {
  // Access using "this" keyword
  cy.log(this.user.name);
});
```

### Sharing Aliases Between Tests
```javascript
// Store in Cypress.env()
beforeEach(() => {
  cy.fixture('users.json').then((users) => {
    Cypress.env('users', users);
  });
});

it('uses shared data', () => {
  const users = Cypress.env('users');
  cy.log(users[0].name);
});
```

## Cookies and Local Storage

### Cookies
```javascript
// Get all cookies
cy.getCookies();

// Get specific cookie
cy.getCookie('token');

// Set cookie
cy.setCookie('token', 'abc123');

// Clear cookies
cy.clearCookie('token');
cy.clearCookies();

// Preserve cookies between tests
Cypress.Cookies.preserveOnce('token', 'session_id');

// Preserve cookies for specific tests
Cypress.Cookies.defaults({
  preserve: ['token', 'session_id']
});
```

### Local Storage
```javascript
// Set local storage item
cy.window().then((win) => {
  win.localStorage.setItem('token', 'abc123');
});

// Get local storage item
cy.window().then((win) => {
  const token = win.localStorage.getItem('token');
  expect(token).to.equal('abc123');
});

// Clear local storage
cy.window().then((win) => {
  win.localStorage.clear();
});

// Custom command for local storage
Cypress.Commands.add('setLocalStorage', (key, value) => {
  cy.window().then((win) => {
    win.localStorage.setItem(key, value);
  });
});

Cypress.Commands.add('getLocalStorage', (key) => {
  cy.window().then((win) => {
    return win.localStorage.getItem(key);
  });
});
```

## Environment Variables

### Working with Environment Variables
```javascript
// Set environment variables in cypress.config.js
module.exports = {
  e2e: {
    env: {
      apiUrl: 'https://api.example.com',
      apiKey: 'abc123'
    }
  }
};

// Access environment variables
cy.log(Cypress.env('apiUrl'));

// Set environment variables at runtime
Cypress.env('user', { name: 'John' });

// Use environment variables
cy.request({
  url: `${Cypress.env('apiUrl')}/users`,
  headers: {
    'Authorization': `Bearer ${Cypress.env('apiKey')}`
  }
});
```

### Command Line Environment Variables
```bash
# Set environment variables via command line
npx cypress run --env apiUrl=https://staging-api.example.com

# With multiple variables
npx cypress run --env apiUrl=https://staging-api.example.com,apiKey=123
```

### Environment Files
```bash
# Create a cypress.env.json file (gitignored)
{
  "apiUrl": "https://api.example.com",
  "apiKey": "abc123"
}
```

## Configuration

### Common Configuration Options (cypress.config.js)
```javascript
// For Cypress 10+
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'https://example.com',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    excludeSpecPattern: '**/ignore-this-test.cy.js',
    supportFile: 'cypress/support/e2e.js',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    // More e2e configuration options...
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'webpack'
    },
    // More component testing configuration options...
  },
  // Global configuration options
  viewportWidth: 1280,
  viewportHeight: 720,
  defaultCommandTimeout: 5000,
  requestTimeout: 10000,
  responseTimeout: 30000,
  pageLoadTimeout: 60000,
  video: false,
  screenshotOnRunFailure: true,
  trashAssetsBeforeRuns: true,
  chromeWebSecurity: false,
  retries: {
    runMode: 2,
    openMode: 0
  },
  env: {
    apiUrl: 'https://api.example.com'
  }
});
```

### For Cypress 9 and below (cypress.json)
```json
{
  "baseUrl": "https://example.com",
  "integrationFolder": "cypress/integration",
  "testFiles": "**/*.spec.js",
  "ignoreTestFiles": "**/ignore-this-test.spec.js",
  "supportFile": "cypress/support/index.js",
  "pluginsFile": "cypress/plugins/index.js",
  "viewportWidth": 1280,
  "viewportHeight": 720,
  "defaultCommandTimeout": 5000,
  "requestTimeout": 10000,
  "responseTimeout": 30000,
  "pageLoadTimeout": 60000,
  "video": false,
  "screenshotOnRunFailure": true,
  "trashAssetsBeforeRuns": true,
  "chromeWebSecurity": false,
  "retries": {
    "runMode": 2,
    "openMode": 0
  },
  "env": {
    "apiUrl": "https://api.example.com"
  }
}
```

## Plugins

### Common Plugins
```javascript
// File: cypress/plugins/index.js (v9 and below)
// OR in setupNodeEvents function in cypress.config.js (v10+)

// File Upload Plugin
const { defineConfig } = require('cypress');
const { preprocessor } = require('@cypress/webpack-preprocessor');

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // File preprocessing for TypeScript/Webpack
      on('file:preprocessor', preprocessor());
      
      // Custom tasks
      on('task', {
        log(message) {
          console.log(message);
          return null;
        },
        readFileMaybe(filename) {
          if (fs.existsSync(filename)) {
            return fs.readFileSync(filename, 'utf8');
          }
          return null;
        }
      });
    }
  }
});
```

### Popular Community Plugins
```bash
# Install popular plugins
npm install cypress-file-upload --save-dev
npm install cypress-xpath --save-dev
npm install cypress-real-events --save-dev
npm install @testing-library/cypress --save-dev
npm install cypress-localstorage-commands --save-dev
npm install cypress-wait-until --save-dev
```

Usage:
```javascript
// In cypress/support/e2e.js

// XPath support
require('cypress-xpath');
// Usage: cy.xpath('//button[@type="submit"]')

// File upload
import 'cypress-file-upload';
// Usage: cy.get('input[type="file"]').attachFile('example.json');

// Real events (hover, etc.)
import 'cypress-real-events';
// Usage: cy.get('button').realHover();

// Testing Library
import '@testing-library/cypress/add-commands';
// Usage: cy.findByText('Submit').click();

// Wait until
import 'cypress-wait-until';
// Usage: cy.waitUntil(() => cy.get('#element').then($el => $el.text() === 'Ready'));
```

## Task Runner

### Custom Tasks
```javascript
// In cypress.config.js for v10+
const fs = require('fs');
const path = require('path');

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // Define custom tasks (Node.js code that runs outside of the browser)
      on('task', {
        // Log to console
        log(message) {
          console.log(message);
          return null;
        },
        
        // Read external file
        readFile(filePath) {
          return fs.readFileSync(path.join(__dirname, filePath), 'utf8');
        },
        
        // Write to external file
        writeFile({ filePath, content }) {
          fs.writeFileSync(path.join(__dirname, filePath), content);
          return null;
        },
        
        // Generate random data
        generateRandomUser() {
          return {
            id: Math.floor(Math.random() * 10000),
            name: `User ${Math.random().toString(36).substring(2, 8)}`
          };
        },
        
        // Database operations (example with knex)
        async dbQuery(query) {
          const knex = require('knex')({
            client: 'pg',
            connection: {
              host: '127.0.0.1',
              user: 'postgres',
              password: 'password',
              database: 'test_db'
            }
          });
          
          const result = await knex.raw(query);
          await knex.destroy();
          return result.rows;
        }
      });
    }
  }
});
```

### Using Tasks in Tests
```javascript
it('uses a custom task', () => {
  // Execute a task
  cy.task('log', 'This will be logged to the console');
  
  // Task with return value
  cy.task('generateRandomUser').then((user) => {
    cy.log(`Generated user: ${user.name}`);
  });
  
  // Example database query
  cy.task('dbQuery', 'SELECT * FROM users LIMIT 1').then((users) => {
    cy.log(`First user: ${users[0].name}`);
  });
});
```
