# Python Behave Framework Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Feature Files](#feature-files)
- [Step Definitions](#step-definitions)
- [Context](#context)
- [Hooks](#hooks)
- [Tags](#tags)
- [Configuration](#configuration)
- [Command Line Options](#command-line-options)
- [Best Practices](#best-practices)
- [Advanced Features](#advanced-features)

## Introduction

Behave is a Behavior-Driven Development (BDD) framework for Python that allows you to write tests in natural language, similar to Cucumber in other languages. It uses Gherkin syntax for describing features and scenarios in plain text.

## Installation

```bash
pip install behave
```

To include additional formatters:
```bash
pip install behave-html-formatter
pip install behave-junit-formatter
```

## Project Structure

Typical Behave project structure:

```
features/
├── steps/          # Step definition files (.py)
│   └── mysteps.py
├── environment.py  # Hooks for setup and teardown
├── behave.ini      # Configuration file
└── example.feature # Feature files in Gherkin syntax
```

## Feature Files

Feature files use Gherkin syntax to describe behavior.

### Basic Structure

```gherkin
Feature: Name of the feature
  Description of the feature can span
  multiple lines if needed.

  Background:
    Given common setup steps for all scenarios

  Scenario: Name of the first scenario
    Given some initial context
    When an action occurs
    Then verify the outcome

  Scenario: Name of the second scenario
    Given different initial context
    When another action occurs
    Then verify another outcome
```

### Scenario Outlines

```gherkin
Scenario Outline: Verify calculation with multiple inputs
  Given I have entered <input_1> and <input_2>
  When I perform <operation>
  Then the result should be <result>

  Examples:
    | input_1 | input_2 | operation | result |
    | 20      | 30      | add       | 50     |
    | 40      | 10      | subtract  | 30     |
    | 5       | 6       | multiply  | 30     |
```

### Multiline Strings (Doc Strings)

```gherkin
Scenario: Check multi-line text
  Given I have the following text:
    """
    This is a multiline string
    that can be used for text-based inputs
    like JSON, XML, or any other format
    """
  When I process the text
  Then it should be properly handled
```

### Data Tables

```gherkin
Scenario: Work with tabular data
  Given I have the following users:
    | name  | email           | role    |
    | John  | john@email.com  | admin   |
    | Alice | alice@email.com | user    |
    | Bob   | bob@email.com   | manager |
  When I filter by role "admin"
  Then I should see only "John"
```

## Step Definitions

Step definition files contain Python code that maps to the steps in feature files.

### Basic Step Definitions

```python
# steps/mysteps.py
from behave import given, when, then

@given('some initial context')
def step_impl(context):
    # Setup code
    context.value = 0

@when('an action occurs')
def step_impl(context):
    # Action code
    context.value += 1

@then('verify the outcome')
def step_impl(context):
    # Verification/assertion code
    assert context.value == 1
```

### Step Definitions with Parameters

```python
@given('I have entered {value:d}')
def step_impl(context, value):
    context.value = value

@when('I multiply by {multiplier:d}')
def step_impl(context, multiplier):
    context.result = context.value * multiplier

@then('the result should be {expected:d}')
def step_impl(context, expected):
    assert context.result == expected
```

### Step Definitions with Regular Expressions

```python
from behave import given, when, then
import re

@given(re.compile(r'I have (?P<count>\d+) (?P<item>\w+)'))
def step_impl(context, count, item):
    context.items = {item: int(count)}
```

### Handling Data Tables

```python
@given('I have the following users')
def step_impl(context):
    context.users = []
    for row in context.table:
        context.users.append({
            'name': row['name'],
            'email': row['email'],
            'role': row['role']
        })
```

### Handling Multiline Text (Doc Strings)

```python
@given('I have the following text')
def step_impl(context):
    context.text_data = context.text  # context.text contains the multiline string
```

## Context

The `context` object is passed to every step function and can be used to share data between steps.

### Common Context Attributes

- `context.table` - Available when a step has a data table
- `context.text` - Available when a step has a multiline string
- `context.failed` - True if the scenario has already failed
- `context.scenario` - Current scenario
- `context.feature` - Current feature
- `context.config` - Configuration

## Hooks

Hooks are defined in `environment.py` to set up and tear down tests.

```python
# features/environment.py

def before_all(context):
    # Setup before any features are run
    context.config.setup_logging()
    context.base_url = "http://example.com"

def after_all(context):
    # Cleanup after all features are run
    pass

def before_feature(context, feature):
    # Setup before each feature
    pass

def after_feature(context, feature):
    # Cleanup after each feature
    pass

def before_scenario(context, scenario):
    # Setup before each scenario
    context.browser = create_browser()

def after_scenario(context, scenario):
    # Cleanup after each scenario
    context.browser.quit()

def before_step(context, step):
    # Setup before each step
    pass

def after_step(context, step):
    # Cleanup after each step
    if step.status == "failed":
        # Take screenshot or dump debug info
        context.browser.save_screenshot(f"failed_{step.name}.png")

def before_tag(context, tag):
    # Setup for specific tags
    if tag == "browser":
        context.browser = create_browser()

def after_tag(context, tag):
    # Cleanup for specific tags
    if tag == "browser":
        context.browser.quit()
```

## Tags

Tags can be used to categorize scenarios and features, controlling which tests to run.

### Tagging Features and Scenarios

```gherkin
@slow @ui
Feature: User Interface Tests
  
  @smoke
  Scenario: Basic UI test
    Given ...

  @regression @wip
  Scenario: Complex UI test
    Given ...
```

### Running Tests with Tags

```bash
# Run scenarios with a specific tag
behave --tags=smoke

# Run scenarios with multiple tags (AND)
behave --tags=regression --tags=ui

# Run scenarios with specific tag combinations (OR)
behave --tags="smoke or regression"

# Exclude scenarios with specific tags
behave --tags="~wip"

# Complex tag expressions
behave --tags="(smoke or regression) and ~wip"
```

## Configuration

### Behave Configuration File (behave.ini)

```ini
[behave]
# Show color output
color = True

# Display logging messages
logging_level = INFO

# Stop on first failure
stop = True

# Format output
format = progress
junit = True
junit_directory = reports

# Ignore certain directories
paths = features
         !features/excluded

# Default options for tags
tags = ~@wip
```

### Environment Variables

```bash
# Set format via environment variables
BEHAVE_FORMAT=pretty behave

# Set other options
BEHAVE_JUNIT=yes BEHAVE_JUNIT_DIRECTORY=reports behave
```

## Command Line Options

Common command line options:

```bash
# Basic execution
behave

# Specify feature files
behave features/login.feature features/checkout.feature

# Specify output format
behave --format=pretty
behave --format=html --outfile=report.html
behave --format=json --outfile=report.json
behave --format=junit --outfile=reports/

# Use multiple formatters
behave --format=pretty --format=json:report.json

# Control verbosity
behave --no-skipped
behave --show-skipped
behave --no-color

# Control execution
behave --stop  # Stop on first failure
behave --no-capture  # Don't capture stdout
behave --no-capture-stderr  # Don't capture stderr
behave --include-re="login.*"  # Only run features matching regex
behave --exclude-re=".*slow.*"  # Skip features matching regex
```

## Best Practices

1. **Keep Features Focused**: Each feature file should focus on one feature of your application.

2. **Step Reusability**: Design steps to be reusable across scenarios.

3. **Naming Conventions**:
   - Feature files: `feature_name.feature`
   - Step files: `feature_name_steps.py`

4. **Proper Assertions**: Use detailed assertions with clear error messages.

5. **Clean Hooks**: Keep setup and teardown code in hooks rather than steps.

6. **Use Backgrounds**: For common setup steps used in all scenarios within a feature.

7. **Context Management**: Use context object appropriately to share state between steps.

8. **Tagging Strategy**: Use tags for organization and test selection.

9. **Step Implementation Patterns**:
   ```python
   # Arrange-Act-Assert pattern
   @given('...')  # Arrange
   @when('...')   # Act
   @then('...')   # Assert
   ```

10. **Avoid Direct UI Manipulation in Step Definitions**: Use Page Object Model or similar patterns.

## Advanced Features

### Fixtures with Dependency Injection

```python
# features/environment.py
from behave.fixture import use_fixture_by_tag, fixture

@fixture
def database_connection(context, timeout=30):
    # Setup
    connection = create_db_connection()
    context.db = connection
    yield context.db
    # Teardown
    connection.close()

fixture_registry = {
    "fixture.database": database_connection,
}

def before_tag(context, tag):
    if tag.startswith("fixture."):
        use_fixture_by_tag(tag, context, fixture_registry)
```

### Step Matchers

```python
# Using custom step matchers
from behave import register_type, given
import parse

@parse.with_pattern(r"\d+")
def parse_number(text):
    return int(text)

register_type(Number=parse_number)

@given('I have {count:Number} items')
def step_impl(context, count):
    context.item_count = count
```

### Step Parameters Type Conversion

```python
# Built-in type converters
@given('I have {count:d} items')  # int
@given('I paid {amount:f} dollars')  # float
@given('Use {flag:Boolean} mode')  # Boolean (True/False, yes/no, on/off)
```

### Scenario Loops (Scenario Outlines)

```gherkin
Scenario Outline: Calculate <operation>
  Given I have <a> and <b>
  When I <operation> them
  Then the result is <result>

  Examples: Addition
    | a | b | operation | result |
    | 5 | 2 | add       | 7      |
    | 3 | 1 | add       | 4      |

  Examples: Subtraction
    | a | b | operation | result |
    | 5 | 2 | subtract  | 3      |
    | 3 | 1 | subtract  | 2      |
```

### Active Tags

```python
# features/environment.py
def before_tag(context, tag):
    if tag.startswith('only.'):
        platform = tag[5:]
        if platform != 'windows' and sys.platform.startswith('win'):
            context.scenario.skip("Requires: " + platform)
```

```gherkin
@only.linux
Scenario: Linux-specific test
    Given ...
```

### Using Step Definitions from Another Feature

```python
# features/steps/common_steps.py
from behave import step

@step('I log in as "{username}"')  # Use @step instead of @given, @when, or @then
def step_impl(context, username):
    # Implementation
```

This step can now be used as a Given, When, or Then in any feature file.
