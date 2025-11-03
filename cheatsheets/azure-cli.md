# Azure CLI Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Authentication](#authentication)
- [Account & Subscription Management](#account--subscription-management)
- [Resource Groups](#resource-groups)
- [Virtual Machines](#virtual-machines)
- [Storage](#storage)
- [Networking](#networking)
- [Azure App Service](#azure-app-service)
- [Azure Functions](#azure-functions)
- [Azure Kubernetes Service (AKS)](#azure-kubernetes-service-aks)
- [Azure Container Instances (ACI)](#azure-container-instances-aci)
- [Azure SQL Database](#azure-sql-database)
- [Azure Key Vault](#azure-key-vault)
- [Azure Active Directory](#azure-active-directory)
- [Monitoring & Logging](#monitoring--logging)
- [Common Options](#common-options)
- [Output Formats](#output-formats)
- [JMESPath Queries](#jmespath-queries)
- [Tips & Best Practices](#tips--best-practices)
- [References](#references)

## Introduction

Azure CLI is a cross-platform command-line tool for managing Azure resources. It provides a consistent command-line experience across Windows, macOS, and Linux.

## Installation

### Windows
```powershell
# Using MSI installer
# Download from: https://aka.ms/installazurecliwindows

# Using winget
winget install -e --id Microsoft.AzureCLI

# Using Chocolatey
choco install azure-cli
```

### macOS
```bash
# Using Homebrew
brew update && brew install azure-cli

# Using install script
curl -L https://aka.ms/InstallAzureCli | bash
```

### Linux (Ubuntu/Debian)
```bash
# Install prerequisites
sudo apt-get update
sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg

# Add Microsoft signing key
curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add Azure CLI repository
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list

# Install Azure CLI
sudo apt-get update
sudo apt-get install azure-cli
```

### Linux (RHEL/CentOS)
```bash
# Import Microsoft repository key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add Azure CLI repository
echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo

# Install
sudo yum install azure-cli
```

### Docker
```bash
# Run Azure CLI in Docker container
docker run -it mcr.microsoft.com/azure-cli

# With volume mount
docker run -it -v ~/.azure:/root/.azure mcr.microsoft.com/azure-cli
```

### Verify Installation
```bash
# Check version
az --version
az version

# Update Azure CLI
az upgrade
```

## Authentication

### Interactive Login
```bash
# Login with browser
az login

# Login with specific tenant
az login --tenant <tenant-id>

# Login to Azure Government Cloud
az login --cloud AzureUSGovernment

# Login to Azure China Cloud
az login --cloud AzureChinaCloud
```

### Service Principal Login
```bash
# Login with service principal
az login --service-principal \
  --username <app-id> \
  --password <password-or-cert> \
  --tenant <tenant-id>

# Login with certificate
az login --service-principal \
  --username <app-id> \
  --tenant <tenant-id> \
  --password <cert-path>
```

### Managed Identity
```bash
# Login with system-assigned managed identity
az login --identity

# Login with user-assigned managed identity
az login --identity --username <client-id>
```

### Check Authentication
```bash
# Show current account
az account show

# List all accounts
az account list

# Show current logged-in user
az ad signed-in-user show
```

### Logout
```bash
# Logout
az logout

# Clear cached credentials
az account clear
```

## Account & Subscription Management

### List Subscriptions
```bash
# List all subscriptions
az account list

# List in table format
az account list --output table

# List subscription names only
az account list --query "[].name" -o tsv
```

### Set Active Subscription
```bash
# Set by subscription ID
az account set --subscription <subscription-id>

# Set by subscription name
az account set --subscription "My Subscription"
```

### Show Subscription Details
```bash
# Show current subscription
az account show

# Show specific subscription
az account show --subscription <subscription-id>

# Get subscription ID
az account show --query id -o tsv
```

### Manage Tenants
```bash
# List tenants
az account tenant list

# Show tenant details
az account tenant show --id <tenant-id>
```

## Resource Groups

### Create Resource Group
```bash
# Create resource group
az group create --name myResourceGroup --location eastus

# Create with tags
az group create \
  --name myResourceGroup \
  --location eastus \
  --tags environment=dev project=demo
```

### List Resource Groups
```bash
# List all resource groups
az group list

# List in table format
az group list --output table

# List with specific tag
az group list --tag environment=dev

# Get resource group names
az group list --query "[].name" -o tsv
```

### Show Resource Group
```bash
# Show resource group details
az group show --name myResourceGroup

# Get resource group location
az group show --name myResourceGroup --query location -o tsv
```

### Update Resource Group
```bash
# Update tags
az group update --name myResourceGroup --set tags.status=active

# Add tag
az group update --name myResourceGroup --tags environment=prod
```

### Delete Resource Group
```bash
# Delete resource group
az group delete --name myResourceGroup

# Delete without confirmation
az group delete --name myResourceGroup --yes --no-wait
```

### List Resources in Group
```bash
# List all resources in resource group
az resource list --resource-group myResourceGroup

# List specific resource type
az resource list \
  --resource-group myResourceGroup \
  --resource-type "Microsoft.Compute/virtualMachines"
```

## Virtual Machines

### Create Virtual Machine
```bash
# Create Ubuntu VM
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image Ubuntu2204 \
  --size Standard_B2s \
  --admin-username azureuser \
  --generate-ssh-keys

# Create Windows VM
az vm create \
  --resource-group myResourceGroup \
  --name myWindowsVM \
  --image Win2022Datacenter \
  --size Standard_D2s_v3 \
  --admin-username azureuser \
  --admin-password <password>

# Create VM with specific SSH key
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image Ubuntu2204 \
  --ssh-key-values ~/.ssh/id_rsa.pub

# Create VM with public IP
az vm create \
  --resource-group myResourceGroup \
  --name myVM \
  --image Ubuntu2204 \
  --public-ip-sku Standard \
  --public-ip-address-allocation static
```

### List Virtual Machines
```bash
# List all VMs
az vm list

# List VMs in table format
az vm list --output table

# List VMs in resource group
az vm list --resource-group myResourceGroup

# Get VM names
az vm list --query "[].name" -o tsv
```

### Show VM Details
```bash
# Show VM details
az vm show --resource-group myResourceGroup --name myVM

# Get VM status
az vm get-instance-view \
  --resource-group myResourceGroup \
  --name myVM \
  --query instanceView.statuses[1].displayStatus -o tsv

# Get VM public IP
az vm show \
  --resource-group myResourceGroup \
  --name myVM \
  --show-details \
  --query publicIps -o tsv
```

### Start/Stop/Restart VM
```bash
# Start VM
az vm start --resource-group myResourceGroup --name myVM

# Stop VM (deallocate)
az vm deallocate --resource-group myResourceGroup --name myVM

# Stop VM (keep allocated)
az vm stop --resource-group myResourceGroup --name myVM

# Restart VM
az vm restart --resource-group myResourceGroup --name myVM
```

### Delete VM
```bash
# Delete VM
az vm delete --resource-group myResourceGroup --name myVM

# Delete without confirmation
az vm delete --resource-group myResourceGroup --name myVM --yes
```

### VM Sizes
```bash
# List available VM sizes in location
az vm list-sizes --location eastus

# List VM sizes in table format
az vm list-sizes --location eastus --output table
```

### VM Images
```bash
# List popular images
az vm image list --output table

# List all Ubuntu images
az vm image list --publisher Canonical --all --output table

# List specific image SKUs
az vm image list-skus \
  --location eastus \
  --publisher Canonical \
  --offer UbuntuServer
```

## Storage

### Storage Accounts

#### Create Storage Account
```bash
# Create storage account
az storage account create \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2

# Create with specific replication
az storage account create \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Standard_GRS
```

#### List Storage Accounts
```bash
# List all storage accounts
az storage account list

# List in resource group
az storage account list --resource-group myResourceGroup

# List in table format
az storage account list --output table
```

#### Get Storage Account Keys
```bash
# Get storage account keys
az storage account keys list \
  --account-name mystorageaccount \
  --resource-group myResourceGroup

# Get first key only
az storage account keys list \
  --account-name mystorageaccount \
  --resource-group myResourceGroup \
  --query "[0].value" -o tsv
```

#### Get Connection String
```bash
# Get connection string
az storage account show-connection-string \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --query connectionString -o tsv
```

#### Delete Storage Account
```bash
# Delete storage account
az storage account delete \
  --name mystorageaccount \
  --resource-group myResourceGroup \
  --yes
```

### Blob Storage

#### Create Container
```bash
# Create blob container
az storage container create \
  --name mycontainer \
  --account-name mystorageaccount \
  --account-key <storage-key>

# Create with public access
az storage container create \
  --name mycontainer \
  --account-name mystorageaccount \
  --public-access blob
```

#### Upload Blob
```bash
# Upload file
az storage blob upload \
  --container-name mycontainer \
  --name myblob.txt \
  --file ./local-file.txt \
  --account-name mystorageaccount \
  --account-key <storage-key>

# Upload directory
az storage blob upload-batch \
  --destination mycontainer \
  --source ./local-directory \
  --account-name mystorageaccount
```

#### Download Blob
```bash
# Download file
az storage blob download \
  --container-name mycontainer \
  --name myblob.txt \
  --file ./downloaded-file.txt \
  --account-name mystorageaccount \
  --account-key <storage-key>

# Download directory
az storage blob download-batch \
  --destination ./local-directory \
  --source mycontainer \
  --account-name mystorageaccount
```

#### List Blobs
```bash
# List blobs in container
az storage blob list \
  --container-name mycontainer \
  --account-name mystorageaccount \
  --output table

# List with prefix
az storage blob list \
  --container-name mycontainer \
  --prefix "folder/" \
  --account-name mystorageaccount
```

#### Delete Blob
```bash
# Delete blob
az storage blob delete \
  --container-name mycontainer \
  --name myblob.txt \
  --account-name mystorageaccount
```

## Networking

### Virtual Networks

#### Create Virtual Network
```bash
# Create virtual network
az network vnet create \
  --resource-group myResourceGroup \
  --name myVNet \
  --address-prefix 10.0.0.0/16 \
  --subnet-name mySubnet \
  --subnet-prefix 10.0.1.0/24

# Create with multiple subnets
az network vnet create \
  --resource-group myResourceGroup \
  --name myVNet \
  --address-prefixes 10.0.0.0/16 10.1.0.0/16
```

#### List Virtual Networks
```bash
# List all virtual networks
az network vnet list

# List in resource group
az network vnet list --resource-group myResourceGroup --output table
```

#### Create Subnet
```bash
# Create subnet
az network vnet subnet create \
  --resource-group myResourceGroup \
  --vnet-name myVNet \
  --name mySubnet \
  --address-prefix 10.0.2.0/24
```

### Network Security Groups (NSG)

#### Create NSG
```bash
# Create network security group
az network nsg create \
  --resource-group myResourceGroup \
  --name myNSG
```

#### Create NSG Rule
```bash
# Allow SSH
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --name allow-ssh \
  --priority 1000 \
  --source-address-prefixes '*' \
  --destination-port-ranges 22 \
  --access Allow \
  --protocol Tcp

# Allow HTTP
az network nsg rule create \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --name allow-http \
  --priority 1001 \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp
```

#### List NSG Rules
```bash
# List NSG rules
az network nsg rule list \
  --resource-group myResourceGroup \
  --nsg-name myNSG \
  --output table
```

### Public IP Addresses

#### Create Public IP
```bash
# Create static public IP
az network public-ip create \
  --resource-group myResourceGroup \
  --name myPublicIP \
  --sku Standard \
  --allocation-method Static

# Create with DNS name
az network public-ip create \
  --resource-group myResourceGroup \
  --name myPublicIP \
  --dns-name myuniquednsname
```

#### Show Public IP
```bash
# Get public IP address
az network public-ip show \
  --resource-group myResourceGroup \
  --name myPublicIP \
  --query ipAddress -o tsv
```

### Load Balancer

#### Create Load Balancer
```bash
# Create public load balancer
az network lb create \
  --resource-group myResourceGroup \
  --name myLoadBalancer \
  --sku Standard \
  --public-ip-address myPublicIP \
  --frontend-ip-name myFrontEnd \
  --backend-pool-name myBackEndPool
```

## Azure App Service

### Create App Service Plan
```bash
# Create Linux app service plan
az appservice plan create \
  --name myAppServicePlan \
  --resource-group myResourceGroup \
  --sku B1 \
  --is-linux

# Create Windows app service plan
az appservice plan create \
  --name myAppServicePlan \
  --resource-group myResourceGroup \
  --sku S1
```

### Create Web App
```bash
# Create Node.js web app
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name myWebApp \
  --runtime "NODE|18-lts"

# Create Python web app
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name myWebApp \
  --runtime "PYTHON|3.11"

# Create .NET web app
az webapp create \
  --resource-group myResourceGroup \
  --plan myAppServicePlan \
  --name myWebApp \
  --runtime "DOTNET|7.0"
```

### Deploy Web App
```bash
# Deploy from local Git
az webapp deployment source config-local-git \
  --name myWebApp \
  --resource-group myResourceGroup

# Deploy from GitHub
az webapp deployment source config \
  --name myWebApp \
  --resource-group myResourceGroup \
  --repo-url https://github.com/user/repo \
  --branch main

# Deploy ZIP file
az webapp deployment source config-zip \
  --resource-group myResourceGroup \
  --name myWebApp \
  --src app.zip
```

### Configure Web App
```bash
# Set app settings
az webapp config appsettings set \
  --resource-group myResourceGroup \
  --name myWebApp \
  --settings KEY1=value1 KEY2=value2

# List app settings
az webapp config appsettings list \
  --resource-group myResourceGroup \
  --name myWebApp

# Set connection string
az webapp config connection-string set \
  --resource-group myResourceGroup \
  --name myWebApp \
  --connection-string-type SQLAzure \
  --settings MyDb="Server=myserver;Database=mydb;User=user;Password=pass"
```

### Manage Web App
```bash
# Start web app
az webapp start --name myWebApp --resource-group myResourceGroup

# Stop web app
az webapp stop --name myWebApp --resource-group myResourceGroup

# Restart web app
az webapp restart --name myWebApp --resource-group myResourceGroup

# Get web app URL
az webapp show \
  --name myWebApp \
  --resource-group myResourceGroup \
  --query defaultHostName -o tsv
```

### View Logs
```bash
# Enable logging
az webapp log config \
  --name myWebApp \
  --resource-group myResourceGroup \
  --application-logging filesystem \
  --level verbose

# Tail logs
az webapp log tail \
  --name myWebApp \
  --resource-group myResourceGroup

# Download logs
az webapp log download \
  --name myWebApp \
  --resource-group myResourceGroup \
  --log-file logs.zip
```

## Azure Functions

### Create Function App
```bash
# Create storage account for function app
az storage account create \
  --name myfunctionstorage \
  --resource-group myResourceGroup \
  --location eastus \
  --sku Standard_LRS

# Create function app (Python)
az functionapp create \
  --resource-group myResourceGroup \
  --name myFunctionApp \
  --storage-account myfunctionstorage \
  --consumption-plan-location eastus \
  --runtime python \
  --runtime-version 3.11 \
  --functions-version 4

# Create function app (Node.js)
az functionapp create \
  --resource-group myResourceGroup \
  --name myFunctionApp \
  --storage-account myfunctionstorage \
  --runtime node \
  --runtime-version 18
```

### Deploy Function App
```bash
# Deploy from local directory
az functionapp deployment source config-zip \
  --resource-group myResourceGroup \
  --name myFunctionApp \
  --src function.zip
```

### Configure Function App
```bash
# Set application settings
az functionapp config appsettings set \
  --name myFunctionApp \
  --resource-group myResourceGroup \
  --settings API_KEY=value DB_CONNECTION=value
```

## Azure Kubernetes Service (AKS)

### Create AKS Cluster
```bash
# Create AKS cluster
az aks create \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --node-count 2 \
  --node-vm-size Standard_D2s_v3 \
  --generate-ssh-keys

# Create with specific Kubernetes version
az aks create \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --kubernetes-version 1.27.7 \
  --node-count 3

# Create with Azure CNI networking
az aks create \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --network-plugin azure \
  --vnet-subnet-id <subnet-id>
```

### Get AKS Credentials
```bash
# Get credentials
az aks get-credentials \
  --resource-group myResourceGroup \
  --name myAKSCluster

# Get credentials with admin access
az aks get-credentials \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --admin
```

### Manage AKS Cluster
```bash
# List AKS clusters
az aks list --output table

# Show cluster details
az aks show \
  --resource-group myResourceGroup \
  --name myAKSCluster

# Scale cluster
az aks scale \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --node-count 5

# Upgrade cluster
az aks upgrade \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --kubernetes-version 1.28.0

# Start stopped cluster
az aks start \
  --resource-group myResourceGroup \
  --name myAKSCluster

# Stop cluster
az aks stop \
  --resource-group myResourceGroup \
  --name myAKSCluster
```

### Node Pools
```bash
# Add node pool
az aks nodepool add \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynodepool \
  --node-count 3 \
  --node-vm-size Standard_D4s_v3

# List node pools
az aks nodepool list \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --output table

# Scale node pool
az aks nodepool scale \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynodepool \
  --node-count 5

# Delete node pool
az aks nodepool delete \
  --resource-group myResourceGroup \
  --cluster-name myAKSCluster \
  --name mynodepool
```

## Azure Container Instances (ACI)

### Create Container Instance
```bash
# Create container instance
az container create \
  --resource-group myResourceGroup \
  --name mycontainer \
  --image nginx:latest \
  --dns-name-label myapp-unique \
  --ports 80

# Create with environment variables
az container create \
  --resource-group myResourceGroup \
  --name mycontainer \
  --image myapp:latest \
  --environment-variables KEY1=value1 KEY2=value2

# Create with CPU and memory limits
az container create \
  --resource-group myResourceGroup \
  --name mycontainer \
  --image myapp:latest \
  --cpu 2 \
  --memory 4
```

### Manage Container Instances
```bash
# List container instances
az container list --output table

# Show container details
az container show \
  --resource-group myResourceGroup \
  --name mycontainer

# Get container logs
az container logs \
  --resource-group myResourceGroup \
  --name mycontainer

# Execute command in container
az container exec \
  --resource-group myResourceGroup \
  --name mycontainer \
  --exec-command "/bin/bash"

# Delete container instance
az container delete \
  --resource-group myResourceGroup \
  --name mycontainer \
  --yes
```

## Azure SQL Database

### Create SQL Server
```bash
# Create SQL server
az sql server create \
  --name myserver \
  --resource-group myResourceGroup \
  --location eastus \
  --admin-user sqladmin \
  --admin-password <password>

# Create firewall rule
az sql server firewall-rule create \
  --resource-group myResourceGroup \
  --server myserver \
  --name AllowMyIP \
  --start-ip-address 1.2.3.4 \
  --end-ip-address 1.2.3.4

# Allow Azure services
az sql server firewall-rule create \
  --resource-group myResourceGroup \
  --server myserver \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

### Create SQL Database
```bash
# Create database
az sql db create \
  --resource-group myResourceGroup \
  --server myserver \
  --name mydatabase \
  --service-objective S0

# Create with specific edition
az sql db create \
  --resource-group myResourceGroup \
  --server myserver \
  --name mydatabase \
  --edition Premium \
  --capacity 125
```

### Manage SQL Database
```bash
# List databases
az sql db list \
  --resource-group myResourceGroup \
  --server myserver \
  --output table

# Show database details
az sql db show \
  --resource-group myResourceGroup \
  --server myserver \
  --name mydatabase

# Get connection string
az sql db show-connection-string \
  --server myserver \
  --name mydatabase \
  --client ado.net
```

## Azure Key Vault

### Create Key Vault
```bash
# Create key vault
az keyvault create \
  --name mykeyvault \
  --resource-group myResourceGroup \
  --location eastus

# Create with specific SKU
az keyvault create \
  --name mykeyvault \
  --resource-group myResourceGroup \
  --location eastus \
  --sku premium
```

### Manage Secrets
```bash
# Set secret
az keyvault secret set \
  --vault-name mykeyvault \
  --name mysecret \
  --value "secret-value"

# Get secret
az keyvault secret show \
  --vault-name mykeyvault \
  --name mysecret \
  --query value -o tsv

# List secrets
az keyvault secret list \
  --vault-name mykeyvault \
  --output table

# Delete secret
az keyvault secret delete \
  --vault-name mykeyvault \
  --name mysecret
```

### Manage Keys
```bash
# Create key
az keyvault key create \
  --vault-name mykeyvault \
  --name mykey \
  --protection software

# List keys
az keyvault key list \
  --vault-name mykeyvault \
  --output table

# Get key
az keyvault key show \
  --vault-name mykeyvault \
  --name mykey
```

### Access Policies
```bash
# Set access policy
az keyvault set-policy \
  --name mykeyvault \
  --upn user@domain.com \
  --secret-permissions get list set delete

# Set policy for service principal
az keyvault set-policy \
  --name mykeyvault \
  --spn <app-id> \
  --secret-permissions get list
```

## Azure Active Directory

### Users
```bash
# Create user
az ad user create \
  --display-name "John Doe" \
  --user-principal-name john@domain.com \
  --password <password>

# List users
az ad user list --output table

# Show user
az ad user show --id user@domain.com

# Delete user
az ad user delete --id user@domain.com
```

### Groups
```bash
# Create group
az ad group create \
  --display-name "Developers" \
  --mail-nickname developers

# List groups
az ad group list --output table

# Add member to group
az ad group member add \
  --group Developers \
  --member-id <user-object-id>

# List group members
az ad group member list \
  --group Developers \
  --output table
```

### Service Principals
```bash
# Create service principal
az ad sp create-for-rbac \
  --name myServicePrincipal

# Create with specific role
az ad sp create-for-rbac \
  --name myServicePrincipal \
  --role Contributor \
  --scopes /subscriptions/<subscription-id>/resourceGroups/myResourceGroup

# List service principals
az ad sp list --output table

# Show service principal
az ad sp show --id <app-id>

# Delete service principal
az ad sp delete --id <app-id>
```

## Monitoring & Logging

### Activity Logs
```bash
# List activity logs
az monitor activity-log list --output table

# List for resource group
az monitor activity-log list \
  --resource-group myResourceGroup \
  --output table

# List with time range
az monitor activity-log list \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-31T23:59:59Z
```

### Metrics
```bash
# List available metrics
az monitor metrics list-definitions \
  --resource <resource-id>

# Get metrics
az monitor metrics list \
  --resource <resource-id> \
  --metric "Percentage CPU" \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-01T23:59:59Z
```

### Log Analytics
```bash
# Create workspace
az monitor log-analytics workspace create \
  --resource-group myResourceGroup \
  --workspace-name myWorkspace

# Query workspace
az monitor log-analytics query \
  --workspace <workspace-id> \
  --analytics-query "AzureActivity | limit 10"
```

## Common Options

### Global Options
```bash
# Specify output format
az <command> --output json    # JSON (default)
az <command> --output table   # Human-readable table
az <command> --output tsv     # Tab-separated values
az <command> --output yaml    # YAML format
az <command> -o table          # Short form

# Specify subscription
az <command> --subscription <subscription-id>

# Debug mode
az <command> --debug

# Verbose output
az <command> --verbose

# Only show errors
az <command> --only-show-errors

# No wait (async operation)
az <command> --no-wait

# Help
az <command> --help
az <command> -h
```

## Output Formats

### JSON (Default)
```bash
az group list
az group list --output json
```

### Table
```bash
# Human-readable table format
az group list --output table
az group list -o table
```

### TSV (Tab-Separated Values)
```bash
# Good for scripting
az group list --output tsv
az group list --query "[].name" -o tsv
```

### YAML
```bash
az group list --output yaml
```

## JMESPath Queries

### Basic Queries
```bash
# Get all names
az group list --query "[].name"

# Get first item
az group list --query "[0]"

# Filter by property
az group list --query "[?location=='eastus']"

# Select specific properties
az group list --query "[].{Name:name, Location:location}"

# Get single value
az group show --name myResourceGroup --query location -o tsv
```

### Advanced Queries
```bash
# Filter and select
az vm list --query "[?storageProfile.osDisk.osType=='Linux'].{Name:name, Size:hardwareProfile.vmSize}"

# Sort results
az vm list --query "sort_by([], &name)"

# Contains filter
az group list --query "[?contains(name, 'prod')]"

# Multiple conditions
az vm list --query "[?location=='eastus' && powerState=='VM running']"
```

## Tips & Best Practices

### Configuration
```bash
# Set default location
az config set defaults.location=eastus

# Set default resource group
az config set defaults.group=myResourceGroup

# Set default output format
az config set core.output=table

# Show current configuration
az config get

# Unset configuration
az config unset defaults.location
```

### Scripting Tips
```bash
# Capture output in variable
RG_NAME=$(az group show --name myResourceGroup --query name -o tsv)

# Check if resource exists
if az group exists --name myResourceGroup; then
  echo "Resource group exists"
fi

# Loop through results
for vm in $(az vm list --query "[].name" -o tsv); do
  echo "VM: $vm"
done

# Error handling
if ! az group create --name myResourceGroup --location eastus; then
  echo "Failed to create resource group"
  exit 1
fi
```

### Performance
```bash
# Use --no-wait for long-running operations
az vm create ... --no-wait

# Use --ids for batch operations
VM_IDS=$(az vm list --query "[].id" -o tsv)
az vm start --ids $VM_IDS

# Use --query to reduce data transfer
az vm list --query "[].{name:name, location:location}" -o table
```

### Security
```bash
# Use environment variables for secrets
export ADMIN_PASSWORD="secretpassword"
az vm create ... --admin-password $ADMIN_PASSWORD

# Use Key Vault for sensitive data
az keyvault secret set --vault-name mykeyvault --name vm-password --value "secret"
PASSWORD=$(az keyvault secret show --vault-name mykeyvault --name vm-password --query value -o tsv)

# Use managed identities instead of service principals when possible
az vm identity assign --name myVM --resource-group myResourceGroup
```

### Resource Tagging
```bash
# Tag resources for better organization
az group create --name myResourceGroup --location eastus --tags environment=prod cost-center=IT

# Update tags
az resource tag --tags environment=staging --resource-group myResourceGroup --name myVM --resource-type "Microsoft.Compute/virtualMachines"

# Query by tags
az resource list --tag environment=prod
```

### Cost Management
```bash
# Use auto-shutdown for dev/test VMs
az vm auto-shutdown --resource-group myResourceGroup --name myVM --time 1900

# Use B-series or Spot VMs for non-production
az vm create ... --size Standard_B2s
az vm create ... --priority Spot --max-price -1

# Deallocate VMs when not in use
az vm deallocate --resource-group myResourceGroup --name myVM
```

## References

- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure CLI GitHub Repository](https://github.com/Azure/azure-cli)
- [Azure CLI Extensions](https://docs.microsoft.com/en-us/cli/azure/azure-cli-extensions-list)
- [JMESPath Query Documentation](https://jmespath.org/)
- [Azure CLI Release Notes](https://docs.microsoft.com/en-us/cli/azure/release-notes-azure-cli)
