# GitHub Actions Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Workflow Basics](#workflow-basics)
- [Workflow Syntax](#workflow-syntax)
- [Events & Triggers](#events--triggers)
- [Jobs](#jobs)
- [Steps](#steps)
- [Contexts](#contexts)
- [Environment Variables](#environment-variables)
- [Secrets](#secrets)
- [Artifacts](#artifacts)
- [Caching](#caching)
- [Matrix Strategy](#matrix-strategy)
- [Reusable Workflows](#reusable-workflows)
- [Custom Actions](#custom-actions)
- [Commonly Used Actions](#commonly-used-actions)
- [CI/CD Patterns](#cicd-patterns)
- [Security Best Practices](#security-best-practices)
- [Debugging & Troubleshooting](#debugging--troubleshooting)
- [References](#references)

## Introduction

GitHub Actions is a CI/CD platform that allows you to automate your build, test, and deployment pipeline directly in your GitHub repository.

## Workflow Basics

### Workflow File Location
```
.github/
└── workflows/
    ├── ci.yml
    ├── deploy.yml
    └── test.yml
```

### Minimal Workflow
```yaml
name: CI

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run a script
        run: echo "Hello, World!"
```

## Workflow Syntax

### Basic Structure
```yaml
name: Workflow Name                # Workflow name (optional)

on:                                # Trigger events
  push:
    branches: [ main ]

env:                               # Global environment variables
  NODE_ENV: production

jobs:                              # Jobs to run
  job-name:
    runs-on: ubuntu-latest         # Runner environment
    steps:                         # Steps to execute
      - name: Step name
        run: echo "Step command"
```

### Complete Example
```yaml
name: Complete CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:               # Manual trigger

env:
  NODE_VERSION: '18'

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
```

## Events & Triggers

### Push Event
```yaml
on:
  push:
    branches:
      - main
      - 'releases/**'              # Wildcard matching
    tags:
      - v1.*                       # Tag pattern
    paths:
      - 'src/**'                   # Only trigger on specific paths
      - '!docs/**'                 # Exclude paths
```

### Pull Request Event
```yaml
on:
  pull_request:
    branches: [ main ]
    types:
      - opened
      - synchronize
      - reopened
    paths-ignore:
      - '**.md'
      - 'docs/**'
```

### Schedule (Cron)
```yaml
on:
  schedule:
    # Every day at 2:30 AM UTC
    - cron: '30 2 * * *'
    # Every Monday at 9:00 AM UTC
    - cron: '0 9 * * 1'
```

### Manual Trigger (workflow_dispatch)
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        type: choice
        options:
          - dev
          - staging
          - production
      version:
        description: 'Version to deploy'
        required: false
        default: 'latest'
```

### Multiple Events
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:
  schedule:
    - cron: '0 0 * * 0'            # Weekly on Sunday
```

### Other Common Events
```yaml
on:
  # On release creation
  release:
    types: [ published ]

  # On issue comment
  issue_comment:
    types: [ created ]

  # On workflow completion
  workflow_run:
    workflows: ["CI"]
    types: [ completed ]

  # On repository dispatch
  repository_dispatch:
    types: [ custom-event ]
```

## Jobs

### Basic Job
```yaml
jobs:
  build:
    name: Build Application
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."
```

### Job Dependencies
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: npm run build

  test:
    needs: build                   # Wait for build to complete
    runs-on: ubuntu-latest
    steps:
      - run: npm test

  deploy:
    needs: [build, test]           # Wait for multiple jobs
    runs-on: ubuntu-latest
    steps:
      - run: npm run deploy
```

### Conditional Jobs
```yaml
jobs:
  deploy:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to production"

  test:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - run: npm test
```

### Different Runners
```yaml
jobs:
  ubuntu-job:
    runs-on: ubuntu-latest         # Ubuntu (most common)

  macos-job:
    runs-on: macos-latest          # macOS

  windows-job:
    runs-on: windows-latest        # Windows

  self-hosted:
    runs-on: self-hosted           # Self-hosted runner

  specific-version:
    runs-on: ubuntu-22.04          # Specific Ubuntu version
```

### Job Outputs
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.get-version.outputs.version }}
    steps:
      - name: Get version
        id: get-version
        run: echo "version=1.0.0" >> $GITHUB_OUTPUT

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Use version
        run: echo "Deploying version ${{ needs.build.outputs.version }}"
```

### Timeout
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 10            # Job timeout (default: 360)
    steps:
      - run: npm run build
```

### Services (Containers)
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7
        ports:
          - 6379:6379

    steps:
      - run: npm test
```

## Steps

### Run Commands
```yaml
steps:
  # Single line
  - name: Run command
    run: echo "Hello World"

  # Multiple lines
  - name: Run multiple commands
    run: |
      echo "Line 1"
      echo "Line 2"
      npm install

  # Multi-line with pipe
  - name: Build and test
    run: |
      npm run build
      npm test
```

### Using Actions
```yaml
steps:
  # Use an action
  - name: Checkout repository
    uses: actions/checkout@v4

  # Use action with parameters
  - name: Setup Node.js
    uses: actions/setup-node@v4
    with:
      node-version: '18'
      cache: 'npm'

  # Use action from specific version
  - uses: actions/checkout@v4.1.0

  # Use action from branch
  - uses: actions/checkout@main

  # Use action from commit SHA
  - uses: actions/checkout@8e5e7e5ab8b370d6c329ec480221332ada57f0ab
```

### Conditional Steps
```yaml
steps:
  - name: Deploy to production
    if: github.ref == 'refs/heads/main'
    run: npm run deploy

  - name: Run on success
    if: success()
    run: echo "Previous steps succeeded"

  - name: Run on failure
    if: failure()
    run: echo "A previous step failed"

  - name: Always run
    if: always()
    run: echo "This always runs"

  - name: Conditional on variable
    if: env.DEPLOY == 'true'
    run: echo "Deploying"
```

### Step Outputs
```yaml
steps:
  - name: Set output
    id: step-id
    run: |
      echo "result=success" >> $GITHUB_OUTPUT
      echo "version=1.2.3" >> $GITHUB_OUTPUT

  - name: Use output
    run: |
      echo "Result: ${{ steps.step-id.outputs.result }}"
      echo "Version: ${{ steps.step-id.outputs.version }}"
```

### Working Directory
```yaml
steps:
  - name: Run in specific directory
    run: npm install
    working-directory: ./frontend
```

### Shell Selection
```yaml
steps:
  - name: Bash script
    run: echo "Using bash"
    shell: bash

  - name: Python script
    run: print("Using python")
    shell: python

  - name: PowerShell script
    run: Write-Output "Using PowerShell"
    shell: pwsh
```

### Continue on Error
```yaml
steps:
  - name: Linting (may fail)
    run: npm run lint
    continue-on-error: true        # Don't fail job if this fails

  - name: Tests (must pass)
    run: npm test
```

## Contexts

### GitHub Context
```yaml
steps:
  - name: Print GitHub context
    run: |
      echo "Repository: ${{ github.repository }}"
      echo "Ref: ${{ github.ref }}"
      echo "SHA: ${{ github.sha }}"
      echo "Actor: ${{ github.actor }}"
      echo "Event: ${{ github.event_name }}"
      echo "Workflow: ${{ github.workflow }}"
      echo "Run ID: ${{ github.run_id }}"
      echo "Run Number: ${{ github.run_number }}"
```

### Job Context
```yaml
steps:
  - name: Print job context
    run: |
      echo "Status: ${{ job.status }}"
      echo "Job container: ${{ job.container.id }}"
```

### Steps Context
```yaml
steps:
  - name: Step 1
    id: step1
    run: echo "output=value" >> $GITHUB_OUTPUT

  - name: Use step output
    run: echo "${{ steps.step1.outputs.output }}"
```

### Runner Context
```yaml
steps:
  - name: Print runner context
    run: |
      echo "OS: ${{ runner.os }}"
      echo "Arch: ${{ runner.arch }}"
      echo "Name: ${{ runner.name }}"
      echo "Temp: ${{ runner.temp }}"
      echo "Tool cache: ${{ runner.tool_cache }}"
```

### Env Context
```yaml
env:
  GLOBAL_VAR: global

jobs:
  test:
    runs-on: ubuntu-latest
    env:
      JOB_VAR: job-level
    steps:
      - name: Print env
        env:
          STEP_VAR: step-level
        run: |
          echo "Global: ${{ env.GLOBAL_VAR }}"
          echo "Job: ${{ env.JOB_VAR }}"
          echo "Step: ${{ env.STEP_VAR }}"
```

### Secrets Context
```yaml
steps:
  - name: Use secret
    run: echo "Using secret"
    env:
      API_KEY: ${{ secrets.API_KEY }}
```

### Matrix Context
```yaml
strategy:
  matrix:
    node: [16, 18, 20]
    os: [ubuntu-latest, windows-latest]

steps:
  - name: Print matrix
    run: |
      echo "Node: ${{ matrix.node }}"
      echo "OS: ${{ matrix.os }}"
```

## Environment Variables

### Define Environment Variables
```yaml
# Workflow level
env:
  WORKFLOW_VAR: value

jobs:
  build:
    runs-on: ubuntu-latest
    # Job level
    env:
      JOB_VAR: value

    steps:
      # Step level
      - name: Step with env
        env:
          STEP_VAR: value
        run: echo "$STEP_VAR"
```

### Default Environment Variables
```yaml
steps:
  - name: Print default variables
    run: |
      echo "Home: $HOME"
      echo "GitHub Workspace: $GITHUB_WORKSPACE"
      echo "GitHub Repository: $GITHUB_REPOSITORY"
      echo "GitHub Ref: $GITHUB_REF"
      echo "GitHub SHA: $GITHUB_SHA"
      echo "GitHub Actor: $GITHUB_ACTOR"
      echo "Runner OS: $RUNNER_OS"
      echo "Runner Temp: $RUNNER_TEMP"
```

### Set Environment Variable for Future Steps
```yaml
steps:
  - name: Set environment variable
    run: echo "MY_VAR=hello" >> $GITHUB_ENV

  - name: Use environment variable
    run: echo "Value: $MY_VAR"
```

## Secrets

### Using Secrets
```yaml
steps:
  - name: Use secret in command
    run: |
      echo "Deploying with API key"
    env:
      API_KEY: ${{ secrets.API_KEY }}

  - name: Use secret in action
    uses: some/action@v1
    with:
      token: ${{ secrets.GITHUB_TOKEN }}
      api-key: ${{ secrets.API_KEY }}
```

### GitHub Token (Automatic)
```yaml
steps:
  # GITHUB_TOKEN is automatically provided
  - name: Checkout with token
    uses: actions/checkout@v4
    with:
      token: ${{ secrets.GITHUB_TOKEN }}

  - name: Create release
    uses: actions/create-release@v1
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### Organization and Repository Secrets
```yaml
# Use repository secret
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}

# Use organization secret (same syntax)
env:
  ORG_TOKEN: ${{ secrets.ORG_TOKEN }}
```

## Artifacts

### Upload Artifacts
```yaml
steps:
  - name: Build application
    run: npm run build

  - name: Upload build artifacts
    uses: actions/upload-artifact@v4
    with:
      name: build-output
      path: dist/
      retention-days: 5

  - name: Upload multiple paths
    uses: actions/upload-artifact@v4
    with:
      name: app-artifacts
      path: |
        dist/
        reports/*.xml
        logs/**/*.log
```

### Download Artifacts
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download build artifacts
        uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/

      - name: Deploy
        run: echo "Deploying from dist/"
```

### Download All Artifacts
```yaml
steps:
  - name: Download all artifacts
    uses: actions/download-artifact@v4
```

## Caching

### Cache Dependencies
```yaml
steps:
  - uses: actions/checkout@v4

  # Cache npm dependencies
  - name: Cache npm dependencies
    uses: actions/cache@v3
    with:
      path: ~/.npm
      key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
      restore-keys: |
        ${{ runner.os }}-npm-

  - run: npm ci
```

### Cache Multiple Paths
```yaml
steps:
  - name: Cache dependencies
    uses: actions/cache@v3
    with:
      path: |
        ~/.npm
        ~/.cache
        node_modules
      key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
```

### Language-Specific Caching

#### Node.js with npm
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'npm'                   # Automatic npm caching
```

#### Python with pip
```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'                   # Automatic pip caching
```

#### Java with Maven
```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: 'maven'                 # Automatic Maven caching
```

#### Java with Gradle
```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: 'gradle'                # Automatic Gradle caching
```

## Matrix Strategy

### Basic Matrix
```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

### Multi-Dimensional Matrix
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
        # Creates 9 jobs (3 OS × 3 Node versions)

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm test
```

### Matrix with Include
```yaml
strategy:
  matrix:
    node-version: [16, 18]
    os: [ubuntu-latest, windows-latest]
    include:
      # Add specific configuration
      - node-version: 20
        os: ubuntu-latest
        experimental: true
```

### Matrix with Exclude
```yaml
strategy:
  matrix:
    node-version: [16, 18, 20]
    os: [ubuntu-latest, windows-latest, macos-latest]
    exclude:
      # Don't test Node 16 on macOS
      - node-version: 16
        os: macos-latest
```

### Fail-Fast Strategy
```yaml
strategy:
  fail-fast: false                 # Don't cancel other jobs if one fails
  matrix:
    node-version: [16, 18, 20]
```

### Max Parallel Jobs
```yaml
strategy:
  max-parallel: 2                  # Run max 2 matrix jobs at once
  matrix:
    node-version: [16, 18, 20]
```

## Reusable Workflows

### Define Reusable Workflow
```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy Workflow

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
      version:
        required: false
        type: string
        default: 'latest'
    secrets:
      deploy-token:
        required: true
    outputs:
      deployment-url:
        description: "Deployment URL"
        value: ${{ jobs.deploy.outputs.url }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    outputs:
      url: ${{ steps.deploy.outputs.url }}
    steps:
      - name: Deploy to ${{ inputs.environment }}
        id: deploy
        run: |
          echo "Deploying version ${{ inputs.version }}"
          echo "url=https://${{ inputs.environment }}.example.com" >> $GITHUB_OUTPUT
        env:
          TOKEN: ${{ secrets.deploy-token }}
```

### Call Reusable Workflow
```yaml
# .github/workflows/main.yml
name: Main Workflow

on: [push]

jobs:
  deploy-staging:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
      version: '1.0.0'
    secrets:
      deploy-token: ${{ secrets.STAGING_TOKEN }}

  deploy-production:
    needs: deploy-staging
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
    secrets:
      deploy-token: ${{ secrets.PROD_TOKEN }}
```

## Custom Actions

### JavaScript Action Structure
```
my-action/
├── action.yml
├── index.js
└── package.json
```

### action.yml
```yaml
name: 'My Custom Action'
description: 'Does something useful'
inputs:
  input-name:
    description: 'Input description'
    required: true
    default: 'default-value'
outputs:
  output-name:
    description: 'Output description'
runs:
  using: 'node20'
  main: 'index.js'
```

### Composite Action
```yaml
# action.yml
name: 'Setup Node.js and Install'
description: 'Setup Node.js and install dependencies'

inputs:
  node-version:
    description: 'Node.js version'
    required: true
    default: '18'

runs:
  using: 'composite'
  steps:
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
        cache: 'npm'

    - name: Install dependencies
      shell: bash
      run: npm ci

    - name: Print version
      shell: bash
      run: node --version
```

### Use Custom Action
```yaml
steps:
  - name: Use custom action
    uses: ./.github/actions/my-action
    with:
      input-name: value
```

## Commonly Used Actions

### Checkout
```yaml
- name: Checkout code
  uses: actions/checkout@v4
  with:
    fetch-depth: 0                 # Fetch all history
    submodules: true               # Checkout submodules
    token: ${{ secrets.GITHUB_TOKEN }}
```

### Setup Languages

#### Node.js
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'npm'
    registry-url: 'https://registry.npmjs.org'
```

#### Python
```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'
```

#### Java
```yaml
- uses: actions/setup-java@v4
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: 'gradle'
```

#### Go
```yaml
- uses: actions/setup-go@v5
  with:
    go-version: '1.21'
    cache: true
```

### Docker
```yaml
# Build and push Docker image
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

- name: Build and push
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: user/app:latest
```

### Deploy to Cloud

#### Deploy to AWS
```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy to S3
  run: aws s3 sync ./dist s3://my-bucket
```

#### Deploy to Azure
```yaml
- name: Login to Azure
  uses: azure/login@v1
  with:
    creds: ${{ secrets.AZURE_CREDENTIALS }}

- name: Deploy to Azure Web App
  uses: azure/webapps-deploy@v2
  with:
    app-name: my-web-app
    package: ./dist
```

#### Deploy to GCP
```yaml
- name: Authenticate to GCP
  uses: google-github-actions/auth@v2
  with:
    credentials_json: ${{ secrets.GCP_CREDENTIALS }}

- name: Deploy to Cloud Run
  uses: google-github-actions/deploy-cloudrun@v2
  with:
    service: my-service
    image: gcr.io/project/image:latest
```

## CI/CD Patterns

### Node.js CI/CD
```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16, 18, 20]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-${{ matrix.node-version }}
          path: dist/

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Download artifacts
        uses: actions/download-artifact@v4
        with:
          name: build-18

      - name: Deploy to production
        run: echo "Deploying..."
```

### Python CI/CD
```yaml
name: Python CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version: ['3.9', '3.10', '3.11']

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest pytest-cov black flake8

      - name: Lint with flake8
        run: flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics

      - name: Format with black
        run: black --check .

      - name: Test with pytest
        run: pytest --cov=./ --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
```

### Docker Build and Push
```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]
    tags: [ 'v*.*.*' ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Setup Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Security Best Practices

### Pin Action Versions
```yaml
# Bad - uses latest
- uses: actions/checkout@v4

# Good - pin to specific SHA
- uses: actions/checkout@8e5e7e5ab8b370d6c329ec480221332ada57f0ab  # v4.1.0
```

### Limit Permissions
```yaml
permissions:
  contents: read                   # Read repository contents
  pull-requests: write             # Write to pull requests
  issues: write                    # Write to issues

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read               # Override at job level
```

### Secure Secrets Usage
```yaml
steps:
  # Don't log secrets
  - name: Use secret
    run: |
      # Bad - might expose in logs
      echo "Token: ${{ secrets.TOKEN }}"

      # Good - use as environment variable
    env:
      TOKEN: ${{ secrets.TOKEN }}
```

### Validate Inputs
```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        type: choice                # Use choice instead of string
        options:
          - dev
          - staging
          - prod

jobs:
  deploy:
    steps:
      - name: Validate environment
        run: |
          if [[ ! "${{ inputs.environment }}" =~ ^(dev|staging|prod)$ ]]; then
            echo "Invalid environment"
            exit 1
          fi
```

### Use CODEOWNERS
```
# .github/CODEOWNERS
# Require approval for workflow changes
.github/workflows/ @org/security-team
```

## Debugging & Troubleshooting

### Enable Debug Logging
```yaml
# Set repository secrets:
# ACTIONS_RUNNER_DEBUG = true
# ACTIONS_STEP_DEBUG = true

# Or enable in workflow
steps:
  - name: Enable debug logging
    run: |
      echo "ACTIONS_RUNNER_DEBUG=true" >> $GITHUB_ENV
      echo "ACTIONS_STEP_DEBUG=true" >> $GITHUB_ENV
```

### Debug Step
```yaml
steps:
  - name: Debug information
    run: |
      echo "Event: ${{ github.event_name }}"
      echo "Ref: ${{ github.ref }}"
      echo "SHA: ${{ github.sha }}"
      echo "Actor: ${{ github.actor }}"
      echo "Runner OS: ${{ runner.os }}"
      env
```

### Tmate Debugging (Interactive SSH)
```yaml
steps:
  - name: Setup tmate session
    uses: mxschmitt/action-tmate@v3
    if: failure()                  # Only on failure
```

### Job Summaries
```yaml
steps:
  - name: Create job summary
    run: |
      echo "## Test Results" >> $GITHUB_STEP_SUMMARY
      echo "✅ All tests passed" >> $GITHUB_STEP_SUMMARY
      echo "" >> $GITHUB_STEP_SUMMARY
      echo "| Test | Result |" >> $GITHUB_STEP_SUMMARY
      echo "|------|--------|" >> $GITHUB_STEP_SUMMARY
      echo "| Unit | ✅ Pass |" >> $GITHUB_STEP_SUMMARY
```

### Annotations
```yaml
steps:
  - name: Annotate with error
    run: |
      echo "::error file=app.js,line=10,col=5::Missing semicolon"
      echo "::warning file=test.js,line=20::Deprecated function"
      echo "::notice file=README.md::Documentation updated"
```

### Cancel Redundant Runs
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true         # Cancel previous runs
```

## References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)
- [GitHub Actions Contexts](https://docs.github.com/en/actions/learn-github-actions/contexts)
- [Security Hardening Guide](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [Awesome Actions](https://github.com/sdras/awesome-actions)
