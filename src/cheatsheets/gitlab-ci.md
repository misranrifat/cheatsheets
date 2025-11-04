# GitLab CI/CD Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Pipeline Configuration](#pipeline-configuration)
- [Basic Syntax](#basic-syntax)
- [Jobs](#jobs)
- [Stages](#stages)
- [Variables](#variables)
- [Scripts](#scripts)
- [Artifacts](#artifacts)
- [Caching](#caching)
- [Docker](#docker)
- [Services](#services)
- [Rules and Conditions](#rules-and-conditions)
- [Triggers](#triggers)
- [Include and Extends](#include-and-extends)
- [Parallel and Matrix](#parallel-and-matrix)
- [Environments](#environments)
- [Dependencies](#dependencies)
- [Retry and Timeout](#retry-and-timeout)
- [GitLab CI/CD Keywords](#gitlab-cicd-keywords)
- [Common Patterns](#common-patterns)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Introduction

GitLab CI/CD is a continuous integration and deployment tool built into GitLab. Pipelines are defined in `.gitlab-ci.yml` files in the repository root.

## Pipeline Configuration

### File Location
```
.gitlab-ci.yml                     # Pipeline configuration file (repository root)
```

### Minimal Pipeline
```yaml
# .gitlab-ci.yml
build:
  script:
    - echo "Building the application"
    - npm install
    - npm run build
```

## Basic Syntax

### Complete Example
```yaml
# .gitlab-ci.yml
image: node:18                     # Default Docker image

stages:                            # Define pipeline stages
  - build
  - test
  - deploy

variables:                         # Global variables
  NODE_ENV: production

before_script:                     # Run before each job
  - echo "Starting job"

after_script:                      # Run after each job
  - echo "Job completed"

build-job:
  stage: build
  script:
    - npm install
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week

test-job:
  stage: test
  script:
    - npm test
  dependencies:
    - build-job

deploy-job:
  stage: deploy
  script:
    - npm run deploy
  only:
    - main
  environment:
    name: production
    url: https://example.com
```

## Jobs

### Basic Job
```yaml
job-name:
  script:
    - echo "Running job"
```

### Job with Stage
```yaml
build:
  stage: build
  script:
    - echo "Building..."
```

### Job with Image
```yaml
build:
  image: node:18                   # Use specific Docker image
  script:
    - npm run build
```

### Job with Tags
```yaml
build:
  tags:
    - docker                       # Use runner with 'docker' tag
    - linux
  script:
    - make build
```

### Job Allow Failure
```yaml
lint:
  script:
    - npm run lint
  allow_failure: true              # Job can fail without failing pipeline
```

### Job When Conditions
```yaml
deploy:
  script:
    - echo "Deploying"
  when: manual                     # Require manual trigger

# Options: on_success (default), on_failure, always, manual, delayed
```

### Job with Delay
```yaml
deploy:
  script:
    - echo "Deploying after delay"
  when: delayed
  start_in: 30 minutes
```

### Parallel Jobs
```yaml
test:
  script:
    - npm test
  parallel: 5                      # Run 5 instances in parallel
```

### Job Needs (DAG)
```yaml
build:
  stage: build
  script:
    - make build

test:
  stage: test
  needs: [build]                   # Start immediately after build
  script:
    - make test
```

## Stages

### Define Stages
```yaml
stages:
  - build
  - test
  - deploy
  - cleanup

# Jobs run in order: build -> test -> deploy -> cleanup
# Jobs in same stage run in parallel
```

### Default Stages
```yaml
# If not defined, GitLab uses:
stages:
  - .pre
  - build
  - test
  - deploy
  - .post
```

### Job Without Stage
```yaml
# Jobs without stage assignment use 'test' stage by default
my-job:
  script:
    - echo "Runs in test stage"
```

## Variables

### Global Variables
```yaml
variables:
  DATABASE_URL: "postgres://localhost/db"
  API_KEY: "default-key"
  DEPLOY_ENV: "staging"
```

### Job-Level Variables
```yaml
deploy:
  variables:
    DEPLOY_ENV: "production"       # Override global variable
  script:
    - echo "Deploying to $DEPLOY_ENV"
```

### Predefined Variables
```yaml
build:
  script:
    - echo "CI_COMMIT_SHA: $CI_COMMIT_SHA"
    - echo "CI_COMMIT_REF_NAME: $CI_COMMIT_REF_NAME"
    - echo "CI_PROJECT_NAME: $CI_PROJECT_NAME"
    - echo "CI_PIPELINE_ID: $CI_PIPELINE_ID"
    - echo "CI_JOB_ID: $CI_JOB_ID"
    - echo "CI_REGISTRY: $CI_REGISTRY"
    - echo "CI_REGISTRY_USER: $CI_REGISTRY_USER"
    - echo "GITLAB_USER_LOGIN: $GITLAB_USER_LOGIN"
```

### Protected Variables
```yaml
# Set in GitLab UI: Settings > CI/CD > Variables
# Mark as "Protected" to only expose on protected branches
deploy:
  script:
    - echo "Using protected variable: $SECRET_API_KEY"
  only:
    - main
```

### Masked Variables
```yaml
# Masked variables are hidden in job logs
# Set in GitLab UI with "Masked" option
deploy:
  script:
    - echo "Password is masked in logs"
    - curl -u admin:$ADMIN_PASSWORD https://api.example.com
```

### File Variables
```yaml
# Variables stored as files
# Set in GitLab UI with "File" type
deploy:
  script:
    - cat $SERVICE_ACCOUNT_KEY     # Path to file containing the key
    - gcloud auth activate-service-account --key-file=$SERVICE_ACCOUNT_KEY
```

### Environment-Specific Variables
```yaml
variables:
  DEPLOY_URL: "https://staging.example.com"

deploy-production:
  variables:
    DEPLOY_URL: "https://example.com"
  script:
    - echo "Deploying to $DEPLOY_URL"
  only:
    - main
```

## Scripts

### Single Command
```yaml
build:
  script:
    - npm run build
```

### Multiple Commands
```yaml
build:
  script:
    - echo "Installing dependencies"
    - npm ci
    - echo "Building application"
    - npm run build
    - echo "Build complete"
```

### Multi-Line Commands
```yaml
test:
  script:
    - |
      echo "Running tests"
      npm test
      echo "Tests complete"
```

### Before Script
```yaml
before_script:                     # Runs before every job
  - echo "Setting up environment"
  - apt-get update -qq

job1:
  script:
    - make build

job2:
  before_script:                   # Override global before_script
    - echo "Custom setup for job2"
  script:
    - make test
```

### After Script
```yaml
after_script:                      # Runs after every job (even if job fails)
  - echo "Cleaning up"
  - rm -rf temp/

job:
  script:
    - make build
  after_script:
    - echo "Custom cleanup"
```

## Artifacts

### Basic Artifacts
```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/                      # Save dist/ directory
```

### Multiple Paths
```yaml
build:
  script:
    - make build
  artifacts:
    paths:
      - build/
      - dist/
      - reports/*.xml
```

### Artifacts Expiration
```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week              # Delete after 1 week
    # Options: 30 mins, 1 hour, 1 day, 1 week, 1 month, 1 year, never
```

### Artifacts Name
```yaml
build:
  script:
    - npm run build
  artifacts:
    name: "$CI_JOB_NAME-$CI_COMMIT_REF_NAME"
    paths:
      - dist/
```

### Artifacts When
```yaml
test:
  script:
    - npm test
  artifacts:
    when: on_failure               # Only save on failure
    paths:
      - logs/
    # Options: on_success (default), on_failure, always
```

### Exclude Paths
```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    exclude:
      - dist/**/*.map              # Exclude source maps
      - dist/temp/
```

### Artifacts Reports
```yaml
test:
  script:
    - npm test
  artifacts:
    reports:
      junit: report.xml            # JUnit test report
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
```

### Download Artifacts
```yaml
deploy:
  stage: deploy
  dependencies:
    - build                        # Download artifacts from build job
  script:
    - ls -la dist/
    - echo "Deploying artifacts"
```

## Caching

### Basic Cache
```yaml
build:
  cache:
    paths:
      - node_modules/              # Cache node_modules
  script:
    - npm ci
    - npm run build
```

### Cache Key
```yaml
build:
  cache:
    key: $CI_COMMIT_REF_SLUG       # Different cache per branch
    paths:
      - node_modules/
  script:
    - npm ci
```

### Cache with Files
```yaml
build:
  cache:
    key:
      files:
        - package-lock.json        # Cache key based on file hash
    paths:
      - node_modules/
  script:
    - npm ci
```

### Multiple Caches
```yaml
build:
  cache:
    - key: npm
      paths:
        - node_modules/
    - key: build
      paths:
        - .cache/
  script:
    - npm ci
    - npm run build
```

### Cache Policy
```yaml
build:
  cache:
    key: npm-cache
    paths:
      - node_modules/
    policy: pull-push              # Download and upload (default)
  script:
    - npm ci

test:
  cache:
    key: npm-cache
    paths:
      - node_modules/
    policy: pull                   # Only download, don't upload
  script:
    - npm test
```

### Global Cache
```yaml
cache:                             # Global cache for all jobs
  key: $CI_COMMIT_REF_SLUG
  paths:
    - node_modules/

build:
  script:
    - npm ci
    - npm run build

test:
  script:
    - npm test
```

## Docker

### Use Docker Image
```yaml
build:
  image: node:18-alpine            # Use specific image
  script:
    - npm run build
```

### Docker in Docker
```yaml
build-image:
  image: docker:latest
  services:
    - docker:dind                  # Docker-in-Docker service
  script:
    - docker build -t myapp .
    - docker push myapp
```

### Build and Push Docker Image
```yaml
docker-build:
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
```

### Multi-Stage Docker Build
```yaml
variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

build-docker:
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build --target production -t $CI_REGISTRY_IMAGE:latest .
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker push $CI_REGISTRY_IMAGE:latest
```

## Services

### Database Service
```yaml
test:
  image: node:18
  services:
    - postgres:15
    - redis:7
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: testuser
    POSTGRES_PASSWORD: testpass
    POSTGRES_HOST_AUTH_METHOD: trust
  script:
    - npm test
```

### Service with Alias
```yaml
test:
  image: node:18
  services:
    - name: postgres:15
      alias: db                    # Access as 'db' hostname
  variables:
    DATABASE_URL: postgres://db:5432/testdb
  script:
    - npm test
```

### MySQL Service
```yaml
test:
  image: node:18
  services:
    - mysql:8.0
  variables:
    MYSQL_DATABASE: testdb
    MYSQL_ROOT_PASSWORD: rootpass
    MYSQL_USER: testuser
    MYSQL_PASSWORD: testpass
  script:
    - npm test
```

## Rules and Conditions

### Basic Rules
```yaml
deploy:
  script:
    - echo "Deploying"
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: always
    - when: never
```

### Multiple Rules
```yaml
deploy:
  script:
    - echo "Deploying"
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      when: on_success
    - if: $CI_COMMIT_BRANCH == "staging"
      when: manual
    - when: never
```

### Rules with Changes
```yaml
build:
  script:
    - npm run build
  rules:
    - changes:
        - src/**/*.js
        - package.json
      when: always
    - when: never
```

### Rules with Exists
```yaml
deploy:
  script:
    - echo "Deploying"
  rules:
    - exists:
        - Dockerfile
      when: always
```

### Rules Variables
```yaml
deploy:
  script:
    - echo "Deploying to $ENVIRONMENT"
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
      variables:
        ENVIRONMENT: "production"
    - if: $CI_COMMIT_BRANCH == "develop"
      variables:
        ENVIRONMENT: "staging"
```

### Only/Except (Legacy)
```yaml
# Use 'rules' instead (recommended)
deploy:
  script:
    - echo "Deploying"
  only:
    - main
    - tags
  except:
    - schedules
```

## Triggers

### Upstream Trigger
```yaml
trigger-downstream:
  stage: deploy
  trigger:
    project: group/downstream-project
    branch: main
```

### Multi-Project Pipeline
```yaml
trigger-child:
  trigger:
    include: .gitlab-ci-child.yml
```

### Pipeline Trigger with Variables
```yaml
trigger:
  stage: deploy
  trigger:
    project: group/project
    branch: main
  variables:
    DEPLOY_ENV: production
```

## Include and Extends

### Include External File
```yaml
include:
  - local: '/.gitlab-ci-templates/build.yml'
  - project: 'group/shared-ci'
    file: '/templates/deploy.yml'
  - remote: 'https://example.com/ci-template.yml'
  - template: Auto-DevOps.gitlab-ci.yml
```

### Extends (Inheritance)
```yaml
.deploy-template:                  # Hidden job (starts with .)
  script:
    - echo "Deploying"
  only:
    - main

deploy-staging:
  extends: .deploy-template
  variables:
    ENVIRONMENT: staging

deploy-production:
  extends: .deploy-template
  variables:
    ENVIRONMENT: production
```

### Multiple Extends
```yaml
.base-job:
  image: node:18
  before_script:
    - npm ci

.deploy-job:
  script:
    - npm run deploy

deploy:
  extends:
    - .base-job
    - .deploy-job
```

### Include with Variables
```yaml
include:
  - local: 'templates/build.yml'
    rules:
      - if: $CI_COMMIT_BRANCH == "main"
```

## Parallel and Matrix

### Parallel Execution
```yaml
test:
  script:
    - npm test
  parallel: 5                      # Run 5 instances
```

### Parallel Matrix
```yaml
test:
  script:
    - bundle exec rspec
  parallel:
    matrix:
      - RUBY_VERSION: ['2.7', '3.0', '3.1']
        DATABASE: ['mysql', 'postgres']
  # Creates 6 jobs (3 Ruby × 2 DB)
```

### Matrix with Image
```yaml
test:
  parallel:
    matrix:
      - IMAGE: ['node:16', 'node:18', 'node:20']
  image: $IMAGE
  script:
    - npm test
```

## Environments

### Basic Environment
```yaml
deploy:
  stage: deploy
  script:
    - echo "Deploying to production"
  environment:
    name: production
    url: https://example.com
```

### Dynamic Environment
```yaml
deploy:
  stage: deploy
  script:
    - echo "Deploying to $CI_COMMIT_REF_NAME"
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://$CI_COMMIT_REF_SLUG.example.com
  only:
    - branches
  except:
    - main
```

### Environment with On Stop
```yaml
deploy-review:
  stage: deploy
  script:
    - echo "Deploying review app"
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://$CI_COMMIT_REF_SLUG.example.com
    on_stop: stop-review
  only:
    - branches
  except:
    - main

stop-review:
  stage: deploy
  script:
    - echo "Stopping review app"
  environment:
    name: review/$CI_COMMIT_REF_NAME
    action: stop
  when: manual
  only:
    - branches
  except:
    - main
```

### Environment with Auto Stop
```yaml
deploy-review:
  stage: deploy
  script:
    - echo "Deploying review app"
  environment:
    name: review/$CI_COMMIT_REF_NAME
    auto_stop_in: 1 week
  only:
    - branches
  except:
    - main
```

## Dependencies

### Specify Dependencies
```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - build/

test:
  stage: test
  dependencies:
    - build                        # Only download artifacts from build
  script:
    - make test

deploy:
  stage: deploy
  dependencies: []                 # Don't download any artifacts
  script:
    - make deploy
```

### Needs (DAG)
```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - build/

test:
  stage: test
  needs: [build]                   # Start immediately after build
  script:
    - make test
```

### Needs with Artifacts
```yaml
build:
  stage: build
  script:
    - make build
  artifacts:
    paths:
      - build/

test:
  stage: test
  needs:
    - job: build
      artifacts: true              # Download artifacts (default)
  script:
    - make test

deploy:
  stage: deploy
  needs:
    - job: build
      artifacts: false             # Don't download artifacts
  script:
    - make deploy
```

## Retry and Timeout

### Retry on Failure
```yaml
test:
  script:
    - npm test
  retry: 2                         # Retry up to 2 times on failure
```

### Retry with When
```yaml
test:
  script:
    - npm test
  retry:
    max: 2
    when:
      - runner_system_failure
      - stuck_or_timeout_failure
    # Options: always, unknown_failure, script_failure, api_failure,
    #          stuck_or_timeout_failure, runner_system_failure,
    #          missing_dependency_failure, runner_unsupported,
    #          stale_schedule, job_execution_timeout, archived_failure,
    #          unmet_prerequisites, scheduler_failure, data_integrity_failure
```

### Job Timeout
```yaml
test:
  script:
    - npm test
  timeout: 30 minutes              # Job-specific timeout
```

### Global Timeout
```yaml
default:
  timeout: 1 hour                  # Default timeout for all jobs
```

## GitLab CI/CD Keywords

### Complete Keyword Reference
```yaml
# Job definition
job-name:
  # Execution
  stage: build                     # Stage assignment
  script:                          # Commands to execute
    - echo "Building"
  before_script:                   # Run before script
    - echo "Setup"
  after_script:                    # Run after script (always)
    - echo "Cleanup"

  # Docker
  image: node:18                   # Docker image
  services:                        # Docker services
    - postgres:15

  # Control flow
  rules:                           # Conditional execution (recommended)
    - if: $CI_COMMIT_BRANCH == "main"
  only:                            # Legacy: when to run
    - main
  except:                          # Legacy: when not to run
    - schedules
  when: manual                     # Execution condition
  allow_failure: true              # Don't fail pipeline if job fails

  # Artifacts
  artifacts:
    paths:                         # Artifact paths
      - dist/
    expire_in: 1 week              # Artifact expiration
    name: artifacts-name           # Artifact name
    when: on_success               # When to upload
    exclude:                       # Paths to exclude
      - dist/*.map
    reports:                       # Test/coverage reports
      junit: report.xml

  # Cache
  cache:
    key: cache-key                 # Cache identifier
    paths:                         # Cache paths
      - node_modules/
    policy: pull-push              # Cache policy

  # Dependencies
  dependencies:                    # Artifact dependencies
    - build
  needs:                           # Job dependencies (DAG)
    - build

  # Environment
  environment:
    name: production               # Environment name
    url: https://example.com       # Environment URL
    on_stop: stop-job              # Stop action
    auto_stop_in: 1 week           # Auto-stop timer

  # Variables
  variables:
    VAR_NAME: value                # Job variables

  # Parallel execution
  parallel: 5                      # Number of parallel instances
  parallel:
    matrix:                        # Matrix build
      - VAR: [val1, val2]

  # Runner selection
  tags:                            # Runner tags
    - docker

  # Retry and timeout
  retry: 2                         # Retry count
  timeout: 30 minutes              # Job timeout

  # Other
  resource_group: production       # Serialize jobs
  coverage: '/Coverage: \d+\.\d+%/' # Coverage regex
  interruptible: true              # Can be interrupted
```

## Common Patterns

### Node.js CI/CD
```yaml
image: node:18

stages:
  - install
  - test
  - build
  - deploy

cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/

install:
  stage: install
  script:
    - npm ci
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 day

lint:
  stage: test
  script:
    - npm run lint
  needs: [install]

test:
  stage: test
  script:
    - npm test
  coverage: '/Statements\s*:\s*(\d+\.?\d*)%/'
  artifacts:
    reports:
      junit: junit.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
  needs: [install]

build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week
  needs: [install]

deploy-staging:
  stage: deploy
  script:
    - npm run deploy
  environment:
    name: staging
    url: https://staging.example.com
  needs: [build]
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

deploy-production:
  stage: deploy
  script:
    - npm run deploy
  environment:
    name: production
    url: https://example.com
  needs: [build]
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

### Python CI/CD
```yaml
image: python:3.11

stages:
  - test
  - build
  - deploy

cache:
  key:
    files:
      - requirements.txt
  paths:
    - .venv/

before_script:
  - python -m venv venv
  - source venv/bin/activate
  - pip install -r requirements.txt

lint:
  stage: test
  script:
    - pip install flake8 black
    - flake8 .
    - black --check .

test:
  stage: test
  script:
    - pip install pytest pytest-cov
    - pytest --cov=./ --cov-report=xml --cov-report=term
  coverage: '/TOTAL.*\s+(\d+%)$/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml

build:
  stage: build
  script:
    - pip install build
    - python -m build
  artifacts:
    paths:
      - dist/

deploy:
  stage: deploy
  script:
    - pip install twine
    - twine upload dist/*
  rules:
    - if: $CI_COMMIT_TAG
  when: manual
```

### Docker Build and Push
```yaml
variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

stages:
  - build
  - deploy

build-image:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA .
    - docker build -t $CI_REGISTRY_IMAGE:latest .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
    - docker push $CI_REGISTRY_IMAGE:latest
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy-k8s:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl set image deployment/myapp myapp=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA
  environment:
    name: production
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
  when: manual
```

### Multi-Environment Deployment
```yaml
stages:
  - build
  - deploy

build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/

.deploy-template:
  stage: deploy
  script:
    - echo "Deploying to $ENVIRONMENT"
    - npm run deploy

deploy-dev:
  extends: .deploy-template
  variables:
    ENVIRONMENT: development
  environment:
    name: development
    url: https://dev.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

deploy-staging:
  extends: .deploy-template
  variables:
    ENVIRONMENT: staging
  environment:
    name: staging
    url: https://staging.example.com
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy-production:
  extends: .deploy-template
  variables:
    ENVIRONMENT: production
  environment:
    name: production
    url: https://example.com
  rules:
    - if: $CI_COMMIT_TAG
  when: manual
```

## Best Practices

### Use Templates and Extends
```yaml
# Define reusable templates
.deploy-template:
  script:
    - deploy.sh
  only:
    - main

# Extend templates
deploy-staging:
  extends: .deploy-template
  variables:
    ENV: staging
```

### Pin Docker Images
```yaml
# Bad - uses latest
image: node:latest

# Good - pin specific version
image: node:18.17.0-alpine
```

### Use Cache Effectively
```yaml
# Cache based on lock file
cache:
  key:
    files:
      - package-lock.json
  paths:
    - node_modules/
```

### Fail Fast
```yaml
# Run quick jobs first
stages:
  - lint          # Fast
  - test          # Medium
  - build         # Slow
  - deploy        # Manual
```

### Use Artifacts Wisely
```yaml
build:
  artifacts:
    paths:
      - dist/
    expire_in: 1 week              # Set expiration
    exclude:
      - dist/**/*.map              # Exclude unnecessary files
```

### Secure Secrets
```yaml
# Set secrets in GitLab UI as masked/protected variables
# Don't commit secrets in .gitlab-ci.yml
deploy:
  script:
    - echo "Using secret: $API_KEY"
  only:
    - main                         # Only on protected branches
```

### Use Rules Instead of Only/Except
```yaml
# Preferred (rules)
deploy:
  script:
    - deploy.sh
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

# Legacy (only/except)
deploy:
  script:
    - deploy.sh
  only:
    - main
```

### Limit Artifact Size
```yaml
build:
  artifacts:
    paths:
      - dist/
    exclude:
      - dist/**/*.map
      - dist/temp/
```

## Troubleshooting

### Debug CI/CD Variables
```yaml
debug:
  script:
    - echo "CI_COMMIT_SHA=$CI_COMMIT_SHA"
    - echo "CI_COMMIT_REF_NAME=$CI_COMMIT_REF_NAME"
    - echo "CI_PROJECT_NAME=$CI_PROJECT_NAME"
    - echo "CI_REGISTRY=$CI_REGISTRY"
    - env | sort
```

### Enable Debug Logging
```yaml
# Set CI_DEBUG_TRACE variable to 'true' in GitLab UI
# This will print all executed commands
```

### Check Runner Compatibility
```yaml
check-runner:
  script:
    - uname -a
    - docker --version
    - which git
    - env
  tags:
    - docker
```

### Validate YAML
```yaml
# Use GitLab CI Lint tool
# Project > CI/CD > Pipelines > CI Lint

# Or use GitLab API
# curl --header "PRIVATE-TOKEN: <token>" \
#   "https://gitlab.com/api/v4/projects/:id/ci/lint" \
#   --form "content@.gitlab-ci.yml"
```

### Common Issues

#### Job Stuck in Pending
```yaml
# Ensure runner with matching tags exists
job:
  tags:
    - docker    # Runner must have this tag
```

#### Artifacts Not Found
```yaml
# Ensure artifacts are uploaded before download
build:
  artifacts:
    paths:
      - dist/

deploy:
  dependencies:
    - build     # Download artifacts from build
  script:
    - ls -la dist/
```

#### Cache Not Working
```yaml
# Ensure cache key is consistent
cache:
  key: $CI_COMMIT_REF_SLUG  # Same key for branch
  paths:
    - node_modules/
```

## References

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab CI/CD YAML Reference](https://docs.gitlab.com/ee/ci/yaml/)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)
- [GitLab CI/CD Examples](https://docs.gitlab.com/ee/ci/examples/)
- [GitLab CI/CD Templates](https://gitlab.com/gitlab-org/gitlab/-/tree/master/lib/gitlab/ci/templates)
- [GitLab CI Lint Tool](https://gitlab.com/ci/lint)
