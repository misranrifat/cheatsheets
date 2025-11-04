# GCP CLI (gcloud) Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Authentication](#authentication)
- [Configuration](#configuration)
- [Projects](#projects)
- [Compute Engine](#compute-engine)
- [Cloud Storage](#cloud-storage)
- [Cloud SQL](#cloud-sql)
- [Cloud Functions](#cloud-functions)
- [Cloud Run](#cloud-run)
- [Google Kubernetes Engine (GKE)](#google-kubernetes-engine-gke)
- [App Engine](#app-engine)
- [Cloud Pub/Sub](#cloud-pubsub)
- [Cloud Build](#cloud-build)
- [IAM & Service Accounts](#iam--service-accounts)
- [Networking](#networking)
- [Logging & Monitoring](#logging--monitoring)
- [BigQuery](#bigquery)
- [Container Registry](#container-registry)
- [Cloud DNS](#cloud-dns)
- [Common Options](#common-options)
- [Tips & Best Practices](#tips--best-practices)
- [References](#references)

## Introduction

The gcloud CLI is the primary command-line tool for interacting with Google Cloud Platform (GCP) services. It provides commands for managing resources, configurations, and deployments.

**Key Features:**
- Unified interface for GCP services
- Interactive configuration
- Scripting support
- Local emulators for development
- SDK components management

## Installation

### Linux
```bash
# Download and install
curl https://sdk.cloud.google.com | bash

# Restart shell
exec -l $SHELL

# Initialize gcloud
gcloud init

# Verify installation
gcloud version
```

### macOS
```bash
# Using Homebrew
brew install --cask google-cloud-sdk

# Or download installer
curl https://sdk.cloud.google.com | bash

# Initialize
gcloud init
```

### Windows
```powershell
# Download installer from:
# https://cloud.google.com/sdk/docs/install

# Or using Chocolatey
choco install gcloudsdk

# Initialize
gcloud init
```

### Docker
```bash
# Run gcloud in Docker
docker run -ti --name gcloud-config google/cloud-sdk gcloud init

# Use gcloud from container
docker run --rm --volumes-from gcloud-config google/cloud-sdk gcloud version
```

### Update gcloud
```bash
# Update gcloud components
gcloud components update

# Update to specific version
gcloud components update --version=VERSION
```

## Authentication

### Login
```bash
# Login with browser
gcloud auth login

# Login with specific account
gcloud auth login user@example.com

# Application default credentials
gcloud auth application-default login

# Revoke credentials
gcloud auth revoke
gcloud auth revoke user@example.com
```

### Service Account Authentication
```bash
# Activate service account
gcloud auth activate-service-account --key-file=key.json

# With specific account
gcloud auth activate-service-account SERVICE_ACCOUNT@PROJECT.iam.gserviceaccount.com \
  --key-file=key.json
```

### List Accounts
```bash
# List authenticated accounts
gcloud auth list

# Show current account
gcloud config get-value account
```

### Access Tokens
```bash
# Print access token
gcloud auth print-access-token

# Print identity token
gcloud auth print-identity-token
```

## Configuration

### Basic Configuration
```bash
# Initialize configuration
gcloud init

# Set default project
gcloud config set project PROJECT_ID

# Set default region
gcloud config set compute/region us-central1

# Set default zone
gcloud config set compute/zone us-central1-a
```

### Configuration Properties
```bash
# List all properties
gcloud config list

# Get specific property
gcloud config get-value project
gcloud config get-value compute/region

# Unset property
gcloud config unset project
gcloud config unset compute/region
```

### Named Configurations
```bash
# List configurations
gcloud config configurations list

# Create configuration
gcloud config configurations create dev
gcloud config configurations create prod

# Activate configuration
gcloud config configurations activate dev

# Delete configuration
gcloud config configurations delete dev
```

### Configuration Example
```bash
# Development configuration
gcloud config configurations create dev
gcloud config set project dev-project
gcloud config set compute/region us-central1
gcloud config set account dev@example.com

# Production configuration
gcloud config configurations create prod
gcloud config set project prod-project
gcloud config set compute/region us-east1
gcloud config set account prod@example.com

# Switch between configurations
gcloud config configurations activate dev
gcloud config configurations activate prod
```

## Projects

### List Projects
```bash
# List all projects
gcloud projects list

# List with filter
gcloud projects list --filter="name:prod*"

# List with format
gcloud projects list --format="table(projectId,name,projectNumber)"
```

### Create Project
```bash
# Create project
gcloud projects create PROJECT_ID

# Create with name
gcloud projects create PROJECT_ID --name="My Project"

# Create in organization
gcloud projects create PROJECT_ID --organization=ORG_ID
```

### Project Information
```bash
# Describe project
gcloud projects describe PROJECT_ID

# Get project number
gcloud projects describe PROJECT_ID --format="value(projectNumber)"
```

### Delete Project
```bash
# Delete project
gcloud projects delete PROJECT_ID

# Undelete project (within 30 days)
gcloud projects undelete PROJECT_ID
```

## Compute Engine

### Instances

#### List Instances
```bash
# List all instances
gcloud compute instances list

# List in specific zone
gcloud compute instances list --zones=us-central1-a

# List with filter
gcloud compute instances list --filter="name:web-*"
```

#### Create Instance
```bash
# Basic instance
gcloud compute instances create instance-1 \
  --zone=us-central1-a \
  --machine-type=e2-medium

# With specific image
gcloud compute instances create instance-1 \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud

# With startup script
gcloud compute instances create instance-1 \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --metadata-from-file startup-script=startup.sh

# With custom disk
gcloud compute instances create instance-1 \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --boot-disk-size=50GB \
  --boot-disk-type=pd-ssd

# With tags and labels
gcloud compute instances create instance-1 \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --tags=http-server,https-server \
  --labels=env=dev,team=backend
```

#### Manage Instances
```bash
# Start instance
gcloud compute instances start instance-1 --zone=us-central1-a

# Stop instance
gcloud compute instances stop instance-1 --zone=us-central1-a

# Restart instance
gcloud compute instances reset instance-1 --zone=us-central1-a

# Delete instance
gcloud compute instances delete instance-1 --zone=us-central1-a

# Delete multiple instances
gcloud compute instances delete instance-1 instance-2 --zone=us-central1-a
```

#### Instance Details
```bash
# Describe instance
gcloud compute instances describe instance-1 --zone=us-central1-a

# Get external IP
gcloud compute instances describe instance-1 \
  --zone=us-central1-a \
  --format="get(networkInterfaces[0].accessConfigs[0].natIP)"

# Get internal IP
gcloud compute instances describe instance-1 \
  --zone=us-central1-a \
  --format="get(networkInterfaces[0].networkIP)"
```

#### SSH and Connect
```bash
# SSH into instance
gcloud compute ssh instance-1 --zone=us-central1-a

# SSH with specific user
gcloud compute ssh user@instance-1 --zone=us-central1-a

# Execute command via SSH
gcloud compute ssh instance-1 --zone=us-central1-a --command="ls -la"

# SCP file to instance
gcloud compute scp local-file.txt instance-1:~/remote-file.txt --zone=us-central1-a

# SCP file from instance
gcloud compute scp instance-1:~/remote-file.txt ./local-file.txt --zone=us-central1-a
```

### Machine Types
```bash
# List machine types
gcloud compute machine-types list

# List in specific zone
gcloud compute machine-types list --zones=us-central1-a

# Describe machine type
gcloud compute machine-types describe e2-medium --zone=us-central1-a
```

### Images
```bash
# List images
gcloud compute images list

# List from specific project
gcloud compute images list --project=ubuntu-os-cloud

# Describe image
gcloud compute images describe ubuntu-2204-lts --project=ubuntu-os-cloud
```

### Disks
```bash
# List disks
gcloud compute disks list

# Create disk
gcloud compute disks create disk-1 \
  --size=100GB \
  --zone=us-central1-a

# Delete disk
gcloud compute disks delete disk-1 --zone=us-central1-a

# Snapshot disk
gcloud compute disks snapshot disk-1 \
  --snapshot-names=snapshot-1 \
  --zone=us-central1-a
```

## Cloud Storage

### Buckets

#### List Buckets
```bash
# List all buckets
gsutil ls

# List with details
gsutil ls -L gs://bucket-name

# List buckets in project
gsutil ls -p PROJECT_ID
```

#### Create Bucket
```bash
# Create bucket
gsutil mb gs://bucket-name

# Create in specific region
gsutil mb -l us-central1 gs://bucket-name

# Create with storage class
gsutil mb -c STANDARD gs://bucket-name
gsutil mb -c NEARLINE gs://bucket-name
```

#### Delete Bucket
```bash
# Delete empty bucket
gsutil rb gs://bucket-name

# Delete bucket and contents
gsutil rm -r gs://bucket-name
```

### Objects

#### Upload Files
```bash
# Upload file
gsutil cp file.txt gs://bucket-name/

# Upload directory
gsutil cp -r directory/ gs://bucket-name/

# Upload with parallel composite uploads
gsutil -m cp -r directory/ gs://bucket-name/

# Upload with metadata
gsutil -h "Content-Type:application/json" cp file.json gs://bucket-name/
```

#### Download Files
```bash
# Download file
gsutil cp gs://bucket-name/file.txt ./

# Download directory
gsutil cp -r gs://bucket-name/directory/ ./

# Download with parallel downloads
gsutil -m cp -r gs://bucket-name/directory/ ./
```

#### List Objects
```bash
# List objects in bucket
gsutil ls gs://bucket-name/

# List recursively
gsutil ls -r gs://bucket-name/

# List with details
gsutil ls -l gs://bucket-name/
```

#### Delete Objects
```bash
# Delete file
gsutil rm gs://bucket-name/file.txt

# Delete directory
gsutil rm -r gs://bucket-name/directory/

# Delete with parallel operations
gsutil -m rm -r gs://bucket-name/directory/
```

#### Copy/Move Objects
```bash
# Copy object
gsutil cp gs://source-bucket/file.txt gs://dest-bucket/

# Move object
gsutil mv gs://source-bucket/file.txt gs://dest-bucket/

# Copy between buckets
gsutil -m cp -r gs://source-bucket/* gs://dest-bucket/
```

### Permissions
```bash
# Make object public
gsutil acl ch -u AllUsers:R gs://bucket-name/file.txt

# Grant user access
gsutil acl ch -u user@example.com:R gs://bucket-name/file.txt

# Set bucket IAM policy
gsutil iam ch user:user@example.com:objectViewer gs://bucket-name
```

### Bucket Versioning
```bash
# Enable versioning
gsutil versioning set on gs://bucket-name

# Get versioning status
gsutil versioning get gs://bucket-name

# List object versions
gsutil ls -a gs://bucket-name/file.txt
```

## Cloud SQL

### Instances

#### List Instances
```bash
# List SQL instances
gcloud sql instances list

# List with filter
gcloud sql instances list --filter="name:prod-*"
```

#### Create Instance
```bash
# Create MySQL instance
gcloud sql instances create mysql-instance \
  --database-version=MYSQL_8_0 \
  --tier=db-n1-standard-1 \
  --region=us-central1

# Create PostgreSQL instance
gcloud sql instances create postgres-instance \
  --database-version=POSTGRES_14 \
  --tier=db-n1-standard-1 \
  --region=us-central1
```

#### Manage Instances
```bash
# Describe instance
gcloud sql instances describe instance-name

# Start instance
gcloud sql instances start instance-name

# Stop instance
gcloud sql instances stop instance-name

# Delete instance
gcloud sql instances delete instance-name
```

### Databases
```bash
# List databases
gcloud sql databases list --instance=instance-name

# Create database
gcloud sql databases create mydb --instance=instance-name

# Delete database
gcloud sql databases delete mydb --instance=instance-name
```

### Users
```bash
# List users
gcloud sql users list --instance=instance-name

# Create user
gcloud sql users create myuser \
  --instance=instance-name \
  --password=mypassword

# Set password
gcloud sql users set-password myuser \
  --instance=instance-name \
  --password=newpassword

# Delete user
gcloud sql users delete myuser --instance=instance-name
```

### Connect
```bash
# Connect to instance
gcloud sql connect instance-name --user=root

# Connect to specific database
gcloud sql connect instance-name --user=root --database=mydb
```

## Cloud Functions

### List Functions
```bash
# List all functions
gcloud functions list

# List in specific region
gcloud functions list --region=us-central1
```

### Deploy Function
```bash
# Deploy HTTP function
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --allow-unauthenticated \
  --entry-point=main

# Deploy with environment variables
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-http \
  --set-env-vars=KEY1=value1,KEY2=value2

# Deploy Pub/Sub triggered function
gcloud functions deploy my-function \
  --runtime=python39 \
  --trigger-topic=my-topic

# Deploy from source
gcloud functions deploy my-function \
  --runtime=python39 \
  --source=. \
  --trigger-http
```

### Manage Functions
```bash
# Describe function
gcloud functions describe my-function

# Delete function
gcloud functions delete my-function

# Get logs
gcloud functions logs read my-function

# Call function
gcloud functions call my-function --data='{"name":"World"}'
```

## Cloud Run

### Services

#### Deploy Service
```bash
# Deploy from source
gcloud run deploy my-service \
  --source . \
  --region=us-central1 \
  --allow-unauthenticated

# Deploy from container image
gcloud run deploy my-service \
  --image=gcr.io/PROJECT_ID/image:tag \
  --region=us-central1 \
  --platform=managed

# Deploy with environment variables
gcloud run deploy my-service \
  --image=gcr.io/PROJECT_ID/image:tag \
  --set-env-vars=KEY1=value1,KEY2=value2 \
  --region=us-central1

# Deploy with CPU and memory limits
gcloud run deploy my-service \
  --image=gcr.io/PROJECT_ID/image:tag \
  --cpu=2 \
  --memory=2Gi \
  --region=us-central1
```

#### List Services
```bash
# List all services
gcloud run services list

# List in specific region
gcloud run services list --region=us-central1
```

#### Manage Services
```bash
# Describe service
gcloud run services describe my-service --region=us-central1

# Delete service
gcloud run services delete my-service --region=us-central1

# Update service
gcloud run services update my-service \
  --image=gcr.io/PROJECT_ID/image:new-tag \
  --region=us-central1
```

#### Service URLs
```bash
# Get service URL
gcloud run services describe my-service \
  --region=us-central1 \
  --format="value(status.url)"
```

## Google Kubernetes Engine (GKE)

### Clusters

#### List Clusters
```bash
# List all clusters
gcloud container clusters list

# List in specific region
gcloud container clusters list --region=us-central1
```

#### Create Cluster
```bash
# Create basic cluster
gcloud container clusters create my-cluster \
  --zone=us-central1-a

# Create with specific machine type
gcloud container clusters create my-cluster \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --num-nodes=3

# Create regional cluster
gcloud container clusters create my-cluster \
  --region=us-central1 \
  --num-nodes=1

# Create autopilot cluster
gcloud container clusters create-auto my-cluster \
  --region=us-central1
```

#### Manage Clusters
```bash
# Get cluster credentials
gcloud container clusters get-credentials my-cluster --zone=us-central1-a

# Describe cluster
gcloud container clusters describe my-cluster --zone=us-central1-a

# Upgrade cluster
gcloud container clusters upgrade my-cluster --zone=us-central1-a

# Delete cluster
gcloud container clusters delete my-cluster --zone=us-central1-a
```

#### Node Pools
```bash
# List node pools
gcloud container node-pools list --cluster=my-cluster --zone=us-central1-a

# Create node pool
gcloud container node-pools create pool-1 \
  --cluster=my-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-medium

# Delete node pool
gcloud container node-pools delete pool-1 \
  --cluster=my-cluster \
  --zone=us-central1-a
```

## App Engine

### Deploy Application
```bash
# Deploy app
gcloud app deploy

# Deploy specific version
gcloud app deploy --version=v1

# Deploy without promoting
gcloud app deploy --no-promote

# Deploy with specific service
gcloud app deploy app.yaml
```

### Manage Services
```bash
# List services
gcloud app services list

# Describe service
gcloud app services describe default

# Delete service
gcloud app services delete SERVICE_NAME
```

### Versions
```bash
# List versions
gcloud app versions list

# Describe version
gcloud app versions describe VERSION --service=SERVICE

# Delete version
gcloud app versions delete VERSION --service=SERVICE
```

### Browse Application
```bash
# Open app in browser
gcloud app browse

# Get app URL
gcloud app describe --format="value(defaultHostname)"
```

## Cloud Pub/Sub

### Topics

#### List Topics
```bash
# List all topics
gcloud pubsub topics list
```

#### Create Topic
```bash
# Create topic
gcloud pubsub topics create my-topic

# Create with message retention
gcloud pubsub topics create my-topic \
  --message-retention-duration=7d
```

#### Delete Topic
```bash
# Delete topic
gcloud pubsub topics delete my-topic
```

#### Publish Messages
```bash
# Publish message
gcloud pubsub topics publish my-topic --message="Hello World"

# Publish with attributes
gcloud pubsub topics publish my-topic \
  --message="Hello" \
  --attribute=key1=value1,key2=value2
```

### Subscriptions

#### List Subscriptions
```bash
# List all subscriptions
gcloud pubsub subscriptions list

# List for specific topic
gcloud pubsub subscriptions list --topic=my-topic
```

#### Create Subscription
```bash
# Create pull subscription
gcloud pubsub subscriptions create my-sub --topic=my-topic

# Create push subscription
gcloud pubsub subscriptions create my-sub \
  --topic=my-topic \
  --push-endpoint=https://example.com/push

# Create with retention
gcloud pubsub subscriptions create my-sub \
  --topic=my-topic \
  --message-retention-duration=7d
```

#### Pull Messages
```bash
# Pull messages
gcloud pubsub subscriptions pull my-sub

# Pull and auto-acknowledge
gcloud pubsub subscriptions pull my-sub --auto-ack

# Pull multiple messages
gcloud pubsub subscriptions pull my-sub --limit=10
```

## Cloud Build

### Submit Build
```bash
# Build from source
gcloud builds submit --tag=gcr.io/PROJECT_ID/image:tag

# Build with config file
gcloud builds submit --config=cloudbuild.yaml

# Build with substitutions
gcloud builds submit \
  --config=cloudbuild.yaml \
  --substitutions=_VERSION=1.0.0
```

### List Builds
```bash
# List recent builds
gcloud builds list

# List with filter
gcloud builds list --filter="status=SUCCESS"

# Get build details
gcloud builds describe BUILD_ID
```

### Build Logs
```bash
# Stream build logs
gcloud builds log BUILD_ID --stream
```

## IAM & Service Accounts

### IAM Policies
```bash
# Get IAM policy
gcloud projects get-iam-policy PROJECT_ID

# Add IAM policy binding
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:user@example.com \
  --role=roles/editor

# Remove IAM policy binding
gcloud projects remove-iam-policy-binding PROJECT_ID \
  --member=user:user@example.com \
  --role=roles/editor
```

### Service Accounts

#### List Service Accounts
```bash
# List service accounts
gcloud iam service-accounts list
```

#### Create Service Account
```bash
# Create service account
gcloud iam service-accounts create my-sa \
  --display-name="My Service Account"
```

#### Manage Service Accounts
```bash
# Describe service account
gcloud iam service-accounts describe my-sa@PROJECT_ID.iam.gserviceaccount.com

# Delete service account
gcloud iam service-accounts delete my-sa@PROJECT_ID.iam.gserviceaccount.com
```

#### Service Account Keys
```bash
# Create key
gcloud iam service-accounts keys create key.json \
  --iam-account=my-sa@PROJECT_ID.iam.gserviceaccount.com

# List keys
gcloud iam service-accounts keys list \
  --iam-account=my-sa@PROJECT_ID.iam.gserviceaccount.com

# Delete key
gcloud iam service-accounts keys delete KEY_ID \
  --iam-account=my-sa@PROJECT_ID.iam.gserviceaccount.com
```

## Networking

### VPC Networks
```bash
# List networks
gcloud compute networks list

# Create network
gcloud compute networks create my-network --subnet-mode=auto

# Delete network
gcloud compute networks delete my-network
```

### Subnets
```bash
# List subnets
gcloud compute networks subnets list

# Create subnet
gcloud compute networks subnets create my-subnet \
  --network=my-network \
  --range=10.0.0.0/24 \
  --region=us-central1
```

### Firewall Rules
```bash
# List firewall rules
gcloud compute firewall-rules list

# Create firewall rule
gcloud compute firewall-rules create allow-http \
  --network=default \
  --allow=tcp:80 \
  --source-ranges=0.0.0.0/0

# Delete firewall rule
gcloud compute firewall-rules delete allow-http
```

### Load Balancers
```bash
# Create HTTP load balancer
gcloud compute backend-services create my-backend \
  --global \
  --protocol=HTTP

# Create URL map
gcloud compute url-maps create my-map \
  --default-service=my-backend
```

## Logging & Monitoring

### Logs
```bash
# Read logs
gcloud logging read "resource.type=gce_instance"

# Read logs with filter
gcloud logging read "resource.type=gce_instance AND severity>=ERROR"

# Read logs with limit
gcloud logging read "resource.type=gce_instance" --limit=10

# Real-time log streaming
gcloud logging tail "resource.type=gce_instance"
```

### Metrics
```bash
# List metrics
gcloud monitoring metrics-descriptors list

# Create alert policy
gcloud alpha monitoring policies create \
  --notification-channels=CHANNEL_ID \
  --display-name="High CPU Alert"
```

## BigQuery

### Datasets
```bash
# List datasets
bq ls

# Create dataset
bq mk mydataset

# Delete dataset
bq rm -r mydataset
```

### Tables
```bash
# List tables
bq ls mydataset

# Show table schema
bq show mydataset.mytable

# Query table
bq query "SELECT * FROM mydataset.mytable LIMIT 10"

# Load data
bq load mydataset.mytable data.csv schema.json
```

## Container Registry

### Images
```bash
# List images
gcloud container images list

# List tags
gcloud container images list-tags gcr.io/PROJECT_ID/image

# Delete image
gcloud container images delete gcr.io/PROJECT_ID/image:tag

# Pull image
docker pull gcr.io/PROJECT_ID/image:tag

# Push image
docker tag local-image gcr.io/PROJECT_ID/image:tag
docker push gcr.io/PROJECT_ID/image:tag
```

### Authentication
```bash
# Configure Docker authentication
gcloud auth configure-docker

# Login to specific registry
gcloud auth configure-docker gcr.io
```

## Cloud DNS

### Managed Zones
```bash
# List managed zones
gcloud dns managed-zones list

# Create managed zone
gcloud dns managed-zones create my-zone \
  --dns-name=example.com. \
  --description="My DNS zone"

# Delete managed zone
gcloud dns managed-zones delete my-zone
```

### DNS Records
```bash
# List records
gcloud dns record-sets list --zone=my-zone

# Add A record
gcloud dns record-sets create www.example.com. \
  --zone=my-zone \
  --type=A \
  --ttl=300 \
  --rrdatas=1.2.3.4

# Delete record
gcloud dns record-sets delete www.example.com. \
  --zone=my-zone \
  --type=A
```

## Common Options

### Output Formats
```bash
# JSON output
gcloud compute instances list --format=json

# YAML output
gcloud compute instances list --format=yaml

# Table output
gcloud compute instances list --format=table

# CSV output
gcloud compute instances list --format=csv

# Custom format
gcloud compute instances list --format="table(name,zone,status)"

# Get specific values
gcloud compute instances list --format="value(name)"
```

### Filtering
```bash
# Filter by name
gcloud compute instances list --filter="name:web-*"

# Filter by status
gcloud compute instances list --filter="status=RUNNING"

# Multiple filters
gcloud compute instances list --filter="status=RUNNING AND zone:us-central1"
```

### Sorting
```bash
# Sort by name
gcloud compute instances list --sort-by=name

# Reverse sort
gcloud compute instances list --sort-by=~name
```

### Limit Results
```bash
# Limit to 10 results
gcloud compute instances list --limit=10
```

## Tips & Best Practices

### Use Configuration Profiles
```bash
# Create separate configs for different environments
gcloud config configurations create dev
gcloud config configurations create staging
gcloud config configurations create prod

# Switch between them easily
gcloud config configurations activate dev
```

### Set Default Values
```bash
# Set defaults to avoid repetition
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
gcloud config set project my-project
```

### Use Service Accounts for CI/CD
```bash
# Create service account for automation
gcloud iam service-accounts create ci-cd-sa

# Grant necessary permissions
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=serviceAccount:ci-cd-sa@PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/editor

# Create and download key
gcloud iam service-accounts keys create key.json \
  --iam-account=ci-cd-sa@PROJECT_ID.iam.gserviceaccount.com
```

### Enable APIs
```bash
# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

# List enabled services
gcloud services list --enabled
```

### Use Labels and Tags
```bash
# Add labels for organization
gcloud compute instances create instance-1 \
  --labels=env=prod,team=backend,cost-center=engineering

# Filter by labels
gcloud compute instances list --filter="labels.env=prod"
```

### Script-Friendly Output
```bash
# Get just the values you need
INSTANCE_IP=$(gcloud compute instances describe instance-1 \
  --zone=us-central1-a \
  --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

echo "Instance IP: $INSTANCE_IP"
```

### Use --quiet Flag
```bash
# Skip confirmation prompts in scripts
gcloud compute instances delete instance-1 --zone=us-central1-a --quiet
```

## References

- [gcloud CLI Documentation](https://cloud.google.com/sdk/gcloud)
- [gcloud CLI Reference](https://cloud.google.com/sdk/gcloud/reference)
- [Google Cloud SDK Installation](https://cloud.google.com/sdk/docs/install)
- [gcloud Cheat Sheet](https://cloud.google.com/sdk/docs/cheatsheet)
- [Google Cloud Console](https://console.cloud.google.com/)
- [gsutil Tool](https://cloud.google.com/storage/docs/gsutil)
- [bq Command-Line Tool](https://cloud.google.com/bigquery/docs/bq-command-line-tool)
