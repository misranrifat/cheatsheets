# SSH Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Basic SSH Commands](#basic-ssh-commands)
- [SSH Keys](#ssh-keys)
- [SSH Config File](#ssh-config-file)
- [Port Forwarding](#port-forwarding)
- [SSH Tunneling](#ssh-tunneling)
- [Jump Hosts (Bastion Hosts)](#jump-hosts-bastion-hosts)
- [SCP (Secure Copy)](#scp-secure-copy)
- [SFTP (Secure File Transfer Protocol)](#sftp-secure-file-transfer-protocol)
- [Agent Forwarding](#agent-forwarding)
- [Multiplexing Connections](#multiplexing-connections)
- [X11 Forwarding](#x11-forwarding)
- [SSH Key Management](#ssh-key-management)
- [Hardening SSH Server](#hardening-ssh-server)
- [Security Tips](#security-tips)
- [References](#references)

## Introduction
SSH (Secure Shell) is a protocol for securely connecting to remote machines over a network.

## Basic SSH Commands
```bash
ssh user@host                      # Connect to a remote host
ssh -p 2222 user@host               # Connect using a custom port
ssh -i ~/.ssh/id_rsa user@host      # Connect using a specific private key
ssh user@host "command"             # Run a remote command
ssh -v user@host                    # Verbose output (debugging)
ssh -X user@host                    # Enable X11 forwarding
```

## SSH Keys
### Generate SSH Key Pair
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
- Public key: `~/.ssh/id_rsa.pub`
- Private key: `~/.ssh/id_rsa`

### Copy Public Key to Server
```bash
ssh-copy-id user@host
```
Or manually append `id_rsa.pub` to the server's `~/.ssh/authorized_keys`.

## SSH Config File
Path: `~/.ssh/config`

Example config:
```bash
Host myserver
    HostName example.com
    User myuser
    Port 2222
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent yes
    ServerAliveInterval 60
```

Connect with:
```bash
ssh myserver
```

## Port Forwarding
### Local Forwarding
```bash
ssh -L local_port:remote_host:remote_port user@ssh_server
```
Example:
```bash
ssh -L 8080:localhost:80 user@remote-server
```

### Remote Forwarding
```bash
ssh -R remote_port:localhost:local_port user@ssh_server
```
Example:
```bash
ssh -R 9090:localhost:3000 user@remote-server
```

## SSH Tunneling
Forward traffic securely through SSH:
```bash
ssh -D 8080 user@remote-server
```
- Creates a SOCKS5 proxy on `localhost:8080`

## Jump Hosts (Bastion Hosts)
Use a bastion server to reach an internal server:
```bash
ssh -J bastion_user@bastion_host target_user@target_host
```
Or in `~/.ssh/config`:
```bash
Host target
    HostName target_host
    ProxyJump bastion_user@bastion_host
```

## SCP (Secure Copy)
### Copy Local to Remote
```bash
scp file.txt user@remote:/path/to/destination
```

### Copy Remote to Local
```bash
scp user@remote:/path/to/file.txt /local/destination
```

### Copy Directory
```bash
scp -r /local/dir user@remote:/remote/dir
```

## SFTP (Secure File Transfer Protocol)
```bash
sftp user@host
```
Common commands inside `sftp`:
```bash
ls               # List files
cd directory     # Change directory
put localfile    # Upload file
get remotefile   # Download file
exit             # Exit SFTP session
```

## Agent Forwarding
Forward local SSH agent to the remote machine:
```bash
ssh -A user@remote-server
```
Useful for jumping into other servers from the first.

## Multiplexing Connections
Speed up multiple SSH connections:

In `~/.ssh/config`:
```bash
Host *
    ControlMaster auto
    ControlPath ~/.ssh/cm_socket/%r@%h:%p
    ControlPersist 10m
```
Create the socket directory:
```bash
mkdir -p ~/.ssh/cm_socket
```

## X11 Forwarding
Run GUI apps over SSH:
```bash
ssh -X user@remote-host
```
Example:
```bash
ssh -X user@remote-host gedit
```
Requires X server installed locally (XQuartz for Mac, Xming for Windows).

## SSH Key Management
- List SSH agent keys:
```bash
ssh-add -l
```
- Add a private key to SSH agent:
```bash
ssh-add ~/.ssh/id_rsa
```
- Remove keys:
```bash
ssh-add -D
```

## Hardening SSH Server
Edit `/etc/ssh/sshd_config`:
```bash
PermitRootLogin no
PasswordAuthentication no
AllowUsers specificuser
Port 2222
MaxAuthTries 3
LoginGraceTime 30
PermitEmptyPasswords no
UseDNS no
```
Restart SSH service after changes:
```bash
sudo systemctl restart sshd
```

## Security Tips
- Disable password authentication
- Use Fail2ban to ban IPs after failed login attempts
- Rotate SSH keys regularly
- Monitor `/var/log/auth.log` for suspicious activity
- Set up Two-Factor Authentication (2FA) for SSH

## References
- [SSH Manual](https://man.openbsd.org/ssh)
- [OpenSSH Official Site](https://www.openssh.com/)
- [Mozilla SSH Configuration Guidelines](https://infosec.mozilla.org/guidelines/openssh.html)

