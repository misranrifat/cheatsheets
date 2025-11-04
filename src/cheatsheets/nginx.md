# Nginx Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Configuration Structure](#configuration-structure)
- [Core Directives](#core-directives)
- [Server Blocks (Virtual Hosts)](#server-blocks-virtual-hosts)
- [Location Blocks](#location-blocks)
- [Reverse Proxy](#reverse-proxy)
- [Load Balancing](#load-balancing)
- [SSL/TLS Configuration](#ssltls-configuration)
- [Caching](#caching)
- [Compression](#compression)
- [Security](#security)
- [Logging](#logging)
- [Redirects and Rewrites](#redirects-and-rewrites)
- [Rate Limiting](#rate-limiting)
- [WebSocket Support](#websocket-support)
- [HTTP/2 Configuration](#http2-configuration)
- [Performance Tuning](#performance-tuning)
- [Common Configurations](#common-configurations)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [References](#references)

## Introduction

Nginx is a high-performance web server, reverse proxy, and load balancer. It's known for its stability, rich feature set, simple configuration, and low resource consumption.

**Key Features:**
- Web server and reverse proxy
- Load balancing
- HTTP caching
- SSL/TLS termination
- WebSocket support
- HTTP/2 and HTTP/3 support

## Installation

### Ubuntu/Debian
```bash
# Update package index
sudo apt update

# Install Nginx
sudo apt install nginx

# Install from official repository (latest stable)
sudo add-apt-repository ppa:nginx/stable
sudo apt update
sudo apt install nginx

# Verify installation
nginx -v
```

### CentOS/RHEL
```bash
# Install Nginx
sudo yum install epel-release
sudo yum install nginx

# Or from official repository
sudo yum install yum-utils
sudo yum-config-manager --add-repo https://nginx.org/packages/centos/nginx.repo
sudo yum install nginx

# Verify installation
nginx -v
```

### macOS
```bash
# Using Homebrew
brew install nginx

# Verify installation
nginx -v
```

### Docker
```bash
# Run Nginx container
docker run -d -p 80:80 --name nginx nginx:latest

# Run with custom config
docker run -d -p 80:80 \
  -v /path/to/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v /path/to/html:/usr/share/nginx/html:ro \
  nginx:latest
```

### From Source
```bash
# Install dependencies
sudo apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

# Download and extract
wget http://nginx.org/download/nginx-1.24.0.tar.gz
tar -xzf nginx-1.24.0.tar.gz
cd nginx-1.24.0

# Configure and compile
./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx \
  --with-http_ssl_module --with-http_v2_module
make
sudo make install
```

## Basic Commands

### Service Management
```bash
# Start Nginx
sudo systemctl start nginx
sudo service nginx start
nginx                           # Direct command

# Stop Nginx
sudo systemctl stop nginx
sudo service nginx stop
nginx -s stop                   # Fast shutdown
nginx -s quit                   # Graceful shutdown

# Restart Nginx
sudo systemctl restart nginx
sudo service nginx restart

# Reload configuration (no downtime)
sudo systemctl reload nginx
sudo service nginx reload
nginx -s reload

# Check status
sudo systemctl status nginx
sudo service nginx status

# Enable on boot
sudo systemctl enable nginx

# Disable on boot
sudo systemctl disable nginx
```

### Configuration Testing
```bash
# Test configuration syntax
nginx -t
sudo nginx -t

# Test and display configuration
nginx -T

# Check configuration file path
nginx -V 2>&1 | grep -o '\-\-conf-path=\S*'
```

### Process Management
```bash
# View Nginx processes
ps aux | grep nginx

# Graceful shutdown
nginx -s quit

# Fast shutdown
nginx -s stop

# Reopen log files (for log rotation)
nginx -s reopen
```

## Configuration Structure

### Main Configuration File
```nginx
# /etc/nginx/nginx.conf

user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;

    # Basic settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # Include server blocks
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

### Directory Structure
```
/etc/nginx/
├── nginx.conf                   # Main configuration
├── conf.d/                      # Additional configurations
│   └── default.conf
├── sites-available/             # Available site configurations
│   ├── default
│   └── example.com
├── sites-enabled/               # Enabled sites (symlinks)
│   └── default -> ../sites-available/default
├── snippets/                    # Reusable configuration snippets
│   ├── ssl-params.conf
│   └── proxy-params.conf
└── modules-enabled/             # Enabled modules

/var/log/nginx/
├── access.log                   # Access logs
└── error.log                    # Error logs

/usr/share/nginx/html/           # Default web root
└── index.html
```

### Configuration Context Hierarchy
```nginx
# Main context
user nginx;
worker_processes auto;

# Events context
events {
    worker_connections 1024;
}

# HTTP context
http {
    # HTTP-level directives

    # Server context
    server {
        listen 80;
        server_name example.com;

        # Location context
        location / {
            root /var/www/html;
        }

        location /api {
            proxy_pass http://backend;
        }
    }

    # Upstream context
    upstream backend {
        server 127.0.0.1:8000;
        server 127.0.0.1:8001;
    }
}
```

## Core Directives

### Worker Processes
```nginx
# Auto-detect CPU cores
worker_processes auto;

# Specific number
worker_processes 4;

# Worker connections
events {
    worker_connections 1024;      # Max connections per worker
    multi_accept on;              # Accept multiple connections
    use epoll;                    # Efficient connection processing method (Linux)
}
```

### User and Group
```nginx
# Run as specific user
user www-data;
user nginx nginx;

# Run as same user as config file owner
user $USER;
```

### Include Files
```nginx
# Include MIME types
include /etc/nginx/mime.types;

# Include all .conf files
include /etc/nginx/conf.d/*.conf;

# Include specific file
include /etc/nginx/snippets/ssl-params.conf;
```

### Default Type
```nginx
# Default MIME type for unknown file types
default_type application/octet-stream;
default_type text/html;
```

## Server Blocks (Virtual Hosts)

### Basic Server Block
```nginx
server {
    listen 80;
    listen [::]:80;               # IPv6
    server_name example.com www.example.com;
    root /var/www/example.com;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

### Multiple Server Blocks
```nginx
# Site 1
server {
    listen 80;
    server_name site1.com www.site1.com;
    root /var/www/site1;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Site 2
server {
    listen 80;
    server_name site2.com www.site2.com;
    root /var/www/site2;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Default catch-all server
server {
    listen 80 default_server;
    server_name _;
    return 444;                   # Close connection without response
}
```

### Server Name Wildcards
```nginx
# Exact match
server_name example.com;

# Wildcard at start
server_name *.example.com;

# Wildcard at end
server_name example.*;

# Regular expression
server_name ~^(?<subdomain>.+)\.example\.com$;

# Multiple names
server_name example.com www.example.com blog.example.com;
```

### Listen Directive
```nginx
# Basic
listen 80;

# Specific IP
listen 192.168.1.1:80;

# IPv6
listen [::]:80;

# Default server
listen 80 default_server;

# SSL
listen 443 ssl;
listen 443 ssl http2;

# Unix socket
listen unix:/var/run/nginx.sock;
```

## Location Blocks

### Location Matching
```nginx
server {
    listen 80;
    server_name example.com;

    # Exact match (highest priority)
    location = /exact {
        return 200 "Exact match";
    }

    # Preferential prefix match
    location ^~ /images/ {
        root /var/www;
    }

    # Case-sensitive regex
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
    }

    # Case-insensitive regex
    location ~* \.(jpg|jpeg|png|gif)$ {
        expires 30d;
    }

    # Prefix match (lowest priority)
    location / {
        root /var/www/html;
    }
}
```

### Location Priority
```nginx
# Priority order (highest to lowest):
# 1. = (exact match)
# 2. ^~ (preferential prefix)
# 3. ~ or ~* (regex)
# 4. None (prefix match)

server {
    location = / {
        # Matches exactly /
    }

    location ^~ /images/ {
        # Matches /images/* with priority over regex
    }

    location ~ \.(gif|jpg|png)$ {
        # Matches files ending in .gif, .jpg, or .png
    }

    location / {
        # Matches everything else
    }
}
```

### Try Files
```nginx
# Try files in order, return 404 if none exist
location / {
    try_files $uri $uri/ =404;
}

# Try files, fallback to index.php
location / {
    try_files $uri $uri/ /index.php?$query_string;
}

# Single Page Application
location / {
    try_files $uri $uri/ /index.html;
}

# Multiple fallbacks
location / {
    try_files $uri $uri/ @proxy;
}

location @proxy {
    proxy_pass http://backend;
}
```

## Reverse Proxy

### Basic Proxy
```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8000;
    }
}
```

### Proxy with Headers
```nginx
location / {
    proxy_pass http://backend;

    # Preserve original request information
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Port $server_port;

    # Connection settings
    proxy_http_version 1.1;
    proxy_set_header Connection "";
}
```

### Proxy Timeouts
```nginx
location / {
    proxy_pass http://backend;

    proxy_connect_timeout 60s;
    proxy_send_timeout 60s;
    proxy_read_timeout 60s;
}
```

### Proxy Buffering
```nginx
location / {
    proxy_pass http://backend;

    # Buffer settings
    proxy_buffering on;
    proxy_buffer_size 4k;
    proxy_buffers 8 4k;
    proxy_busy_buffers_size 8k;

    # Disable buffering for streaming
    # proxy_buffering off;
}
```

### Proxy with URL Rewriting
```nginx
# Remove /api prefix
location /api/ {
    proxy_pass http://backend/;   # Trailing slash removes /api
}

# Keep /api prefix
location /api/ {
    proxy_pass http://backend;    # No trailing slash keeps /api
}

# Rewrite path
location /old-api/ {
    rewrite ^/old-api/(.*)$ /new-api/$1 break;
    proxy_pass http://backend;
}
```

## Load Balancing

### Basic Load Balancing
```nginx
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

### Load Balancing Methods
```nginx
# Round Robin (default)
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
}

# Least Connections
upstream backend {
    least_conn;
    server backend1.example.com;
    server backend2.example.com;
}

# IP Hash (session persistence)
upstream backend {
    ip_hash;
    server backend1.example.com;
    server backend2.example.com;
}

# Hash (generic)
upstream backend {
    hash $request_uri consistent;
    server backend1.example.com;
    server backend2.example.com;
}

# Random
upstream backend {
    random;
    server backend1.example.com;
    server backend2.example.com;
}
```

### Server Weights
```nginx
upstream backend {
    server backend1.example.com weight=3;  # 3x traffic
    server backend2.example.com weight=2;  # 2x traffic
    server backend3.example.com weight=1;  # 1x traffic
}
```

### Health Checks
```nginx
upstream backend {
    server backend1.example.com max_fails=3 fail_timeout=30s;
    server backend2.example.com max_fails=3 fail_timeout=30s;
    server backup.example.com backup;      # Backup server
}
```

### Server States
```nginx
upstream backend {
    server backend1.example.com;
    server backend2.example.com down;      # Temporarily disabled
    server backend3.example.com backup;    # Backup server
    server backend4.example.com max_fails=3 fail_timeout=30s;
}
```

## SSL/TLS Configuration

### Basic SSL
```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    location / {
        root /var/www/html;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.com;
    return 301 https://$server_name$request_uri;
}
```

### Let's Encrypt SSL
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # Let's Encrypt verification
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        root /var/www/html;
    }
}
```

### SSL Best Practices
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    # Certificates
    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    # SSL protocols
    ssl_protocols TLSv1.2 TLSv1.3;

    # Strong ciphers
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers off;

    # SSL session cache
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    ssl_trusted_certificate /etc/ssl/certs/ca-bundle.crt;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

### SSL Snippets (Reusable)
```nginx
# /etc/nginx/snippets/ssl-params.conf
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;

# Use in server block
server {
    listen 443 ssl http2;
    include snippets/ssl-params.conf;
    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;
}
```

## Caching

### Proxy Cache
```nginx
# Define cache path
http {
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m
                     max_size=1g inactive=60m use_temp_path=off;
}

server {
    location / {
        proxy_cache my_cache;
        proxy_cache_valid 200 60m;
        proxy_cache_valid 404 10m;
        proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
        proxy_cache_bypass $http_cache_control;
        add_header X-Cache-Status $upstream_cache_status;

        proxy_pass http://backend;
    }
}
```

### FastCGI Cache
```nginx
http {
    fastcgi_cache_path /var/cache/nginx levels=1:2 keys_zone=php_cache:10m
                       max_size=1g inactive=60m;
}

server {
    location ~ \.php$ {
        fastcgi_cache php_cache;
        fastcgi_cache_valid 200 60m;
        fastcgi_cache_key "$scheme$request_method$host$request_uri";
        add_header X-Cache-Status $upstream_cache_status;

        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        include fastcgi_params;
    }
}
```

### Browser Cache
```nginx
# Cache static files
location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}

# Don't cache HTML
location ~* \.html$ {
    expires -1;
    add_header Cache-Control "no-store, no-cache, must-revalidate, proxy-revalidate";
}
```

### Cache Purging
```nginx
# Manual cache clear
# rm -rf /var/cache/nginx/*

# Conditional caching
location / {
    proxy_cache my_cache;
    proxy_cache_bypass $cookie_nocache $arg_nocache;
    proxy_no_cache $cookie_nocache $arg_nocache;
}
```

## Compression

### Gzip Compression
```nginx
http {
    # Enable gzip
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript
               application/json application/javascript application/xml+rss
               application/rss+xml font/truetype font/opentype
               application/vnd.ms-fontobject image/svg+xml;
    gzip_disable "msie6";
    gzip_min_length 256;
}
```

### Brotli Compression
```nginx
# Requires ngx_brotli module
http {
    brotli on;
    brotli_comp_level 6;
    brotli_types text/plain text/css text/xml text/javascript
                 application/json application/javascript application/xml+rss;
}
```

## Security

### Security Headers
```nginx
server {
    # Prevent clickjacking
    add_header X-Frame-Options "SAMEORIGIN" always;

    # Prevent MIME type sniffing
    add_header X-Content-Type-Options "nosniff" always;

    # Enable XSS protection
    add_header X-XSS-Protection "1; mode=block" always;

    # Referrer policy
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Content Security Policy
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';" always;

    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

### Deny Access
```nginx
# Deny specific files
location ~ /\. {
    deny all;                     # Deny hidden files
}

location ~* \.(sql|log|bak)$ {
    deny all;                     # Deny sensitive file types
}

# Deny specific locations
location /admin {
    deny all;
}

# Allow specific IPs
location /admin {
    allow 192.168.1.0/24;
    deny all;
}
```

### Basic Authentication
```nginx
# Create password file
# htpasswd -c /etc/nginx/.htpasswd username

location /admin {
    auth_basic "Restricted Area";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
```

### Limit Request Methods
```nginx
# Allow only GET, POST, HEAD
if ($request_method !~ ^(GET|POST|HEAD)$ ) {
    return 405;
}
```

### Prevent Hotlinking
```nginx
location ~ \.(jpg|jpeg|png|gif)$ {
    valid_referers none blocked example.com *.example.com;
    if ($invalid_referer) {
        return 403;
    }
}
```

## Logging

### Access Log
```nginx
# Default access log
access_log /var/log/nginx/access.log;

# Custom log format
log_format custom '$remote_addr - $remote_user [$time_local] '
                  '"$request" $status $body_bytes_sent '
                  '"$http_referer" "$http_user_agent"';

access_log /var/log/nginx/access.log custom;

# Disable logging for specific location
location /health {
    access_log off;
}

# Conditional logging
map $status $loggable {
    ~^[23] 0;                     # Don't log 2xx and 3xx
    default 1;
}
access_log /var/log/nginx/access.log combined if=$loggable;
```

### Error Log
```nginx
# Error log levels: debug, info, notice, warn, error, crit, alert, emerg
error_log /var/log/nginx/error.log warn;

# Per-server error log
server {
    error_log /var/log/nginx/example.com-error.log;
}

# Disable error logging
error_log /dev/null crit;
```

### Log Rotation
```nginx
# /etc/logrotate.d/nginx
/var/log/nginx/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        if [ -f /var/run/nginx.pid ]; then
            kill -USR1 `cat /var/run/nginx.pid`
        fi
    endscript
}
```

## Redirects and Rewrites

### Permanent Redirect (301)
```nginx
# Simple redirect
server {
    listen 80;
    server_name old-domain.com;
    return 301 https://new-domain.com$request_uri;
}

# Redirect www to non-www
server {
    listen 80;
    server_name www.example.com;
    return 301 http://example.com$request_uri;
}

# Redirect to HTTPS
server {
    listen 80;
    server_name example.com;
    return 301 https://$server_name$request_uri;
}
```

### Temporary Redirect (302)
```nginx
location /old-page {
    return 302 /new-page;
}
```

### Rewrite Rules
```nginx
# Basic rewrite
rewrite ^/old-url$ /new-url permanent;
rewrite ^/old-url$ /new-url redirect;

# Capture groups
rewrite ^/blog/(.*)$ /posts/$1 permanent;

# Multiple rewrites
location / {
    rewrite ^/products/(.*)$ /items/$1 permanent;
    rewrite ^/about-us$ /about permanent;
}

# Conditional rewrite
if ($request_uri ~* "^/old-path/(.*)") {
    rewrite ^/old-path/(.*)$ /new-path/$1 permanent;
}

# Last flag (stop processing)
rewrite ^/test$ /index.html last;

# Break flag (stop rewriting)
rewrite ^/download/(.*)$ /files/$1 break;
```

### Location-Based Redirects
```nginx
location = /old-page {
    return 301 /new-page;
}

location /blog {
    return 301 https://blog.example.com$request_uri;
}
```

## Rate Limiting

### Limit Request Rate
```nginx
# Define rate limit zone
http {
    limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;
}

server {
    location /api/ {
        limit_req zone=mylimit burst=20 nodelay;
        proxy_pass http://backend;
    }
}
```

### Limit Connection
```nginx
# Limit concurrent connections
http {
    limit_conn_zone $binary_remote_addr zone=conn_limit:10m;
}

server {
    location /download/ {
        limit_conn conn_limit 10;     # Max 10 connections per IP
        limit_rate 500k;               # Limit bandwidth to 500KB/s
    }
}
```

### Custom Rate Limiting
```nginx
http {
    # Different limits for different endpoints
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
    limit_req_zone $binary_remote_addr zone=api:10m rate=100r/s;

    server {
        location /login {
            limit_req zone=login burst=3;
        }

        location /api {
            limit_req zone=api burst=50 nodelay;
        }
    }
}
```

## WebSocket Support

### Basic WebSocket Proxy
```nginx
server {
    listen 80;
    server_name example.com;

    location /ws {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket timeout
        proxy_read_timeout 86400;
    }
}
```

### WebSocket with SSL
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    location /ws {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }
}
```

## HTTP/2 Configuration

### Enable HTTP/2
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/ssl/certs/example.com.crt;
    ssl_certificate_key /etc/ssl/private/example.com.key;

    location / {
        root /var/www/html;
    }
}
```

### HTTP/2 Server Push
```nginx
server {
    listen 443 ssl http2;
    server_name example.com;

    location / {
        root /var/www/html;
        # Push resources
        http2_push /css/style.css;
        http2_push /js/app.js;
    }
}
```

## Performance Tuning

### Worker Configuration
```nginx
worker_processes auto;
worker_cpu_affinity auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 4096;
    multi_accept on;
    use epoll;
}
```

### Buffer Sizes
```nginx
http {
    client_body_buffer_size 128k;
    client_max_body_size 20m;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 8k;

    output_buffers 1 32k;
    postpone_output 1460;
}
```

### Timeouts
```nginx
http {
    client_body_timeout 12;
    client_header_timeout 12;
    keepalive_timeout 65;
    send_timeout 10;
}
```

### Sendfile and TCP
```nginx
http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_requests 100;
}
```

### Open File Cache
```nginx
http {
    open_file_cache max=10000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;
}
```

## Common Configurations

### Static Website
```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

### PHP with PHP-FPM
```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

### Node.js Application
```nginx
upstream nodejs {
    server 127.0.0.1:3000;
    keepalive 64;
}

server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://nodejs;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Django Application
```nginx
upstream django {
    server unix:/run/gunicorn.sock;
}

server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://django;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        alias /var/www/django/static/;
        expires 30d;
    }

    location /media/ {
        alias /var/www/django/media/;
    }
}
```

### Single Page Application (SPA)
```nginx
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Troubleshooting

### Check Configuration
```bash
# Test configuration
sudo nginx -t

# Test and show full configuration
sudo nginx -T

# Check syntax of specific file
sudo nginx -t -c /etc/nginx/sites-available/example.com
```

### Debug Logging
```nginx
error_log /var/log/nginx/error.log debug;
```

### Check Listening Ports
```bash
# Check if Nginx is listening
sudo netstat -tlnp | grep nginx
sudo ss -tlnp | grep nginx

# Check port 80 and 443
sudo lsof -i :80
sudo lsof -i :443
```

### View Logs
```bash
# Tail access log
sudo tail -f /var/log/nginx/access.log

# Tail error log
sudo tail -f /var/log/nginx/error.log

# View last 100 lines
sudo tail -100 /var/log/nginx/error.log

# Search for errors
sudo grep "error" /var/log/nginx/error.log
```

### Check Process Status
```bash
# Check if Nginx is running
sudo systemctl status nginx
ps aux | grep nginx

# Check Nginx version and modules
nginx -V
```

### Common Issues

#### Permission Denied
```bash
# Check file permissions
ls -la /var/www/html

# Fix ownership
sudo chown -R www-data:www-data /var/www/html

# Fix permissions
sudo chmod -R 755 /var/www/html
```

#### Port Already in Use
```bash
# Find process using port 80
sudo lsof -i :80
sudo netstat -tlnp | grep :80

# Kill process
sudo kill <PID>
```

#### 502 Bad Gateway
```bash
# Check backend service is running
sudo systemctl status php8.1-fpm
sudo systemctl status gunicorn

# Check socket file exists
ls -la /var/run/php/php8.1-fpm.sock

# Check socket permissions
sudo chmod 660 /var/run/php/php8.1-fpm.sock
```

## Best Practices

### Security
```nginx
# Hide Nginx version
server_tokens off;

# Limit request body size
client_max_body_size 10m;

# Timeout configurations
client_body_timeout 10s;
client_header_timeout 10s;

# Security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

### Performance
```nginx
# Enable compression
gzip on;
gzip_vary on;
gzip_comp_level 6;
gzip_types text/plain text/css application/json application/javascript;

# Enable caching
open_file_cache max=1000 inactive=20s;
open_file_cache_valid 30s;
open_file_cache_min_uses 2;

# Use sendfile
sendfile on;
tcp_nopush on;
tcp_nodelay on;
```

### Organization
```nginx
# Use include for common configurations
include /etc/nginx/snippets/ssl-params.conf;
include /etc/nginx/snippets/proxy-params.conf;

# Separate server blocks into individual files
# /etc/nginx/sites-available/example.com
# Enable with symlink: ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/

# Use descriptive comments
# Static file serving
location /static/ {
    root /var/www;
}
```

## References

- [Nginx Official Documentation](https://nginx.org/en/docs/)
- [Nginx Admin Guide](https://docs.nginx.com/nginx/admin-guide/)
- [Nginx Beginners Guide](https://nginx.org/en/docs/beginners_guide.html)
- [Nginx Configuration Reference](https://nginx.org/en/docs/dirindex.html)
- [Nginx Security Best Practices](https://nginx.org/en/docs/http/ngx_http_core_module.html#security)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)
