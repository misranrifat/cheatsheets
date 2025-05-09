# Vagrant Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Workflow](#basic-workflow)
- [Vagrantfile Explained](#vagrantfile-explained)
- [Basic Commands](#basic-commands)
- [Boxes](#boxes)
- [Networking](#networking)
- [Synced Folders](#synced-folders)
- [Provisioning](#provisioning)
- [Multi-Machine Setup](#multi-machine-setup)
- [Plugins](#plugins)
- [Tips and Tricks](#tips-and-tricks)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Introduction
Vagrant is a tool for building and managing virtualized development environments. It works with providers like VirtualBox, VMware, Hyper-V, Docker, etc.

## Installation
```bash
# MacOS
brew install --cask vagrant

# Ubuntu/Debian
sudo apt update
sudo apt install vagrant

# Windows
Download installer from https://www.vagrantup.com/downloads
```

## Basic Workflow
```bash
vagrant init               # Initialize a new Vagrant environment
vagrant up                 # Create and configure guest machines
vagrant ssh                # SSH into a running machine
vagrant halt               # Shutdown running machine
vagrant suspend            # Suspend machine
vagrant resume             # Resume suspended machine
vagrant reload             # Reload machine config
vagrant destroy            # Delete the machine
```

## Vagrantfile Explained
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.synced_folder "./data", "/vagrant_data"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2
  SHELL
end
```

- `config.vm.box` - Base image
- `config.vm.network` - Network settings
- `config.vm.synced_folder` - Folder sharing
- `config.vm.provision` - Provisioning setup

## Basic Commands
```bash
vagrant box list            # List installed boxes
vagrant box add <box-name>  # Add a new box
vagrant box remove <box-name> # Remove a box
vagrant global-status       # List all active vagrant environments
vagrant status              # Check status of the current environment
vagrant provision           # Re-provision the machine
vagrant snapshot save <name>  # Save a snapshot
vagrant snapshot restore <name>  # Restore a snapshot
```

## Boxes
- Prepackaged base images
- Common sources:
  - https://app.vagrantup.com/boxes/search

```bash
vagrant box add ubuntu/bionic64
```

## Networking
- **Port Forwarding**
```ruby
config.vm.network "forwarded_port", guest: 80, host: 8080
```
- **Private Network**
```ruby
config.vm.network "private_network", ip: "192.168.33.10"
```
- **Public Network**
```ruby
config.vm.network "public_network"
```

## Synced Folders
```ruby
config.vm.synced_folder "./host_folder", "/vagrant_folder"
```
Options:
- `type: "nfs"` for NFS mount
- `disabled: true` to disable sync

## Provisioning
- Shell
```ruby
config.vm.provision "shell", path: "setup.sh"
```
- Inline Shell
```ruby
config.vm.provision "shell", inline: "echo Hello, World"
```
- Ansible, Puppet, Chef support
```ruby
config.vm.provision "ansible" do |ansible|
  ansible.playbook = "playbook.yml"
end
```

## Multi-Machine Setup
```ruby
Vagrant.configure("2") do |config|
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/bionic64"
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/bionic64"
  end
end
```

## Plugins
- Install plugin
```bash
vagrant plugin install vagrant-disksize
```
- Popular plugins:
  - vagrant-disksize
  - vagrant-cachier
  - vagrant-vbguest

## Tips and Tricks
- Use `vagrant ssh-config` to configure your SSH client.
- Use synced folders for quick file sharing.
- Always destroy unused VMs to free up resources.
- Use provisioners to automate setup.
- Set up multiple provisioners for flexibility.

## Troubleshooting
- If networking fails, try `vagrant reload`.
- If box download is slow, try adding alternate mirrors.
- Clear and rebuild with `vagrant destroy && vagrant up`.
- Check VirtualBox versions compatibility.
- Use `vagrant plugin repair` for plugin issues.

## References
- [Vagrant Official Documentation](https://www.vagrantup.com/docs)
- [Vagrant GitHub Repository](https://github.com/hashicorp/vagrant)
- [Vagrant Boxes](https://app.vagrantup.com/boxes/search)

