# Packer Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Concepts](#basic-concepts)
- [Basic Commands](#basic-commands)
- [Template Structure](#template-structure)
- [Builders](#builders)
- [Provisioners](#provisioners)
- [Post-Processors](#post-processors)
- [Variables and User Inputs](#variables-and-user-inputs)
- [Conditionals and Loops](#conditionals-and-loops)
- [Packer Plugins](#packer-plugins)
- [Best Practices](#best-practices)
- [References](#references)

## Introduction
Packer automates the creation of machine images for multiple platforms from a single source configuration.

## Installation
```bash
brew install packer        # MacOS
choco install packer       # Windows
apt-get install packer     # Linux (via package manager)
```

## Basic Concepts
- **Template**: JSON or HCL2 configuration describing the build process.
- **Builder**: Creates the machine image (e.g., AWS AMI, Docker image).
- **Provisioner**: Installs and configures software on the image.
- **Post-Processor**: Actions to run after image creation (e.g., compress, upload).

## Basic Commands
```bash
packer init .               # Initialize a Packer template (HCL only)
packer validate template.hcl # Validate the configuration file
packer build template.hcl    # Execute the build
packer fmt .                 # Format templates to standard style
```

## Template Structure (HCL2)
```hcl
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "example" {
  region           = var.aws_region
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = "packer-example-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = ["sudo yum update -y"]
  }
}
```

## Builders
Common builders:
- `amazon-ebs`: EC2 instance to AMI
- `docker`: Build Docker container images
- `googlecompute`: GCP images
- `azure-arm`: Azure VM images
- `vmware-iso`, `virtualbox-iso`: Local VM images

Builder example:
```hcl
source "docker" "ubuntu" {
  image  = "ubuntu"
  commit = true
}
```

## Provisioners
Provisioners install and configure software.
- `shell`
- `ansible`
- `chef-solo`
- `file` (copy files)

Shell example:
```hcl
provisioner "shell" {
  script = "setup.sh"
}
```

File example:
```hcl
provisioner "file" {
  source      = "localfile"
  destination = "/tmp/remote"
}
```

## Post-Processors
Post-process the result after build:
- `docker-tag`
- `docker-push`
- `compress`
- `manifest`

Example to push a Docker image:
```hcl
post-processor "docker-push" {
  login    = true
  ecr_login = true
}
```

## Variables and User Inputs
Declare variables:
```hcl
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
```
Use variables:
```hcl
region = var.aws_region
```

Prompt for input:
```hcl
variable "image_version" {
  type = string
}
```
Packer will ask during `packer build`.

## Conditionals and Loops
### Conditional Expressions
```hcl
instance_type = var.env == "prod" ? "m5.large" : "t2.micro"
```

### Loops
```hcl
provisioner "file" {
  for_each = toset(["file1", "file2"])
  source      = each.value
  destination = "/tmp/${each.value}"
}
```

## Packer Plugins
Install new builders, provisioners, and post-processors.

Install:
```bash
packer plugins install github.com/hashicorp/amazon
```

## Best Practices
- Use HCL2 format for templates (better structure, reusability)
- Modularize build steps into components
- Use Packer variables and environment variables
- Test templates locally before production runs
- Version control your templates
- Use minimum IAM permissions

## References
- [Packer Official Documentation](https://www.packer.io/docs)
- [Packer HCL2 Templates](https://www.packer.io/docs/templates/hcl_templates)
- [Packer Builders List](https://www.packer.io/docs/builders)

