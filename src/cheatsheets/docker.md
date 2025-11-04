# Docker Cheatsheet

## Table of Contents
- [Installation](#installation)
- [Docker Basics](#docker-basics)
- [Container Management](#container-management)
- [Image Management](#image-management)
- [Docker Networking](#docker-networking)
- [Docker Volumes](#docker-volumes)
- [Docker Compose](#docker-compose)
- [Docker Swarm](#docker-swarm)
- [Dockerfile Reference](#dockerfile-reference)
- [Registry & Repository](#registry--repository)
- [System Commands](#system-commands)
- [Best Practices](#best-practices)

## Installation

### Linux (Ubuntu/Debian)
```bash
# Update existing packages
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add current user to docker group (to run Docker without sudo)
sudo usermod -aG docker $USER
# Log out and back in for this to take effect
```

### macOS
- Download and install Docker Desktop from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

### Windows
- Download and install Docker Desktop from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/)
- Windows requires WSL 2 or Hyper-V to be enabled

## Docker Basics

### Check Docker version
```bash
docker --version
docker version    # More detailed info
```

### Get Docker info
```bash
docker info
```

### Docker help
```bash
docker --help
docker <COMMAND> --help
```

## Container Management

### Run a container
```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

# Common options:
# -d, --detach          Run in background
# -p, --publish         Publish container ports to host
# -v, --volume          Mount volume
# -e, --env             Set environment variables
# --name                Assign a name to the container
# --rm                  Remove container when it exits
# -it                   Interactive with TTY (terminal)
# --network             Connect to a network

# Examples:
docker run nginx                     # Run nginx container
docker run -d nginx                  # Run in background
docker run -d --name web nginx       # Run with name
docker run -d -p 8080:80 nginx       # Map port 80 to 8080
docker run -d -e ENV_VAR=value nginx # Set environment variable
docker run -it ubuntu bash           # Run with interactive shell
docker run --rm nginx                # Remove when stopped
```

### List containers
```bash
docker ps                 # List running containers
docker ps -a              # List all containers
docker ps -q              # Only display container IDs
docker ps -s              # Display size
```

### Container operations
```bash
docker stop CONTAINER     # Stop a container
docker start CONTAINER    # Start a stopped container
docker restart CONTAINER  # Restart a container
docker pause CONTAINER    # Pause a container
docker unpause CONTAINER  # Unpause a container
docker kill CONTAINER     # Kill a container
docker rm CONTAINER       # Remove a container
docker rm -f CONTAINER    # Force remove running container
docker rename OLD_NAME NEW_NAME # Rename container
```

### Remove all containers
```bash
docker rm $(docker ps -aq)       # Remove all stopped containers
docker rm -f $(docker ps -aq)    # Force remove all containers (including running)
```

### Container logs and inspection
```bash
docker logs CONTAINER            # Show container logs
docker logs -f CONTAINER         # Follow log output
docker logs --tail 100 CONTAINER # Show last 100 lines
docker logs --since 2h CONTAINER # Show logs from last 2 hours

docker inspect CONTAINER         # Detailed container info in JSON
docker top CONTAINER             # Display running processes
docker stats [CONTAINER]         # Container resource usage stats
```

### Execute commands in a running container
```bash
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

# Examples:
docker exec -it CONTAINER bash   # Interactive shell
docker exec CONTAINER ls -la     # Run ls command
docker exec -e VAR=value CONTAINER command # With env var
```

### Copy files between host and container
```bash
docker cp CONTAINER:SOURCE_PATH DEST_PATH    # From container to host
docker cp SOURCE_PATH CONTAINER:DEST_PATH    # From host to container
```

### Create a container without running it
```bash
docker create [OPTIONS] IMAGE [COMMAND] [ARG...]
```

### Container resource constraints
```bash
docker run --memory=1g --memory-swap=2g nginx  # Memory limit
docker run --cpus=2.5 nginx                     # CPU limit
docker update --cpus=1.5 CONTAINER              # Update running container
```

## Image Management

### List images
```bash
docker images               # List images
docker image ls             # List images
docker image ls -a          # Include intermediate images
docker image ls --digests   # Show digests
docker image ls --format "{{.Repository}}:{{.Tag}}"  # Custom format
```

### Pull images from registry
```bash
docker pull [OPTIONS] NAME[:TAG]

# Examples:
docker pull nginx           # Latest tag
docker pull nginx:1.19      # Specific tag
docker pull mcr.microsoft.com/dotnet/sdk:5.0   # From Microsoft registry
```

### Build images from Dockerfile
```bash
docker build [OPTIONS] PATH | URL | -

# Examples:
docker build .                              # Build using current directory
docker build -t myimage:tag .               # Build and tag
docker build -f Dockerfile.dev .            # Specify Dockerfile
docker build --no-cache .                   # Ignore cache
docker build --build-arg ARG_NAME=value .   # Build arguments
docker build --target build_stage .         # Multi-stage build
```

### Tag images
```bash
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]

# Example:
docker tag nginx:latest myregistry.com/myname/nginx:v1
```

### Push images to registry
```bash
docker push [OPTIONS] NAME[:TAG]

# Example:
docker push myregistry.com/myname/nginx:v1
```

### Remove images
```bash
docker rmi IMAGE            # Remove image
docker rmi -f IMAGE         # Force remove
docker rmi $(docker images -q)  # Remove all images
docker image prune          # Remove dangling images
docker image prune -a       # Remove all unused images
```

### Image history and inspection
```bash
docker history IMAGE        # Show image history
docker inspect IMAGE        # Show detailed image info
```

### Save and load images
```bash
docker save -o filename.tar IMAGE    # Save image to tar file
docker load -i filename.tar          # Load image from tar file
```

### Import/export container as image
```bash
docker export CONTAINER > filename.tar    # Export container filesystem
docker import filename.tar [REPOSITORY[:TAG]]  # Import filesystem as image
```

## Docker Networking

### List networks
```bash
docker network ls
```

### Create network
```bash
docker network create [OPTIONS] NETWORK

# Examples:
docker network create mynetwork                 # Bridge network
docker network create -d bridge mynetwork       # Specify driver
docker network create --subnet=172.18.0.0/16 mynetwork  # With subnet
```

### Connect/disconnect containers
```bash
docker network connect NETWORK CONTAINER
docker network disconnect NETWORK CONTAINER
```

### Inspect network
```bash
docker network inspect NETWORK
```

### Remove network
```bash
docker network rm NETWORK
docker network prune        # Remove all unused networks
```

### Run container with network settings
```bash
docker run --network=host nginx                 # Use host network
docker run --network=bridge nginx               # Use bridge network
docker run --network=none nginx                 # No network
docker run --network=mynetwork nginx            # Custom network
docker run --ip=172.18.0.10 --network=mynetwork nginx # Specific IP
```

## Docker Volumes

### List volumes
```bash
docker volume ls
```

### Create volume
```bash
docker volume create [OPTIONS] [VOLUME]

# Example:
docker volume create myvolume
```

### Inspect volume
```bash
docker volume inspect VOLUME
```

### Remove volumes
```bash
docker volume rm VOLUME
docker volume prune       # Remove all unused volumes
```

### Mount volumes in containers
```bash
# Named volumes
docker run -v myvolume:/container/path nginx

# Bind mounts
docker run -v /host/path:/container/path nginx
docker run -v $(pwd):/container/path nginx      # Current directory

# Read-only mount
docker run -v myvolume:/container/path:ro nginx

# tmpfs mount (in-memory, not persisted)
docker run --tmpfs /container/path nginx
```

## Docker Compose

### Install Docker Compose
```bash
# Linux
sudo curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Windows and macOS
# Included with Docker Desktop
```

### Basic docker-compose.yml
```yaml
version: '3'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    restart: always
    environment:
      - NGINX_HOST=example.com
    
  db:
    image: postgres:13
    environment:
      POSTGRES_PASSWORD: example
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Docker Compose commands
```bash
docker-compose up              # Create and start containers
docker-compose up -d           # Detached mode
docker-compose down            # Stop and remove containers
docker-compose down -v         # Also remove volumes
docker-compose ps              # List running services
docker-compose logs            # View logs
docker-compose logs -f         # Follow logs
docker-compose exec SERVICE COMMAND  # Run command in service
docker-compose build           # Build or rebuild services
docker-compose pull            # Pull service images
docker-compose restart         # Restart services
docker-compose start           # Start services
docker-compose stop            # Stop services
docker-compose pause           # Pause services
docker-compose unpause         # Unpause services
docker-compose rm              # Remove stopped containers
docker-compose config          # Validate and view config
docker-compose --profile PROFILE up  # Run specific profile
```

## Docker Swarm

### Initialize Swarm
```bash
docker swarm init --advertise-addr <MANAGER-IP>
```

### Get join tokens
```bash
docker swarm join-token manager    # Get manager join command
docker swarm join-token worker     # Get worker join command
```

### Node management
```bash
docker node ls                     # List nodes
docker node inspect NODE           # Inspect node
docker node promote NODE           # Promote to manager
docker node demote NODE            # Demote to worker
docker node rm NODE                # Remove node
docker node update --availability drain NODE  # Drain node
```

### Service management
```bash
# Create service
docker service create --name web --replicas 3 -p 80:80 nginx

# List services
docker service ls

# Inspect service
docker service inspect web
docker service ps web        # List tasks for service
docker service logs web      # View service logs

# Update service
docker service update --image nginx:alpine web
docker service update --replicas 5 web

# Scale service
docker service scale web=5

# Remove service
docker service rm web
```

### Stack management (Compose for Swarm)
```bash
docker stack deploy -c docker-compose.yml stackname
docker stack ls
docker stack services stackname
docker stack ps stackname
docker stack rm stackname
```

## Dockerfile Reference

```dockerfile
# Base image
FROM ubuntu:20.04

# Set maintainer info (deprecated, use LABEL)
LABEL maintainer="name@example.com"
LABEL version="1.0"

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Set working directory
WORKDIR /app

# Copy files
COPY package.json .
COPY . .

# Run commands
RUN apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add files from URLs
ADD https://example.com/file.tar.gz /tmp/

# Define volume mount points
VOLUME /data

# Expose ports
EXPOSE 3000

# Set user
USER node

# Define entrypoint (cannot be overridden by command line)
ENTRYPOINT ["node"]

# Default command (can be overridden)
CMD ["app.js"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost/ || exit 1

# ARG for build-time variables
ARG VERSION=latest

# ONBUILD trigger for child images
ONBUILD COPY . /app/src

# STOPSIGNAL sets system call signal to send to container
STOPSIGNAL SIGTERM

# Set shell for RUN, CMD, ENTRYPOINT
SHELL ["/bin/bash", "-c"]
```

## Registry & Repository

### Login to registry
```bash
docker login [SERVER]
docker login -u username -p password [SERVER]
```

### Logout from registry
```bash
docker logout [SERVER]
```

### Search for images
```bash
docker search [OPTIONS] TERM
docker search --filter stars=100 nginx
```

### Docker Hub operations
```bash
docker pull username/repo:tag    # Pull image
docker push username/repo:tag    # Push image
```

### Run private registry
```bash
docker run -d -p 5000:5000 --name registry registry:2
```

### Use private registry
```bash
docker tag myimage localhost:5000/myimage
docker push localhost:5000/myimage
docker pull localhost:5000/myimage
```

## System Commands

### System-wide information
```bash
docker system info      # Same as docker info
docker system df        # Show docker disk usage
```

### Cleanup commands
```bash
docker system prune              # Remove all unused containers, networks, images (dangling)
docker system prune -a           # Remove all unused containers, networks, and ALL images
docker system prune -a --volumes # Also remove volumes
```

### Events and monitoring
```bash
docker events                    # Show real-time events from server
docker events --since 1h         # Events from last hour
docker events --filter 'type=container'  # Filter by event type
```

## Best Practices

### Security
- Use specific tags instead of `latest`
- Never run containers as root (use `USER` instruction)
- Scan images for vulnerabilities
- Use secrets management
- Implement least privilege principle
- Keep base images updated

### Image Size
- Use minimal base images (alpine, slim)
- Use multi-stage builds
- Minimize layers (combine RUN commands)
- Clean up in the same layer as installation
- Remove package manager caches
- Add `.dockerignore` file

### Dockerfile
- Start with a well-maintained base image
- Order instructions by frequency of change (least to most)
- Use LABEL for metadata
- Set proper HEALTHCHECK
- Document exposed ports and volumes
- Use ENTRYPOINT for executables, CMD for parameters

### Development Flow
- Use bind mounts for development
- Use named volumes for persistent data
- Use docker-compose for multi-container apps
- Use environment variables for configuration
- Set up proper logging
