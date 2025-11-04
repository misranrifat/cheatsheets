# Terraform Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Workflow](#basic-workflow)
- [Configuration Files](#configuration-files)
- [Commands](#commands)
- [Variables](#variables)
- [Outputs](#outputs)
- [Locals](#locals)
- [Modules](#modules)
- [State Management](#state-management)
- [Provisioners](#provisioners)
- [Backends](#backends)
- [Workspaces](#workspaces)
- [Data Sources](#data-sources)
- [Lifecycle Rules](#lifecycle-rules)
- [Resource Meta-Arguments](#resource-meta-arguments)
- [Functions](#functions)
- [Terraform Cloud](#terraform-cloud)
- [References](#references)

## Introduction
Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently.

## Installation
```bash
# MacOS
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Windows
choco install terraform
```

## Basic Workflow
```bash
terraform init     # Initialize a working directory
terraform plan     # Show execution plan
terraform apply    # Apply changes to reach the desired state
terraform destroy  # Destroy created infrastructure
```

## Configuration Files
- Files end with `.tf`
- Example structure:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

## Commands
```bash
terraform fmt                   # Format configuration files
terraform validate              # Validate configuration files
terraform output                # Show output values
terraform taint <resource>      # Mark resource for recreation
terraform import <address> <id> # Import existing infrastructure
terraform graph                 # Visualize dependency graph
terraform refresh               # Update local state
```

## Variables
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_instance" "example" {
  instance_type = var.instance_type
}

# Create terraform.tfvars
instance_type = "t3.micro"
```

## Outputs
```hcl
output "instance_id" {
  value = aws_instance.example.id
}
```

## Locals
```hcl
locals {
  service_name = "my-service"
  owner        = "team-abc"
}

resource "aws_s3_bucket" "example" {
  bucket = "${local.service_name}-${local.owner}"
}
```

## Modules
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

## State Management
```bash
terraform state list                    # List resources in state file
terraform state show <resource>         # Show resource details
terraform state pull                    # Pull current state
terraform state rm <resource>           # Remove from state
terraform state mv <source> <destination> # Move resources
```

## Provisioners
```hcl
resource "aws_instance" "example" {
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }
}
```

## Backends
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Workspaces
```bash
terraform workspace new <name>       # Create a new workspace
terraform workspace list             # List workspaces
terraform workspace select <name>    # Select a workspace
terraform workspace delete <name>    # Delete a workspace
```

## Data Sources
```hcl
data "aws_ami" "latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}
```

## Lifecycle Rules
```hcl
resource "aws_s3_bucket" "example" {
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags]
  }
}
```

## Resource Meta-Arguments
- `count` - Create multiple instances
- `for_each` - Create resources per item
- `depends_on` - Explicitly declare dependency

```hcl
resource "aws_instance" "example" {
  count = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example" {
  for_each = var.bucket_names
  bucket   = each.value
}
```

## Functions
- `concat(list1, list2)`
- `join(delim, list)`
- `split(delim, string)`
- `lookup(map, key, default)`
- `length(list)`

Example:
```hcl
output "first_bucket" {
  value = element(var.bucket_names, 0)
}
```

## Terraform Cloud
- Centralized management
- Remote state storage
- VCS integration
- Collaborative workflow

## References
- [Terraform Official Documentation](https://www.terraform.io/docs/index.html)
- [Terraform GitHub Repository](https://github.com/hashicorp/terraform)

