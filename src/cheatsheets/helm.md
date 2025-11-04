# Helm Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Concepts](#basic-concepts)
- [Basic Commands](#basic-commands)
- [Working with Charts](#working-with-charts)
- [Values Files](#values-files)
- [Repositories](#repositories)
- [Chart Development](#chart-development)
- [Template Functions](#template-functions)
- [Helm Upgrade and Rollback](#helm-upgrade-and-rollback)
- [Hooks](#hooks)
- [Subcharts and Dependencies](#subcharts-and-dependencies)
- [Helm Secrets](#helm-secrets)
- [Helmfile](#helmfile)
- [Testing Helm Charts](#testing-helm-charts)
- [Helm Plugins](#helm-plugins)
- [Security Best Practices](#security-best-practices)
- [References](#references)

## Introduction
Helm is the package manager for Kubernetes, used to deploy and manage applications with reusable templates called charts.

## Installation
```bash
brew install helm         # MacOS
choco install kubernetes-helm  # Windows
apt-get install helm      # Linux (via package manager)
```

## Basic Concepts
- **Chart**: A Helm package (application)
- **Release**: A running instance of a chart
- **Repository**: Place to store and share charts

## Basic Commands
```bash
helm version                      # Show Helm version
helm help                         # Get help on commands
helm search hub <keyword>         # Search charts on Artifact Hub
helm repo add <repo-name> <url>   # Add chart repository
helm repo update                  # Update repositories
helm install <release> <chart>    # Install a chart
helm upgrade <release> <chart>    # Upgrade a release
helm uninstall <release>          # Uninstall a release
helm list                         # List all releases
helm status <release>             # Status of a release
```

## Working with Charts
```bash
helm create mychart               # Create a new chart
helm package mychart              # Package chart into a tar.gz
helm lint mychart                 # Lint and validate chart
helm install myrelease ./mychart  # Install a local chart
```

## Values Files
- Customize chart configuration without modifying templates.
- `values.yaml` holds default values.

Override values:
```bash
helm install myrelease mychart -f custom-values.yaml
```
Or inline:
```bash
helm install myrelease mychart --set image.tag=2.0
```

Merge multiple files:
```bash
helm install myrelease mychart -f values1.yaml -f values2.yaml
```

## Repositories
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami/nginx
helm install mynginx bitnami/nginx
```

## Chart Development

Directory structure:
```
mychart/
  Chart.yaml       # Metadata
  values.yaml      # Default values
  charts/          # Subcharts
  templates/       # Kubernetes manifests (templated)
```

Example `Chart.yaml`:
```yaml
apiVersion: v2
name: mychart
version: 0.1.0
description: A simple Helm chart
```

## Template Functions
Common functions in templates:
- `{{ .Release.Name }}`: Release name
- `{{ .Values.key }}`: Access values
- `{{ include }}`: Include another template
- `{{ required "msg" .Values.key }}`: Fail if value is missing
- `{{ toYaml .Values }}`: Convert to YAML
- `{{ tpl }}`: Render template inside value

Conditionals:
```yaml
{{- if .Values.enabled }}
kind: Deployment
{{- end }}
```

Loops:
```yaml
{{- range .Values.items }}
- name: {{ .name }}
  value: {{ .value }}
{{- end }}
```

## Helm Upgrade and Rollback
```bash
helm upgrade myrelease mychart               # Upgrade a release
helm rollback myrelease 1                    # Rollback to revision 1
helm history myrelease                       # View release history
```

## Hooks
Special Kubernetes jobs triggered at lifecycle events:
```yaml
annotations:
  "helm.sh/hook": pre-install, pre-upgrade
```

Example hooks:
- pre-install
- post-install
- pre-upgrade
- post-upgrade
- pre-delete

## Subcharts and Dependencies
Define dependencies in `Chart.yaml`:
```yaml
dependencies:
- name: mysql
  version: 8.0.0
  repository: https://charts.bitnami.com/bitnami
```
Update dependencies:
```bash
helm dependency update
```

## Helm Secrets
Encrypt sensitive values using tools like `helm-secrets`:
```bash
helm secrets enc secrets.yaml
helm secrets dec secrets.yaml
```
Encrypted files can be committed safely to Git.

## Helmfile
Manage multiple releases and environments:
Install:
```bash
brew install helmfile
```
Example `helmfile.yaml`:
```yaml
releases:
- name: myapp
  namespace: default
  chart: ./charts/myapp
  values:
  - values.yaml
```
Apply all:
```bash
helmfile apply
```

## Testing Helm Charts
Run tests defined in templates:
```bash
helm test myrelease
```
Define tests inside templates:
```yaml
metadata:
  annotations:
    "helm.sh/hook": test-success
```

## Helm Plugins
Install plugin:
```bash
helm plugin install https://github.com/databus23/helm-diff
```
Common plugins:
- helm-diff: Show changes before applying
- helm-unittest: Unit test charts
- helmfile: Manage multiple charts
- helm-docs: Auto-generate chart documentation

## Security Best Practices
- Use signed charts (verify provenance)
- Avoid exposing Tiller (Helm v2)
- Use namespace restrictions
- Regularly update chart dependencies
- Always review templates from third parties
- Encrypt sensitive values when possible

## References
- [Helm Official Documentation](https://helm.sh/docs/)
- [Artifact Hub (Chart Repository)](https://artifacthub.io/)
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)

