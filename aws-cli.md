# AWS CLI Cheatsheet

## Table of Contents
- [Installation and Configuration](#installation-and-configuration)
- [General Usage](#general-usage)
- [EC2 Commands](#ec2-commands)
- [S3 Commands](#s3-commands)
- [IAM Commands](#iam-commands)
- [Lambda Commands](#lambda-commands)
- [RDS Commands](#rds-commands)
- [CloudFormation Commands](#cloudformation-commands)
- [DynamoDB Commands](#dynamodb-commands)
- [VPC Commands](#vpc-commands)
- [ECS Commands](#ecs-commands)
- [CloudWatch Commands](#cloudwatch-commands)
- [Advanced Usage Tips](#advanced-usage-tips)

## Installation and Configuration

### Install AWS CLI
```bash
# For Linux/macOS
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# For Windows (PowerShell)
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Verify installation
aws --version
```

### Configuration
```bash
# Basic configuration
aws configure

# Configure a named profile
aws configure --profile profilename

# List all configurations
aws configure list

# List all profiles
aws configure list-profiles
```

### Configuration Files
- Credentials file: `~/.aws/credentials` (Linux/macOS) or `%USERPROFILE%\.aws\credentials` (Windows)
- Config file: `~/.aws/config` (Linux/macOS) or `%USERPROFILE%\.aws\config` (Windows)

## General Usage

### Help Commands
```bash
# General help
aws help

# Help for a specific service
aws ec2 help

# Help for a specific command
aws ec2 describe-instances help
```

### Output Formatting
```bash
# JSON format (default)
aws ec2 describe-instances --output json

# Table format
aws ec2 describe-instances --output table

# Text format
aws ec2 describe-instances --output text

# YAML format
aws ec2 describe-instances --output yaml
```

### Using Profiles
```bash
# Use a named profile
aws ec2 describe-instances --profile profilename

# Set a default profile for the current session
export AWS_PROFILE=profilename  # Linux/macOS
$env:AWS_PROFILE="profilename"  # Windows PowerShell
```

### Filtering Output with JMESPath
```bash
# Extract specific fields
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]'

# Filter by value
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`running`]'
```

## EC2 Commands

### Instances
```bash
# List all instances
aws ec2 describe-instances

# List only running instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Launch a new instance
aws ec2 run-instances --image-id ami-12345678 --count 1 --instance-type t2.micro --key-name MyKeyPair

# Start an instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0

# Stop an instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Terminate an instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0

# Get console output
aws ec2 get-console-output --instance-id i-1234567890abcdef0
```

### AMIs
```bash
# List your AMIs
aws ec2 describe-images --owners self

# Create an AMI from an instance
aws ec2 create-image --instance-id i-1234567890abcdef0 --name "My AMI" --description "My AMI Description"

# Deregister an AMI
aws ec2 deregister-image --image-id ami-12345678
```

### Security Groups
```bash
# List security groups
aws ec2 describe-security-groups

# Create a security group
aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id vpc-1a2b3c4d

# Add inbound rule to a security group (allow SSH)
aws ec2 authorize-security-group-ingress --group-id sg-12345678 --protocol tcp --port 22 --cidr 0.0.0.0/0

# Delete a security group
aws ec2 delete-security-group --group-id sg-12345678
```

### Key Pairs
```bash
# List key pairs
aws ec2 describe-key-pairs

# Create a key pair and save private key
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem

# Delete a key pair
aws ec2 delete-key-pair --key-name MyKeyPair
```

### Elastic IPs
```bash
# Allocate a new Elastic IP
aws ec2 allocate-address

# Associate Elastic IP with an instance
aws ec2 associate-address --instance-id i-1234567890abcdef0 --allocation-id eipalloc-12345678

# Release an Elastic IP
aws ec2 release-address --allocation-id eipalloc-12345678
```

## S3 Commands

### Basic Bucket Operations
```bash
# List all buckets
aws s3 ls

# Create a bucket
aws s3 mb s3://mybucket

# Create a bucket in a specific region
aws s3 mb s3://mybucket --region us-west-2

# Delete an empty bucket
aws s3 rb s3://mybucket

# Delete a non-empty bucket
aws s3 rb s3://mybucket --force
```

### Object Operations
```bash
# List objects in a bucket
aws s3 ls s3://mybucket

# List objects with details (size, date, etc.)
aws s3 ls s3://mybucket --human-readable --summarize

# List objects recursively (including in subdirectories)
aws s3 ls s3://mybucket --recursive

# Upload a file
aws s3 cp myfile.txt s3://mybucket/

# Upload a file with specific storage class
aws s3 cp myfile.txt s3://mybucket/ --storage-class GLACIER

# Upload with public read access
aws s3 cp myfile.txt s3://mybucket/ --acl public-read

# Download a file
aws s3 cp s3://mybucket/myfile.txt ./

# Copy object between buckets
aws s3 cp s3://sourcebucket/myfile.txt s3://destbucket/

# Move a file (copy then delete source)
aws s3 mv myfile.txt s3://mybucket/

# Move objects between buckets
aws s3 mv s3://sourcebucket/myfile.txt s3://destbucket/
```

### Directory Operations
```bash
# Sync local directory to bucket (uploads new/changed files)
aws s3 sync ./local-dir s3://mybucket/remote-dir

# Sync with delete (removes files in destination not in source)
aws s3 sync ./local-dir s3://mybucket/remote-dir --delete

# Sync bucket to local directory
aws s3 sync s3://mybucket/remote-dir ./local-dir

# Sync between buckets
aws s3 sync s3://sourcebucket/dir s3://destbucket/dir

# Sync with exclusions
aws s3 sync ./local-dir s3://mybucket/remote-dir --exclude "*.tmp" --exclude "*.log"

# Sync with inclusions only
aws s3 sync ./local-dir s3://mybucket/remote-dir --include "*.jpg" --exclude "*"
```

### Object Removal
```bash
# Remove an object
aws s3 rm s3://mybucket/myfile.txt

# Remove all objects in a bucket
aws s3 rm s3://mybucket --recursive

# Remove objects matching a prefix
aws s3 rm s3://mybucket/logs/ --recursive

# Remove objects with exclude/include patterns
aws s3 rm s3://mybucket/ --recursive --exclude "*" --include "*.tmp"

# Dry run (preview what would be deleted)
aws s3 rm s3://mybucket/logs/ --recursive --dryrun
```

### Advanced S3 API Commands

#### Bucket Configuration
```bash
# Get bucket location
aws s3api get-bucket-location --bucket mybucket

# Enable versioning
aws s3api put-bucket-versioning --bucket mybucket --versioning-configuration Status=Enabled

# Enable bucket logging
aws s3api put-bucket-logging --bucket mybucket --bucket-logging-status file://logging.json

# Configure CORS
aws s3api put-bucket-cors --bucket mybucket --cors-configuration file://cors.json

# Configure lifecycle rules
aws s3api put-bucket-lifecycle-configuration --bucket mybucket --lifecycle-configuration file://lifecycle.json

# Set public access block configuration
aws s3api put-public-access-block --bucket mybucket --public-access-block-configuration file://public-block.json
```

#### Object Management with S3 API
```bash
# Get object metadata
aws s3api head-object --bucket mybucket --key myfile.txt

# Put object with metadata
aws s3api put-object --bucket mybucket --key myfile.txt --body myfile.txt --metadata '{"key1":"value1","key2":"value2"}'

# Upload a large file in parts (multipart upload)
# 1. Initiate
aws s3api create-multipart-upload --bucket mybucket --key largefile.zip

# 2. Upload parts (repeat for each part)
aws s3api upload-part --bucket mybucket --key largefile.zip --part-number 1 --body part1 --upload-id uploadID

# 3. Complete multipart upload
aws s3api complete-multipart-upload --bucket mybucket --key largefile.zip --upload-id uploadID --multipart-upload file://parts.json

# List object versions
aws s3api list-object-versions --bucket mybucket --prefix myfile.txt

# Restore object from Glacier
aws s3api restore-object --bucket mybucket --key myfile.txt --restore-request '{"Days":30,"GlacierJobParameters":{"Tier":"Standard"}}'
```

#### Bucket and Object Permissions
```bash
# Get bucket ACL
aws s3api get-bucket-acl --bucket mybucket

# Set bucket ACL
aws s3api put-bucket-acl --bucket mybucket --acl private

# Get object ACL
aws s3api get-object-acl --bucket mybucket --key myfile.txt

# Set object ACL
aws s3api put-object-acl --bucket mybucket --key myfile.txt --acl public-read

# Set custom ACL
aws s3api put-object-acl --bucket mybucket --key myfile.txt --access-control-policy file://acl.json
```

#### Website Configuration
```bash
# Configure static website hosting
aws s3api put-bucket-website --bucket mybucket --website-configuration file://website.json

# Get website configuration
aws s3api get-bucket-website --bucket mybucket

# Delete website configuration
aws s3api delete-bucket-website --bucket mybucket
```

#### Bucket Notification
```bash
# Configure event notifications
aws s3api put-bucket-notification-configuration --bucket mybucket --notification-configuration file://notification.json

# Get notification configuration
aws s3api get-bucket-notification-configuration --bucket mybucket
```

### Performance and Transfer Optimization
```bash
# Use accelerate configuration
aws s3api put-bucket-accelerate-configuration --bucket mybucket --accelerate-configuration Status=Enabled

# Transfer with acceleration
aws s3 cp largefile.zip s3://mybucket/ --endpoint-url https://s3-accelerate.amazonaws.com

# Set higher concurrency for sync
aws s3 sync ./local-dir s3://mybucket/remote-dir --size-only --metadata-directive COPY --acl bucket-owner-full-control --no-follow-symlinks --no-progress --delete --exact-timestamps --only-show-errors --quiet --request-payer requester --exclude ".git/*" --exclude ".vscode/*" --storage-class STANDARD_IA --sse-kms-key-id key_ARN
```

### Example JSON Configuration Files

#### CORS Configuration (cors.json)
```json
{
  "CORSRules": [
    {
      "AllowedOrigins": ["*"],
      "AllowedHeaders": ["*"],
      "AllowedMethods": ["GET", "PUT", "POST", "DELETE", "HEAD"],
      "MaxAgeSeconds": 3000
    }
  ]
}
```

#### Lifecycle Configuration (lifecycle.json)
```json
{
  "Rules": [
    {
      "ID": "Move to IA after 30 days, Glacier after 90, expire after 365",
      "Status": "Enabled",
      "Filter": {
        "Prefix": "logs/"
      },
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

#### Website Configuration (website.json)
```json
{
  "IndexDocument": {
    "Suffix": "index.html"
  },
  "ErrorDocument": {
    "Key": "error.html"
  },
  "RoutingRules": [
    {
      "Condition": {
        "KeyPrefixEquals": "docs/"
      },
      "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
      }
    }
  ]
}
```

### Bucket Policies
```bash
# Get bucket policy
aws s3api get-bucket-policy --bucket mybucket

# Set bucket policy
aws s3api put-bucket-policy --bucket mybucket --policy file://policy.json

# Delete bucket policy
aws s3api delete-bucket-policy --bucket mybucket
```

### Website Hosting
```bash
# Configure website hosting
aws s3 website s3://mybucket --index-document index.html --error-document error.html
```

## IAM Commands

### Users
```bash
# List users
aws iam list-users

# Create a user
aws iam create-user --user-name myuser

# Delete a user
aws iam delete-user --user-name myuser
```

### Groups
```bash
# List groups
aws iam list-groups

# Create a group
aws iam create-group --group-name mygroup

# Add user to group
aws iam add-user-to-group --user-name myuser --group-name mygroup

# Remove user from group
aws iam remove-user-from-group --user-name myuser --group-name mygroup

# Delete a group
aws iam delete-group --group-name mygroup
```

### Policies
```bash
# List policies
aws iam list-policies

# Create a policy
aws iam create-policy --policy-name mypolicy --policy-document file://policy.json

# Attach policy to user
aws iam attach-user-policy --user-name myuser --policy-arn arn:aws:iam::123456789012:policy/mypolicy

# Attach policy to group
aws iam attach-group-policy --group-name mygroup --policy-arn arn:aws:iam::123456789012:policy/mypolicy

# Detach policy from user
aws iam detach-user-policy --user-name myuser --policy-arn arn:aws:iam::123456789012:policy/mypolicy

# Delete a policy
aws iam delete-policy --policy-arn arn:aws:iam::123456789012:policy/mypolicy
```

### Roles
```bash
# List roles
aws iam list-roles

# Create a role
aws iam create-role --role-name myrole --assume-role-policy-document file://trust-policy.json

# Attach policy to role
aws iam attach-role-policy --role-name myrole --policy-arn arn:aws:iam::123456789012:policy/mypolicy

# Delete a role
aws iam delete-role --role-name myrole
```

### Access Keys
```bash
# List access keys for a user
aws iam list-access-keys --user-name myuser

# Create access key
aws iam create-access-key --user-name myuser

# Delete access key
aws iam delete-access-key --user-name myuser --access-key-id AKIAIOSFODNN7EXAMPLE
```

## Lambda Commands

### Functions
```bash
# List functions
aws lambda list-functions

# Create a function
aws lambda create-function --function-name my-function \
  --runtime python3.9 --role arn:aws:iam::123456789012:role/lambda-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip

# Invoke a function
aws lambda invoke --function-name my-function --payload '{"key": "value"}' output.txt

# Update function code
aws lambda update-function-code --function-name my-function --zip-file fileb://function.zip

# Delete a function
aws lambda delete-function --function-name my-function
```

### Layers
```bash
# List layers
aws lambda list-layers

# Publish a layer
aws lambda publish-layer-version --layer-name my-layer \
  --description "My layer" --license-info "MIT" \
  --zip-file fileb://layer.zip --compatible-runtimes python3.9

# Add a layer to a function
aws lambda update-function-configuration --function-name my-function \
  --layers arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1
```

## RDS Commands

### Instances
```bash
# List DB instances
aws rds describe-db-instances

# Create a DB instance
aws rds create-db-instance --db-instance-identifier mydb \
  --allocated-storage 20 --db-instance-class db.t2.micro \
  --engine mysql --master-username admin \
  --master-user-password secretpassword

# Take a snapshot
aws rds create-db-snapshot --db-instance-identifier mydb --db-snapshot-identifier mydb-snapshot

# Reboot a DB instance
aws rds reboot-db-instance --db-instance-identifier mydb

# Delete a DB instance
aws rds delete-db-instance --db-instance-identifier mydb --skip-final-snapshot
```

### Snapshots
```bash
# List snapshots
aws rds describe-db-snapshots

# Restore from snapshot
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier mydb-restored \
  --db-snapshot-identifier mydb-snapshot

# Delete a snapshot
aws rds delete-db-snapshot --db-snapshot-identifier mydb-snapshot
```

## CloudFormation Commands

### Stacks
```bash
# List stacks
aws cloudformation list-stacks

# Create a stack
aws cloudformation create-stack --stack-name mystack \
  --template-body file://template.yaml \
  --parameters ParameterKey=KeyName,ParameterValue=mykey

# Update a stack
aws cloudformation update-stack --stack-name mystack \
  --template-body file://updated-template.yaml

# Delete a stack
aws cloudformation delete-stack --stack-name mystack
```

### Templates
```bash
# Validate a template
aws cloudformation validate-template --template-body file://template.yaml

# Get template summary
aws cloudformation get-template-summary --template-body file://template.yaml
```

## DynamoDB Commands

### Tables
```bash
# List tables
aws dynamodb list-tables

# Create a table
aws dynamodb create-table \
  --table-name Music \
  --attribute-definitions AttributeName=Artist,AttributeType=S AttributeName=SongTitle,AttributeType=S \
  --key-schema AttributeName=Artist,KeyType=HASH AttributeName=SongTitle,KeyType=RANGE \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

# Describe a table
aws dynamodb describe-table --table-name Music

# Delete a table
aws dynamodb delete-table --table-name Music
```

### Items
```bash
# Put an item
aws dynamodb put-item \
  --table-name Music \
  --item '{"Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}}'

# Get an item
aws dynamodb get-item \
  --table-name Music \
  --key '{"Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}}'

# Update an item
aws dynamodb update-item \
  --table-name Music \
  --key '{"Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}}' \
  --update-expression "SET AlbumTitle = :val" \
  --expression-attribute-values '{":val": {"S": "Greatest Hits"}}'

# Delete an item
aws dynamodb delete-item \
  --table-name Music \
  --key '{"Artist": {"S": "No One You Know"}, "SongTitle": {"S": "Call Me Today"}}'
```

### Queries and Scans
```bash
# Query a table
aws dynamodb query \
  --table-name Music \
  --key-condition-expression "Artist = :artist" \
  --expression-attribute-values '{":artist": {"S": "No One You Know"}}'

# Scan a table
aws dynamodb scan --table-name Music
```

## VPC Commands

### VPCs
```bash
# List VPCs
aws ec2 describe-vpcs

# Create a VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Delete a VPC
aws ec2 delete-vpc --vpc-id vpc-1234567890abcdef0
```

### Subnets
```bash
# List subnets
aws ec2 describe-subnets

# Create a subnet
aws ec2 create-subnet --vpc-id vpc-1234567890abcdef0 --cidr-block 10.0.1.0/24

# Delete a subnet
aws ec2 delete-subnet --subnet-id subnet-1234567890abcdef0
```

### Internet Gateways
```bash
# Create an internet gateway
aws ec2 create-internet-gateway

# Attach internet gateway to VPC
aws ec2 attach-internet-gateway --vpc-id vpc-1234567890abcdef0 --internet-gateway-id igw-1234567890abcdef0

# Detach internet gateway from VPC
aws ec2 detach-internet-gateway --vpc-id vpc-1234567890abcdef0 --internet-gateway-id igw-1234567890abcdef0

# Delete an internet gateway
aws ec2 delete-internet-gateway --internet-gateway-id igw-1234567890abcdef0
```

### Route Tables
```bash
# Create a route table
aws ec2 create-route-table --vpc-id vpc-1234567890abcdef0

# Create a route
aws ec2 create-route --route-table-id rtb-1234567890abcdef0 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-1234567890abcdef0

# Associate subnet with route table
aws ec2 associate-route-table --subnet-id subnet-1234567890abcdef0 --route-table-id rtb-1234567890abcdef0

# Delete a route table
aws ec2 delete-route-table --route-table-id rtb-1234567890abcdef0
```

## ECS Commands

### Clusters
```bash
# List clusters
aws ecs list-clusters

# Create a cluster
aws ecs create-cluster --cluster-name mycluster

# Delete a cluster
aws ecs delete-cluster --cluster mycluster
```

### Services
```bash
# List services
aws ecs list-services --cluster mycluster

# Create a service
aws ecs create-service --cluster mycluster --service-name myservice \
  --task-definition mytask:1 --desired-count 1

# Update a service
aws ecs update-service --cluster mycluster --service myservice --desired-count 2

# Delete a service
aws ecs delete-service --cluster mycluster --service myservice --force
```

### Tasks
```bash
# List task definitions
aws ecs list-task-definitions

# Register a task definition
aws ecs register-task-definition --cli-input-json file://task-definition.json

# Run a task
aws ecs run-task --cluster mycluster --task-definition mytask:1

# Stop a task
aws ecs stop-task --cluster mycluster --task 1234567890abcdef0
```

## CloudWatch Commands

### Metrics
```bash
# List metrics
aws cloudwatch list-metrics

# Get metric statistics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --start-time 2023-01-01T00:00:00Z \
  --end-time 2023-01-02T00:00:00Z \
  --period 3600 \
  --statistics Average Maximum
```

### Alarms
```bash
# List alarms
aws cloudwatch describe-alarms

# Create an alarm
aws cloudwatch put-metric-alarm \
  --alarm-name cpu-mon \
  --alarm-description "Alarm when CPU exceeds 70%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:MyTopic

# Delete an alarm
aws cloudwatch delete-alarms --alarm-names cpu-mon
```

### Logs
```bash
# List log groups
aws logs describe-log-groups

# Create a log group
aws logs create-log-group --log-group-name mygroup

# Delete a log group
aws logs delete-log-group --log-group-name mygroup

# Get log events
aws logs get-log-events --log-group-name mygroup --log-stream-name mystream
```

## Advanced Usage Tips

### Using AWS CLI with MFA
```bash
# Get session token with MFA
aws sts get-session-token \
  --serial-number arn:aws:iam::123456789012:mfa/user \
  --token-code 123456
```

### Using AWS CLI with Assume Role
```bash
# Assume a role
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/myrole \
  --role-session-name mysession
```

### Pagination
```bash
# Use pagination parameters
aws s3api list-objects --bucket mybucket --max-items 100 --starting-token token

# Automatically handle pagination
aws s3api list-objects --bucket mybucket --page-size 100 --no-paginate
```

### Using Parameter File
```bash
# Use a JSON file for complex parameters
aws ec2 run-instances --cli-input-json file://ec2-params.json
```

### Debugging
```bash
# Debug mode
aws --debug ec2 describe-instances

# Generate CLI skeleton
aws ec2 run-instances --generate-cli-skeleton > params.json
```

### Automated Resources Cleanup
```bash
# Find and terminate all running EC2 instances
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`running`].InstanceId' --output text | xargs -n1 aws ec2 terminate-instances --instance-ids
```

### Using Profiles with Environment Variables
```bash
# Set AWS profile via environment variable
export AWS_PROFILE=myprofile  # Linux/macOS
$env:AWS_PROFILE="myprofile"  # Windows PowerShell

# Set AWS region via environment variable
export AWS_REGION=us-west-2  # Linux/macOS
$env:AWS_REGION="us-west-2"  # Windows PowerShell
```
