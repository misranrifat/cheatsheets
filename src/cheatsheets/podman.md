# Podman Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Podman vs Docker](#podman-vs-docker)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Container Management](#container-management)
- [Image Management](#image-management)
- [Pod Management](#pod-management)
- [Volumes and Storage](#volumes-and-storage)
- [Networking](#networking)
- [Advanced Usage](#advanced-usage)
- [Rootless Mode](#rootless-mode)
- [Podman Compose](#podman-compose)
- [References](#references)

## Introduction
Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux system.

## Podman vs Docker
- No daemon required (daemonless)
- Supports rootless containers
- CLI is Docker-compatible (`alias docker=podman`)
- Pod concept: group containers into a pod

## Installation
```bash
# Fedora
sudo dnf install podman

# Ubuntu/Debian
sudo apt update
sudo apt install podman

# MacOS
brew install podman

# Windows (via WSL or Podman Machine)
```

## Basic Commands
```bash
podman version            # Show version
podman info               # Display system information
podman help                # Show help
```

## Container Management
```bash
podman pull <image>                         # Pull an image
podman run -it --name <name> <image>         # Run a container
podman ps                                   # List running containers
podman ps -a                                # List all containers
podman stop <container>                     # Stop a running container
podman start <container>                    # Start a container
podman restart <container>                  # Restart a container
podman rm <container>                       # Remove a container
podman logs <container>                     # View container logs
podman exec -it <container> /bin/bash        # Execute a command inside a container
```

## Image Management
```bash
podman images                               # List local images
podman rmi <image>                          # Remove an image
podman inspect <image/container>            # Inspect an image or container
podman tag <image> <new-name>                # Tag an image
podman push <image> <destination>            # Push an image to a registry
```

## Pod Management
```bash
podman pod create --name <pod-name>          # Create a new pod
podman pod ps                                # List pods
podman pod inspect <pod-name>                # Inspect a pod
podman pod rm <pod-name>                     # Remove a pod
podman run --pod <pod-name> <image>          # Run container inside a pod
```

## Volumes and Storage
```bash
podman volume create <volume-name>           # Create a volume
podman volume ls                             # List volumes
podman volume inspect <volume-name>          # Inspect a volume
podman volume rm <volume-name>                # Remove a volume

# Bind mount a host directory
podman run -v /host/path:/container/path <image>
```

## Networking
```bash
podman network ls                            # List networks
podman network create <network-name>          # Create a network
podman network inspect <network-name>         # Inspect a network
podman network rm <network-name>               # Remove a network

# Connect a container to a network
podman network connect <network> <container>
```

## Advanced Usage
```bash
# Generate a systemd service for a container
podman generate systemd --name <container>

# Build image from Dockerfile
podman build -t <image-name> .

# Save an image to a tar archive
podman save -o <output.tar> <image>

# Load an image from a tar archive
podman load -i <input.tar>

# Healthcheck example
podman run --health-cmd='curl -f http://localhost/ || exit 1' --health-interval=30s <image>
```

## Rootless Mode
```bash
# Run containers as a regular user
# No special setup needed on modern Linux distributions

# Check user namespace support
podman unshare cat /proc/self/uid_map
```

## Podman Compose
```bash
# Install
pip install podman-compose

# Usage (similar to docker-compose)
podman-compose -f docker-compose.yml up
podman-compose -f docker-compose.yml down
```

## References
- [Podman Official Documentation](https://podman.io/)
- [Podman Github Repository](https://github.com/containers/podman)

