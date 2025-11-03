# UFW (Uncomplicated Firewall) Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Enable and Disable](#enable-and-disable)
- [Default Policies](#default-policies)
- [Allow Rules](#allow-rules)
- [Deny Rules](#deny-rules)
- [Delete Rules](#delete-rules)
- [Advanced Rules](#advanced-rules)
- [Port Ranges](#port-ranges)
- [IP Address Rules](#ip-address-rules)
- [Network Interface Rules](#network-interface-rules)
- [Application Profiles](#application-profiles)
- [Logging](#logging)
- [Status and Information](#status-and-information)
- [Reset and Reload](#reset-and-reload)
- [IPv6 Support](#ipv6-support)
- [Common Configurations](#common-configurations)
- [Security Best Practices](#security-best-practices)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Introduction

UFW (Uncomplicated Firewall) is a user-friendly frontend for managing iptables firewall rules on Linux systems. It's designed to make firewall configuration simple and straightforward.

**Key Features:**
- Simple command-line interface
- Easy-to-understand syntax
- Application integration
- IPv6 support
- Logging capabilities
- Default deny policy

## Installation

### Ubuntu/Debian
```bash
# UFW is usually pre-installed on Ubuntu
# If not installed:
sudo apt update
sudo apt install ufw

# Verify installation
ufw version
```

### CentOS/RHEL/Fedora
```bash
# Install UFW
sudo yum install epel-release
sudo yum install ufw

# Or with dnf
sudo dnf install ufw

# Enable and start UFW service
sudo systemctl enable ufw
sudo systemctl start ufw
```

### Arch Linux
```bash
# Install UFW
sudo pacman -S ufw

# Enable and start service
sudo systemctl enable ufw
sudo systemctl start ufw
```

## Basic Commands

### Check Status
```bash
# Check if UFW is active
sudo ufw status

# Verbose status with rule numbers
sudo ufw status verbose

# Numbered status (useful for deleting rules)
sudo ufw status numbered
```

### Enable UFW
```bash
# Enable firewall
sudo ufw enable

# Enable with confirmation bypass
yes | sudo ufw enable
```

### Disable UFW
```bash
# Disable firewall
sudo ufw disable
```

### Reload UFW
```bash
# Reload firewall rules
sudo ufw reload
```

## Enable and Disable

### Enable UFW
```bash
# Enable firewall (will start on boot)
sudo ufw enable

# Enable and set to start on boot
sudo ufw enable
sudo systemctl enable ufw
```

### Disable UFW
```bash
# Disable firewall temporarily
sudo ufw disable

# Disable on boot
sudo systemctl disable ufw
```

### Check if Enabled
```bash
# Check status
sudo ufw status

# Output: Status: active or Status: inactive
```

## Default Policies

### Set Default Policies
```bash
# Default: deny all incoming, allow all outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Deny all incoming and outgoing (restrictive)
sudo ufw default deny incoming
sudo ufw default deny outgoing

# Allow all incoming and outgoing (not recommended)
sudo ufw default allow incoming
sudo ufw default allow outgoing
```

### Reject vs Deny
```bash
# Deny: silently drop packets (default)
sudo ufw default deny incoming

# Reject: send rejection response
sudo ufw default reject incoming
```

## Allow Rules

### Allow by Port
```bash
# Allow specific port
sudo ufw allow 22              # SSH
sudo ufw allow 80              # HTTP
sudo ufw allow 443             # HTTPS

# Allow port with protocol
sudo ufw allow 22/tcp
sudo ufw allow 53/udp
sudo ufw allow 8080/tcp
```

### Allow by Service Name
```bash
# Allow common services
sudo ufw allow ssh             # Port 22
sudo ufw allow http            # Port 80
sudo ufw allow https           # Port 443
sudo ufw allow ftp             # Port 21
sudo ufw allow smtp            # Port 25
sudo ufw allow dns             # Port 53
sudo ufw allow ntp             # Port 123
```

### Allow from Specific IP
```bash
# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Allow from IP to specific port
sudo ufw allow from 192.168.1.100 to any port 22

# Allow from IP to specific port with protocol
sudo ufw allow from 192.168.1.100 to any port 22 proto tcp
```

### Allow from Subnet
```bash
# Allow from subnet
sudo ufw allow from 192.168.1.0/24

# Allow from subnet to specific port
sudo ufw allow from 192.168.1.0/24 to any port 3306

# Allow from subnet to specific port with protocol
sudo ufw allow from 10.0.0.0/8 to any port 5432 proto tcp
```

## Deny Rules

### Deny by Port
```bash
# Deny specific port
sudo ufw deny 23               # Telnet
sudo ufw deny 3389             # RDP

# Deny port with protocol
sudo ufw deny 23/tcp
sudo ufw deny 161/udp
```

### Deny from Specific IP
```bash
# Deny from specific IP
sudo ufw deny from 192.168.1.100

# Deny from IP to specific port
sudo ufw deny from 192.168.1.100 to any port 22

# Deny from IP with comment
sudo ufw deny from 203.0.113.100 comment 'Blocked malicious IP'
```

### Deny from Subnet
```bash
# Deny from subnet
sudo ufw deny from 10.0.0.0/8

# Deny from subnet to specific port
sudo ufw deny from 172.16.0.0/12 to any port 22
```

### Reject Rules
```bash
# Reject instead of deny (sends rejection response)
sudo ufw reject from 192.168.1.100
sudo ufw reject 23/tcp
sudo ufw reject out 25/tcp
```

## Delete Rules

### Delete by Rule Specification
```bash
# Delete by repeating the rule with 'delete'
sudo ufw delete allow 80
sudo ufw delete allow from 192.168.1.100
sudo ufw delete deny 23/tcp
```

### Delete by Rule Number
```bash
# Show numbered rules
sudo ufw status numbered

# Delete by number
sudo ufw delete 3

# Delete with confirmation bypass
yes | sudo ufw delete 3
```

### Delete All Rules
```bash
# Reset UFW (deletes all rules)
sudo ufw reset
```

## Advanced Rules

### Allow Output
```bash
# Allow outgoing traffic on specific port
sudo ufw allow out 53/udp      # DNS
sudo ufw allow out 123/udp     # NTP
sudo ufw allow out 443/tcp     # HTTPS
```

### Deny Output
```bash
# Deny outgoing traffic on specific port
sudo ufw deny out 25/tcp       # Block outgoing SMTP
sudo ufw deny out 23/tcp       # Block Telnet
```

### Limit Connections (Rate Limiting)
```bash
# Limit connections (protection against brute force)
sudo ufw limit ssh
sudo ufw limit 22/tcp

# Denies connections if IP attempts 6+ connections in 30 seconds
```

### Insert Rules at Specific Position
```bash
# Insert rule at position 1
sudo ufw insert 1 allow from 192.168.1.100

# Insert rule before specific rule number
sudo ufw insert 2 deny from 203.0.113.100
```

### Rules with Comments
```bash
# Add rule with comment
sudo ufw allow from 192.168.1.100 comment 'Office IP'
sudo ufw allow 8080/tcp comment 'Dev server'
sudo ufw deny from 203.0.113.0/24 comment 'Blocked subnet'
```

## Port Ranges

### Allow Port Ranges
```bash
# Allow range of ports
sudo ufw allow 1000:2000/tcp
sudo ufw allow 1000:2000/udp

# Allow from IP to port range
sudo ufw allow from 192.168.1.100 to any port 1000:2000 proto tcp
```

### Deny Port Ranges
```bash
# Deny range of ports
sudo ufw deny 1000:2000/tcp
sudo ufw deny 1000:2000/udp
```

## IP Address Rules

### Specific IP Address
```bash
# Allow from specific IP
sudo ufw allow from 192.168.1.100
sudo ufw allow from 203.0.113.50 to any port 22

# Deny from specific IP
sudo ufw deny from 203.0.113.100
```

### IP Address Range (CIDR)
```bash
# Allow from subnet
sudo ufw allow from 192.168.1.0/24
sudo ufw allow from 10.0.0.0/8
sudo ufw allow from 172.16.0.0/12

# Deny from subnet
sudo ufw deny from 192.168.100.0/24
```

### Allow Between Specific IPs
```bash
# Allow from source to destination
sudo ufw allow from 192.168.1.100 to 192.168.1.200

# Allow from source to destination on specific port
sudo ufw allow from 192.168.1.100 to 192.168.1.200 port 3306
```

### IPv6 Addresses
```bash
# Allow from IPv6 address
sudo ufw allow from 2001:db8::1

# Allow from IPv6 subnet
sudo ufw allow from 2001:db8::/32

# Allow IPv6 to specific port
sudo ufw allow from 2001:db8::1 to any port 80
```

## Network Interface Rules

### Interface-Specific Rules
```bash
# Allow on specific interface
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on eth1 to any port 3306

# Allow from IP on specific interface
sudo ufw allow in on eth0 from 192.168.1.0/24

# Deny on specific interface
sudo ufw deny in on eth0 from 203.0.113.0/24
```

### Multiple Interfaces
```bash
# Allow SSH on external interface only
sudo ufw allow in on eth0 to any port 22

# Allow MySQL on internal interface only
sudo ufw allow in on eth1 to any port 3306

# Allow HTTP/HTTPS on external interface
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on eth0 to any port 443
```

## Application Profiles

### List Available Profiles
```bash
# List all application profiles
sudo ufw app list

# Show profile information
sudo ufw app info 'Nginx Full'
sudo ufw app info OpenSSH
```

### Allow Application Profile
```bash
# Allow application by profile name
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw allow Samba

# Allow with quotes (if name has spaces)
sudo ufw allow 'Nginx HTTP'
```

### Common Application Profiles
```bash
# OpenSSH
sudo ufw allow OpenSSH

# Nginx profiles
sudo ufw allow 'Nginx Full'    # HTTP + HTTPS
sudo ufw allow 'Nginx HTTP'    # HTTP only
sudo ufw allow 'Nginx HTTPS'   # HTTPS only

# Apache profiles
sudo ufw allow 'Apache Full'   # HTTP + HTTPS
sudo ufw allow 'Apache'        # HTTP only
sudo ufw allow 'Apache Secure' # HTTPS only

# Other services
sudo ufw allow Samba
sudo ufw allow CUPS
```

### Create Custom Application Profile
```bash
# Create profile file
sudo nano /etc/ufw/applications.d/myapp

# Example content:
# [MyApp]
# title=My Application
# description=Custom application
# ports=8000/tcp|8443/tcp

# Reload profiles
sudo ufw app update MyApp

# Allow the application
sudo ufw allow MyApp
```

## Logging

### Enable Logging
```bash
# Enable logging (default level: low)
sudo ufw logging on

# Set logging level
sudo ufw logging low        # Low level
sudo ufw logging medium     # Medium level
sudo ufw logging high       # High level (very verbose)
sudo ufw logging full       # Full logging
```

### Disable Logging
```bash
# Disable logging
sudo ufw logging off
```

### View Logs
```bash
# View UFW logs
sudo tail -f /var/log/ufw.log

# View with journalctl
sudo journalctl -f -u ufw

# Search for specific IP in logs
sudo grep "192.168.1.100" /var/log/ufw.log

# View blocked packets
sudo grep "\[UFW BLOCK\]" /var/log/ufw.log
```

### Log Levels Explained
```bash
# off: No logging
# low: Logs blocked packets not matching default policy
# medium: Logs blocked packets, invalid packets, and new connections
# high: Logs all packets
# full: Same as high but with rate limiting disabled
```

## Status and Information

### Basic Status
```bash
# Check status
sudo ufw status

# Verbose status
sudo ufw status verbose

# Numbered status
sudo ufw status numbered
```

### Show Detailed Information
```bash
# Show all rules with details
sudo ufw show raw

# Show listening ports
sudo ufw show listening

# Show added rules
sudo ufw show added

# Show iptables rules
sudo ufw show user-rules
```

### Check Version
```bash
# Show UFW version
sudo ufw version
```

## Reset and Reload

### Reset UFW
```bash
# Reset to default state (removes all rules)
sudo ufw reset

# Reset with confirmation bypass
yes | sudo ufw reset
```

### Reload Rules
```bash
# Reload firewall rules
sudo ufw reload

# Disable and re-enable (full restart)
sudo ufw disable
sudo ufw enable
```

## IPv6 Support

### Enable IPv6
```bash
# Edit UFW configuration
sudo nano /etc/default/ufw

# Set IPV6=yes
IPV6=yes

# Reload UFW
sudo ufw reload
```

### IPv6 Rules
```bash
# Allow IPv6 address
sudo ufw allow from 2001:db8::1

# Allow IPv6 subnet
sudo ufw allow from 2001:db8::/32

# Allow IPv6 to specific port
sudo ufw allow from 2001:db8::1 to any port 80 proto tcp

# Deny IPv6 address
sudo ufw deny from 2001:db8::100
```

## Common Configurations

### Web Server
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (change port if not default)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Or use Nginx profile
sudo ufw allow 'Nginx Full'

# Enable firewall
sudo ufw enable
```

### Database Server
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH from specific IP
sudo ufw allow from 192.168.1.100 to any port 22

# Allow MySQL from application servers
sudo ufw allow from 192.168.1.0/24 to any port 3306

# Or PostgreSQL
sudo ufw allow from 192.168.1.0/24 to any port 5432

# Enable firewall
sudo ufw enable
```

### SSH Server with Rate Limiting
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Limit SSH connections (brute force protection)
sudo ufw limit 22/tcp

# Or allow SSH from specific subnet only
sudo ufw allow from 192.168.1.0/24 to any port 22

# Enable firewall
sudo ufw enable
```

### Development Server
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Allow common development ports
sudo ufw allow 3000/tcp        # Node.js/React dev server
sudo ufw allow 8000/tcp        # Python/Django dev server
sudo ufw allow 8080/tcp        # Alternative HTTP
sudo ufw allow 5432/tcp        # PostgreSQL
sudo ufw allow 3306/tcp        # MySQL

# Enable firewall
sudo ufw enable
```

### VPN Server
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# OpenVPN
sudo ufw allow 1194/udp

# WireGuard
sudo ufw allow 51820/udp

# Allow forwarding (for VPN)
# Edit /etc/default/ufw
# DEFAULT_FORWARD_POLICY="ACCEPT"

# Enable firewall
sudo ufw enable
```

### Docker Host
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Allow Docker ports
sudo ufw allow 2375/tcp        # Docker API (if needed)
sudo ufw allow 2376/tcp        # Docker API TLS

# Allow specific container ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable

# Note: Docker may bypass UFW rules
# Add to /etc/ufw/after.rules for Docker compatibility
```

### Kubernetes Node
```bash
# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH
sudo ufw allow 22/tcp

# Kubernetes API server
sudo ufw allow 6443/tcp

# etcd
sudo ufw allow 2379:2380/tcp

# Kubelet API
sudo ufw allow 10250/tcp

# NodePort Services
sudo ufw allow 30000:32767/tcp

# Enable firewall
sudo ufw enable
```

## Security Best Practices

### Principle of Least Privilege
```bash
# Start with deny all
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Only allow necessary services
sudo ufw allow 22/tcp          # SSH
sudo ufw allow 80/tcp          # HTTP
sudo ufw allow 443/tcp         # HTTPS
```

### Use Rate Limiting for SSH
```bash
# Protect against brute force attacks
sudo ufw limit 22/tcp

# Or allow SSH from specific IPs only
sudo ufw allow from 192.168.1.0/24 to any port 22
```

### Block by Default
```bash
# Set restrictive default policies
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw default deny routed

# Then explicitly allow what's needed
sudo ufw allow out 53/udp      # DNS
sudo ufw allow out 80/tcp      # HTTP
sudo ufw allow out 443/tcp     # HTTPS
```

### Use Specific IP Ranges
```bash
# Restrict services to specific networks
sudo ufw allow from 192.168.1.0/24 to any port 22
sudo ufw allow from 10.0.0.0/8 to any port 3306

# Deny all others implicitly
```

### Enable Logging
```bash
# Enable logging for monitoring
sudo ufw logging medium

# Review logs regularly
sudo tail -f /var/log/ufw.log
```

### Regular Audits
```bash
# Review rules regularly
sudo ufw status numbered

# Remove unnecessary rules
sudo ufw delete <rule-number>
```

### Backup Rules
```bash
# Backup UFW rules
sudo cp /etc/ufw/user.rules /etc/ufw/user.rules.backup
sudo cp /etc/ufw/user6.rules /etc/ufw/user6.rules.backup

# Or backup entire UFW directory
sudo tar -czf ufw-backup.tar.gz /etc/ufw/
```

## Troubleshooting

### Can't Connect After Enabling UFW
```bash
# Disable UFW temporarily
sudo ufw disable

# Check if you can connect now
# If yes, you need to add appropriate allow rule

# Add SSH rule before enabling
sudo ufw allow 22/tcp

# Or limit SSH
sudo ufw limit 22/tcp

# Re-enable
sudo ufw enable
```

### Check if Rule is Working
```bash
# View numbered rules
sudo ufw status numbered

# Check logs
sudo tail -f /var/log/ufw.log

# Test connection from another machine
# Watch logs while testing
```

### UFW Not Starting
```bash
# Check UFW service status
sudo systemctl status ufw

# Start UFW service
sudo systemctl start ufw

# Enable on boot
sudo systemctl enable ufw

# Check for errors
sudo journalctl -u ufw -n 50
```

### Reset to Default
```bash
# Reset all rules
sudo ufw reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Add basic rules
sudo ufw allow 22/tcp

# Enable
sudo ufw enable
```

### Check Current iptables Rules
```bash
# View raw iptables rules
sudo iptables -L -n -v

# View UFW-specific rules
sudo iptables -L ufw-user-input -n -v

# View NAT rules
sudo iptables -t nat -L -n -v
```

### Port Already Allowed
```bash
# If you get "Rule added" but rule already exists
# Delete and re-add
sudo ufw delete allow 80
sudo ufw allow 80
```

### Docker Bypassing UFW
```bash
# Docker can bypass UFW rules
# Add to /etc/ufw/after.rules:

# BEGIN UFW AND DOCKER
*filter
:ufw-user-forward - [0:0]
:DOCKER-USER - [0:0]
-A DOCKER-USER -j ufw-user-forward
-A DOCKER-USER -j RETURN
COMMIT
# END UFW AND DOCKER

# Reload UFW
sudo ufw reload
```

### Check Rule Syntax
```bash
# Test rule before adding
sudo ufw --dry-run allow 80

# Verbose output
sudo ufw --verbose allow from 192.168.1.100
```

### View Specific Rule Details
```bash
# Show numbered rules
sudo ufw status numbered

# Get details about rule 3
sudo ufw status numbered | grep "^\[ 3\]"
```

## References

- [UFW Official Documentation](https://help.ubuntu.com/community/UFW)
- [UFW Man Page](https://manpages.ubuntu.com/manpages/focal/man8/ufw.8.html)
- [Ubuntu UFW Guide](https://ubuntu.com/server/docs/security-firewall)
- [DigitalOcean UFW Tutorial](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)
- [Arch Linux UFW Wiki](https://wiki.archlinux.org/title/Uncomplicated_Firewall)
