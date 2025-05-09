# Jenkinsfile Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Pipeline Syntax](#pipeline-syntax)
- [Basic Structure](#basic-structure)
- [Stages and Steps](#stages-and-steps)
- [Parallel Execution](#parallel-execution)
- [Post Actions](#post-actions)
- [Parameters](#parameters)
- [Environment Variables](#environment-variables)
- [Credentials](#credentials)
- [Shared Libraries](#shared-libraries)
- [Triggers](#triggers)
- [Artifacts and Archiving](#artifacts-and-archiving)
- [Timeouts and Retries](#timeouts-and-retries)
- [Dynamic Agent Selection](#dynamic-agent-selection)
- [Matrix Builds](#matrix-builds)
- [Best Practices](#best-practices)
- [References](#references)

## Introduction
A Jenkinsfile defines a Jenkins Pipeline as code, enabling reproducible and version-controlled build processes.

## Pipeline Syntax
- **Declarative** (preferred, structured)
- **Scripted** (more flexible, uses Groovy scripting)

## Basic Structure
### Declarative Example
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### Scripted Example
```groovy
node {
    stage('Build') {
        echo 'Building...'
    }
    stage('Test') {
        echo 'Testing...'
    }
    stage('Deploy') {
        echo 'Deploying...'
    }
}
```

## Stages and Steps
Stages group steps logically:
```groovy
stages {
    stage('Compile') {
        steps {
            sh 'javac MyApp.java'
        }
    }
    stage('Package') {
        steps {
            sh 'jar cf MyApp.jar MyApp.class'
        }
    }
}
```

## Parallel Execution
Run multiple branches simultaneously:
```groovy
stage('Parallel Stage') {
    parallel {
        stage('Unit Tests') {
            steps {
                sh 'run-unit-tests.sh'
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'run-integration-tests.sh'
            }
        }
    }
}
```

## Post Actions
Handle success, failure, always scenarios:
```groovy
post {
    always {
        echo 'Cleaning up...'
    }
    success {
        echo 'Pipeline succeeded!'
    }
    failure {
        echo 'Pipeline failed.'
    }
}
```

## Parameters
Define parameters for builds:
```groovy
parameters {
    string(name: 'BRANCH', defaultValue: 'main', description: 'Branch to build')
    booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run tests?')
}
```

Use in steps:
```groovy
steps {
    echo "Building branch: ${params.BRANCH}"
}
```

## Environment Variables
Set environment variables:
```groovy
environment {
    APP_NAME = 'MyApp'
    BUILD_ENV = "${params.ENVIRONMENT}"
}
```

Access with:
```groovy
steps {
    echo "Deploying ${env.APP_NAME} to ${env.BUILD_ENV}"
}
```

## Credentials
Use Jenkins credentials plugin:
```groovy
environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
}
```

Or in steps:
```groovy
withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
    sh 'git clone https://${GIT_USER}:${GIT_PASS}@github.com/myrepo.git'
}
```

## Shared Libraries
Reuse common functions:
```groovy
@Library('my-shared-library') _

myCustomStep()
```

## Triggers
Automate builds:
```groovy
triggers {
    cron('H 4 * * 1-5')       // Weekdays at 4am
    pollSCM('H/15 * * * *')   // Poll SCM every 15 mins
}
```

## Artifacts and Archiving
Archive artifacts for later retrieval:
```groovy
steps {
    archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
}
```

Publish test results:
```groovy
steps {
    junit '**/target/surefire-reports/*.xml'
}
```

## Timeouts and Retries
Timeouts for stages or steps:
```groovy
options {
    timeout(time: 1, unit: 'HOURS')
}
```

Retry failed steps:
```groovy
steps {
    retry(3) {
        sh 'unstable-command.sh'
    }
}
```

## Dynamic Agent Selection
Choose agent at runtime:
```groovy
pipeline {
    agent {
        label params.AGENT
    }
}
```
Or scripted:
```groovy
node(params.AGENT) {
    stage('Build') {
        echo "Building on ${params.AGENT}"
    }
}
```

## Matrix Builds
Run combinations of parameters:
```groovy
matrix {
    axes {
        axis {
            name 'OS'
            values 'linux', 'windows'
        }
        axis {
            name 'BROWSER'
            values 'chrome', 'firefox'
        }
    }
    stages {
        stage('Test') {
            steps {
                echo "Testing on ${OS} with ${BROWSER}"
            }
        }
    }
}
```

## Best Practices
- Prefer declarative pipelines for simplicity
- Use stages clearly to separate concerns
- Use parameters for flexible pipelines
- Handle failures gracefully with `post` blocks
- Externalize secrets into credentials
- Modularize with shared libraries
- Keep pipelines fast and efficient
- Use retries and timeouts to avoid hanging builds

## References
- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Jenkins Declarative Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)

