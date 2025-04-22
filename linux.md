# Comprehensive Linux Cheatsheet

## Table of Contents
- [File System Navigation](#file-system-navigation)
- [File Operations](#file-operations)
- [File Permissions](#file-permissions)
- [Text Processing](#text-processing)
- [Process Management](#process-management)
- [System Information](#system-information)
- [User Management](#user-management)
- [Networking](#networking)
- [Package Management](#package-management)
- [Archiving and Compression](#archiving-and-compression)
- [Disk Management](#disk-management)
- [Vim Editor](#vim-editor)
- [Shell Scripting Basics](#shell-scripting-basics)
- [System Services](#system-services)
- [SSH](#ssh)
- [Environment Variables](#environment-variables)
- [Cronjobs](#cronjobs)
- [Redirections and Pipes](#redirections-and-pipes)

## File System Navigation

### Basic Navigation
```bash
pwd                     # Print working directory
ls                      # List files and directories
ls -l                   # List with details (long format)
ls -a                   # List all (including hidden files)
ls -la                  # Combine options (long format, all files)
ls -lh                  # Human-readable file sizes
ls -R                   # Recursive listing
cd directory            # Change to specified directory
cd                      # Change to home directory
cd ~                    # Change to home directory
cd ..                   # Go up one directory
cd -                    # Go to previous directory
```

### Finding Files
```bash
find /path -name "pattern"       # Find files by name
find /path -type f -name "*.txt" # Find all .txt files
find /path -type d -name "*dir*" # Find all directories containing 'dir'
find /path -size +100M           # Find files larger than 100MB
find /path -mtime -7             # Find files modified in the last 7 days
locate filename                  # Quickly find file (uses database)
updatedb                         # Update locate database
which command                    # Show full path of command
whereis command                  # Show binary, source, and man page
```

## File Operations

### File Creation and Viewing
```bash
touch filename               # Create empty file or update timestamp
mkdir directory              # Create directory
mkdir -p dir1/dir2/dir3      # Create nested directories
cat file                     # Display file contents
less file                    # View file with paging
head file                    # Show first 10 lines
head -n 20 file             # Show first 20 lines
tail file                    # Show last 10 lines
tail -n 20 file             # Show last 20 lines
tail -f file                # Watch file for changes
```

### File Manipulation
```bash
cp source destination        # Copy file
cp -r source destination     # Copy directory recursively
mv source destination        # Move/rename file or directory
rm file                      # Remove file
rm -f file                   # Force remove file (no prompt)
rm -r directory              # Remove directory recursively
rm -rf directory             # Force remove directory recursively
rmdir directory              # Remove empty directory
ln -s target linkname        # Create symbolic link
```

### File Comparison
```bash
diff file1 file2             # Compare two files
sdiff file1 file2            # Side-by-side comparison
cmp file1 file2              # Compare byte by byte
md5sum file                  # Generate MD5 checksum
sha256sum file               # Generate SHA256 checksum
```

## File Permissions

### Viewing Permissions
```bash
ls -l                        # List with permissions
getfacl file                 # Get file access control lists
```

### Changing Permissions
```bash
chmod permissions file       # Change file permissions
chmod 755 file               # Set to rwxr-xr-x
chmod +x file                # Add execute permission
chmod -w file                # Remove write permission
chmod -R 755 directory       # Recursively change permissions

# Numeric permissions
# 4 = read (r)
# 2 = write (w)
# 1 = execute (x)
# Examples:
# 7 = rwx (4+2+1)
# 6 = rw- (4+2)
# 5 = r-x (4+1)
# 4 = r-- (4)
```

### Changing Ownership
```bash
chown user:group file        # Change owner and group
chown -R user:group directory # Recursively change ownership
chgrp group file             # Change group ownership
```

### Special Permissions
```bash
chmod u+s file               # Set SUID bit
chmod g+s directory          # Set SGID bit
chmod +t directory           # Set sticky bit
chmod 4755 file              # Set SUID with numeric mode
chmod 2755 directory         # Set SGID with numeric mode
chmod 1777 directory         # Set sticky bit with numeric mode
```

## Text Processing

### Viewing and Editing Text
```bash
cat file                     # Display file contents
more file                    # Page through file
less file                    # Better paging with backward navigation
vim file                     # Edit with Vim editor
```

### Text Processing Commands
```bash
grep pattern file            # Search for pattern in file
grep -i pattern file         # Case-insensitive search
grep -r pattern directory    # Recursive search
grep -v pattern file         # Show lines that don't match
grep -c pattern file         # Count matching lines
grep -n pattern file         # Show line numbers
egrep "pattern1|pattern2" file # Extended grep (regex)

sed 's/old/new/' file        # Replace first occurrence on each line
sed 's/old/new/g' file       # Replace all occurrences
sed -i 's/old/new/g' file    # Replace in file (modifies the file)
sed '5d' file                # Delete line 5
sed '5,10d' file             # Delete lines 5-10

awk '{print $1}' file        # Print first column
awk -F: '{print $1}' file    # Use custom field separator
awk '{sum+=$1} END {print sum}' file # Sum first column

sort file                    # Sort lines
sort -r file                 # Reverse sort
sort -n file                 # Numeric sort
sort -k2 file                # Sort by second column
uniq file                    # Remove duplicate adjacent lines
uniq -c file                 # Count occurrences
cut -d: -f1 file             # Cut field 1 with delimiter :
tr 'a-z' 'A-Z' < file        # Convert lowercase to uppercase
wc file                      # Count lines, words, characters
wc -l file                   # Count lines only
```

### Combining Text Processing
```bash
grep pattern file | sort | uniq    # Find unique matches, sorted
cat file | grep pattern | wc -l    # Count matching lines
awk '{print $1}' file | sort | uniq -c  # Count unique first column values
```

## Process Management

### Process Viewing
```bash
ps                          # Show current user processes
ps aux                      # Show all processes in BSD format
ps -ef                      # Show all processes in standard format
pgrep process_name          # Get PID of process
top                         # Dynamic process viewer
htop                        # Enhanced dynamic process viewer
```

### Process Control
```bash
kill PID                    # Send TERM signal to process
kill -9 PID                 # Force kill process (SIGKILL)
killall process_name        # Kill all processes with name
pkill process_name          # Kill processes with name (better pattern matching)
nohup command &             # Run command immune to hangups
command &                   # Run command in background
jobs                        # List background jobs
fg %job_number              # Bring job to foreground
bg %job_number              # Resume job in background
ctrl+z                      # Suspend current foreground process
ctrl+c                      # Terminate current foreground process
nice -n 19 command          # Run with lower priority (nice value)
renice +10 -p PID           # Change priority of running process
```

### Process Monitoring
```bash
top                         # Interactive process monitor
htop                        # Enhanced process monitor
atop                        # Advanced system & process monitor
iotop                       # I/O monitor
lsof                        # List open files
lsof -p PID                 # List files opened by process
lsof /path/to/file          # Show which processes are using file
fuser -m /path/to/file      # Show processes using file/directory
```

## System Information

### System and Hardware
```bash
uname -a                    # All system information
uname -r                    # Kernel version
cat /etc/os-release         # OS information
hostname                    # System hostname
uptime                      # System uptime and load
date                        # Current date and time
cal                         # Calendar
lscpu                       # CPU information
lspci                       # PCI devices
lsusb                       # USB devices
lsblk                       # Block devices
free -h                     # Memory usage (human-readable)
df -h                       # Disk usage (human-readable)
du -sh /path                # Directory size (summarized, human-readable)
```

### System Monitoring
```bash
top                         # Process activity in real-time
htop                        # Enhanced version of top
vmstat                      # Virtual memory statistics
iostat                      # CPU and I/O statistics
mpstat                      # Multiple processor statistics
netstat                     # Network statistics
ss                          # Socket statistics (modern netstat)
sar                         # System activity reporter
```

### System Logs
```bash
dmesg                       # Kernel ring buffer messages
journalctl                  # Query systemd journal
journalctl -u service       # Logs for specific service
journalctl -f               # Follow new journal entries
less /var/log/syslog        # System log
tail -f /var/log/auth.log   # Authentication log
```

## User Management

### User Information
```bash
whoami                      # Current username
id                          # User and group IDs
w                           # Who is logged in and what they're doing
who                         # Who is logged in
last                        # Show last logins
finger user                 # User information
```

### User and Group Management
```bash
sudo command                # Execute command as superuser
su - username               # Switch to user (with environment)
passwd                      # Change current user password
passwd username             # Change another user's password

useradd username            # Create user
useradd -m -s /bin/bash username  # Create user with home and bash shell
userdel username            # Delete user
userdel -r username         # Delete user and home directory

groupadd groupname          # Create group
groupdel groupname          # Delete group
usermod -aG group user      # Add user to group
gpasswd -a user group       # Add user to group
gpasswd -d user group       # Remove user from group

chage -l username           # List user password expiry info
```

### Sudo and Permissions
```bash
sudo command                # Run command as root
sudo -u user command        # Run as specified user
sudo -i                     # Start shell as root
sudo -l                     # List allowed commands
visudo                      # Edit sudoers file safely
```

## Networking

### Network Configuration
```bash
ip addr                     # Show IP addresses
ip link                     # Show network interfaces
ip route                    # Show routing table
ip neigh                    # Show ARP table
ifconfig                    # Legacy command for IP addresses
route                       # Legacy command for routing table
dhclient -v                 # Request new DHCP lease

nmcli device show           # Show NetworkManager devices
nmcli connection show       # Show NetworkManager connections
nmcli connection up id NAME # Activate connection
```

### Network Diagnostics
```bash
ping host                   # Send ICMP echo requests
traceroute host             # Print route packets trace
tracepath host              # Trace path to host with smaller packets
mtr host                    # Combines ping and traceroute
dig domain                  # DNS lookup
nslookup domain             # DNS lookup (interactive)
host domain                 # DNS lookup (simpler)
whois domain                # Domain registration info
```

### Network Connections
```bash
ss                          # Socket statistics
ss -tuln                    # TCP/UDP listening numeric ports
netstat -tuln               # Legacy command for listening ports
netstat -anp                # All connections with PID
lsof -i                     # List Internet connections
lsof -i :port               # List processes using port
```

### Bandwidth Monitoring
```bash
iftop                       # Network bandwidth monitor
nethogs                     # Monitor bandwidth by process
iptraf                      # Interactive IP traffic monitor
bmon                        # Bandwidth monitor and rate estimator
```

### Firewall
```bash
# Uncomplicated Firewall (UFW)
ufw status                  # Check status
ufw enable                  # Enable firewall
ufw disable                 # Disable firewall
ufw allow 22/tcp            # Allow SSH
ufw deny 80/tcp             # Block HTTP
ufw delete deny 80/tcp      # Remove rule

# iptables
iptables -L                 # List rules
iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # Allow SSH
iptables -A INPUT -p tcp --dport 80 -j DROP    # Block HTTP
iptables-save > rules       # Save rules
iptables-restore < rules    # Restore rules
```

## Package Management

### Debian/Ubuntu (APT)
```bash
apt update                  # Update package list
apt upgrade                 # Upgrade packages
apt full-upgrade            # Upgrade with package removal if needed
apt install package         # Install package
apt remove package          # Remove package
apt purge package           # Remove package and configuration
apt autoremove              # Remove unused dependencies
apt search string           # Search for packages
apt show package            # Show package details
apt list --installed        # List installed packages
dpkg -i package.deb         # Install local package
dpkg -l                     # List installed packages
dpkg -S /path/to/file       # Find which package owns file
```

### Red Hat/CentOS (YUM/DNF)
```bash
yum update                  # Update packages
yum install package         # Install package
yum remove package          # Remove package
yum search string           # Search for packages
yum info package            # Show package details
yum list installed          # List installed packages
rpm -i package.rpm          # Install local package
rpm -q package              # Query if package is installed
rpm -ql package             # List files in package
rpm -qf /path/to/file       # Find which package owns file

# DNF (modern YUM)
dnf update                  # Update packages
dnf install package         # Install package
dnf remove package          # Remove package
```

### Arch Linux (Pacman)
```bash
pacman -Syu                 # Update system
pacman -S package           # Install package
pacman -R package           # Remove package
pacman -Rs package          # Remove package and dependencies
pacman -Ss string           # Search for packages
pacman -Si package          # Show package info
pacman -Q                   # List installed packages
pacman -Qe                  # List explicitly installed packages
pacman -Qdt                 # List orphaned dependencies
```

## Archiving and Compression

### tar
```bash
tar -cvf archive.tar directory/    # Create tar archive
tar -xvf archive.tar               # Extract tar archive
tar -tvf archive.tar               # List contents
tar -czvf archive.tar.gz directory/  # Create compressed tar (gzip)
tar -xzvf archive.tar.gz           # Extract compressed tar (gzip)
tar -cjvf archive.tar.bz2 directory/ # Create compressed tar (bzip2)
tar -xjvf archive.tar.bz2          # Extract compressed tar (bzip2)
```

### Other Compression Tools
```bash
gzip file                   # Compress file to file.gz
gunzip file.gz              # Decompress file.gz
bzip2 file                  # Compress file to file.bz2
bunzip2 file.bz2            # Decompress file.bz2
xz file                     # Compress file to file.xz
unxz file.xz                # Decompress file.xz
zip -r archive.zip directory/  # Create zip archive
unzip archive.zip           # Extract zip archive
```

## Disk Management

### Disk Usage
```bash
df -h                       # Show disk space usage
du -sh directory            # Directory size summary
du -h --max-depth=1 /       # Size of top-level directories
ncdu                        # Interactive disk usage analyzer
lsblk                       # List block devices
blkid                       # Show block device attributes
```

### Disk Partitioning
```bash
fdisk -l                    # List partitions
fdisk /dev/sdX              # Partition disk (interactive)
gdisk /dev/sdX              # GPT partition (interactive)
parted /dev/sdX             # Advanced partitioning
mkfs.ext4 /dev/sdXY         # Format as ext4
mkfs.xfs /dev/sdXY          # Format as XFS
mkswap /dev/sdXY            # Create swap area
swapon /dev/sdXY            # Enable swap
```

### Mounting
```bash
mount /dev/sdXY /mnt        # Mount filesystem
mount -a                    # Mount all in fstab
umount /mnt                 # Unmount filesystem
mount | grep sdX            # Show mounted filesystems
```

### Checking and Repairing
```bash
fsck /dev/sdXY              # Check filesystem
fsck -f /dev/sdXY           # Force check
e2fsck -f /dev/sdXY         # Force check ext filesystem
tune2fs -l /dev/sdXY        # Show ext filesystem info
xfs_repair /dev/sdXY        # Repair XFS filesystem
xfs_info /dev/sdXY          # Show XFS filesystem info
smartctl -a /dev/sdX        # Show SMART disk info
smartctl -t short /dev/sdX  # Run short SMART test
```

### Logical Volume Management (LVM)
```bash
pvcreate /dev/sdXY          # Create physical volume
pvdisplay                   # Show physical volumes
vgcreate vgname /dev/sdXY   # Create volume group
vgdisplay                   # Show volume groups
lvcreate -L 10G -n lvname vgname  # Create logical volume
lvdisplay                   # Show logical volumes
lvextend -L +5G /dev/vgname/lvname  # Extend logical volume
resize2fs /dev/vgname/lvname  # Resize filesystem after extending
```

## Vim Editor

### Starting Vim
```bash
vim file                    # Edit file with Vim
vim +10 file                # Open file at line 10
vim +/pattern file          # Open file at first pattern
vim -R file                 # Open file in read-only mode
```

### Vim Modes
```
ESC                         # Enter Normal mode
i                           # Enter Insert mode (before cursor)
a                           # Enter Insert mode (after cursor)
v                           # Enter Visual mode (character selection)
V                           # Enter Visual Line mode (line selection)
ctrl+v                      # Enter Visual Block mode (column selection)
:                           # Enter Command mode
```

### Navigation (Normal Mode)
```
h, j, k, l                  # Left, down, up, right
w                           # Next word start
b                           # Previous word start
e                           # Next word end
0                           # Start of line
$                           # End of line
^                           # First non-blank character
gg                          # First line of file
G                           # Last line of file
:n                          # Go to line n
ctrl+f                      # Page down
ctrl+b                      # Page up
%                           # Jump to matching bracket
```

### Editing (Normal Mode)
```
i                           # Insert before cursor
a                           # Insert after cursor
I                           # Insert at beginning of line
A                           # Insert at end of line
o                           # Open new line below
O                           # Open new line above
r                           # Replace single character
R                           # Replace mode
s                           # Delete character and insert
S                           # Delete line and insert
x                           # Delete character
dd                          # Delete line
dw                          # Delete word
d$                          # Delete to end of line
d0                          # Delete to start of line
yy                          # Yank (copy) line
yw                          # Yank word
p                           # Paste after cursor
P                           # Paste before cursor
u                           # Undo
ctrl+r                      # Redo
.                           # Repeat last command
```

### Search and Replace (Normal Mode)
```
/pattern                    # Search forward
?pattern                    # Search backward
n                           # Next search result
N                           # Previous search result
:%s/old/new/g               # Replace all occurrences in file
:%s/old/new/gc              # Replace with confirmation
:n,ms/old/new/g             # Replace between lines n and m
```

### Multiple Files
```
:e file                     # Edit file
:bn                         # Next buffer
:bp                         # Previous buffer
:ls                         # List buffers
:b n                        # Go to buffer n
:vs file                    # Vertical split with file
:sp file                    # Horizontal split with file
ctrl+w + arrow              # Navigate between splits
ctrl+w _                    # Maximize height of split
ctrl+w |                    # Maximize width of split
ctrl+w =                    # Equal dimensions
:tabnew file                # Open file in new tab
gt                          # Next tab
gT                          # Previous tab
```

### Saving and Quitting
```
:w                          # Save
:w file                     # Save as
:wq                         # Save and quit
:x                          # Save and quit
:q                          # Quit (if no changes)
:q!                         # Force quit (discard changes)
ZZ                          # Save and quit
ZQ                          # Quit without saving
```

### Configuration
```
:set number                 # Show line numbers
:set nonumber               # Hide line numbers
:set hlsearch               # Highlight search
:set nohlsearch             # Disable search highlight
:set ignorecase             # Case-insensitive search
:set syntax=python          # Set syntax highlighting
:set tabstop=4              # Tab width
:set expandtab              # Use spaces instead of tabs
:set autoindent             # Enable auto indent
```

## Shell Scripting Basics

### Script Structure
```bash
#!/bin/bash                 # Shebang line (use bash interpreter)

# Comments start with #
# Variables
NAME="World"
echo "Hello, $NAME!"        # Using variables

# Command substitution
TODAY=$(date +%Y-%m-%d)
echo "Today is $TODAY"

# Functions
function greet() {
    echo "Hello, $1!"
}
greet "User"

# Exit script with status
exit 0                     # Success
```

### Control Structures
```bash
# Conditionals
if [ "$1" = "test" ]; then
    echo "Testing mode"
elif [ "$1" = "prod" ]; then
    echo "Production mode"
else
    echo "Unknown mode"
fi

# Loops - for
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# Loops - while
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    count=$((count + 1))
done

# Case statement
case "$1" in
    start)
        echo "Starting service"
        ;;
    stop)
        echo "Stopping service"
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        ;;
esac
```

### Shell Script Operations
```bash
# Arithmetic operations
result=$((5 + 3))
echo $result               # Outputs 8

# String operations
str1="Hello"
str2="World"
echo "$str1 $str2"         # Concatenation
echo "${#str1}"            # String length

# Reading input
echo "Enter your name:"
read name
echo "Hello, $name!"

# Command line arguments
echo "Script name: $0"
echo "First argument: $1"
echo "All arguments: $@"
echo "Number of arguments: $#"

# Checking command success
if command; then
    echo "Command succeeded"
else
    echo "Command failed"
fi

# Using exit status
command
status=$?
echo "Exit status: $status"
```

## System Services

### Systemd Service Management
```bash
systemctl start service     # Start service
systemctl stop service      # Stop service
systemctl restart service   # Restart service
systemctl reload service    # Reload configuration
systemctl status service    # Check service status
systemctl enable service    # Enable service at boot
systemctl disable service   # Disable service at boot
systemctl list-units --type=service  # List running services
systemctl list-unit-files   # List all services
systemctl daemon-reload     # Reload systemd configuration
```

### System State Management
```bash
systemctl poweroff          # Power off system
systemctl reboot            # Reboot system
systemctl suspend           # Suspend system
systemctl hibernate         # Hibernate system
```

### Service Logs
```bash
journalctl                  # Show all logs
journalctl -u service       # Show service logs
journalctl -f               # Follow new entries
journalctl --since=today    # Show today's logs
journalctl --since="1 hour ago"  # Show logs from last hour
journalctl -p err           # Show error messages
```

## SSH

### SSH Connections
```bash
ssh user@host               # Connect to host as user
ssh -p port user@host       # Connect using specific port
ssh -i key.pem user@host    # Connect using identity file
ssh-copy-id user@host       # Copy SSH key to host
ssh -X user@host            # Enable X11 forwarding
```

### SSH Key Management
```bash
ssh-keygen                  # Generate SSH key pair
ssh-keygen -t ed25519       # Generate Ed25519 key (modern)
ssh-keygen -t rsa -b 4096   # Generate 4096-bit RSA key
ssh-add ~/.ssh/id_rsa       # Add key to SSH agent
ssh-add -l                  # List keys in SSH agent
```

### SSH Config
```bash
# ~/.ssh/config file example
Host myserver
    HostName example.com
    User myuser
    Port 2222
    IdentityFile ~/.ssh/id_rsa_server
```

### SCP (Secure Copy)
```bash
scp file user@host:/path    # Copy from local to remote
scp user@host:/path file    # Copy from remote to local
scp -r dir user@host:/path  # Recursively copy directory
```

## Environment Variables

### Variable Operations
```bash
echo $VARIABLE              # Display variable value
VARIABLE=value              # Set variable (current shell only)
export VARIABLE=value       # Set variable (and subshells)
unset VARIABLE              # Unset variable
env                         # Display all environment variables
printenv                    # Display all environment variables
```

### Common Environment Variables
```bash
HOME                        # User home directory
PATH                        # Executable search path
USER                        # Current username
SHELL                       # Current shell
PWD                         # Current working directory
LANG                        # System language and locale
TERM                        # Terminal type
EDITOR                      # Default text editor
```

### Persistent Environment Variables
```bash
# Add to ~/.bashrc or ~/.bash_profile
export VARIABLE=value

# System-wide variables
# /etc/environment
# /etc/profile
# /etc/profile.d/*.sh
```

## Cronjobs

### Crontab Operations
```bash
crontab -e                  # Edit current user's crontab
crontab -l                  # List current user's crontab
crontab -r                  # Remove current user's crontab
sudo crontab -e -u user     # Edit another user's crontab
```

### Crontab Format
```
# minute hour day_of_month month day_of_week command
# Values:
# minute: 0-59
# hour: 0-23
# day_of_month: 1-31
# month: 1-12 or JAN-DEC
# day_of_week: 0-6 or SUN-SAT (0=Sunday)

# Examples:
0 5 * * *     command  # Run daily at 5:00 AM
*/15 * * * *  command  # Run every 15 minutes
0 9-17 * * 1-5 command # Run hourly 9AM-5PM, weekdays
0 0 1 * *     command  # Run monthly (1st of month)
@reboot       command  # Run at system startup
```

### Systemd Timers (Modern Alternative)
```bash
# Creating a timer service
# /etc/systemd/system/mytask.service
# /etc/systemd/system/mytask.timer

# Managing timers
systemctl start mytask.timer
systemctl enable mytask.timer
systemctl list-timers       # List active timers
```

## Redirections and Pipes

### Standard I/O Redirection
```bash
command > file              # Redirect stdout to file (overwrite)
command >> file             # Redirect stdout to file (append)
command 2> file             # Redirect stderr to file
command &> file             # Redirect both stdout and stderr
command > file 2>&1         # Redirect both (traditional way)
command < file              # Use file as stdin
```

### Piping
```bash
command1 | command2         # Pipe stdout of command1 to stdin of command2
command1 |& command2        # Pipe both stdout and stderr
command | tee file          # Send stdout to both file and next command
command | tee -a file       # Append to file and pass to next command
```

### Command Chaining
```bash
command1 ; command2         # Run command1 then command2
command1 && command2        # Run command2 only if command1 succeeds
command1 || command2        # Run command2 only if command1 fails
(command1 ; command2)       # Group commands in subshell
{ command1 ; command2 ; }   # Group commands without subshell
```

### Process Substitution
```bash
command <(command1)         # Use command1 output as file input
command1 > >(command2)      # Send command1 output to command2 input
diff <(command1) <(command2) # Compare outputs of two commands
```

### Here Documents and Strings
```bash
command << EOF              # Here document
line 1
line 2
EOF

command <<< "string"        # Here string
```
