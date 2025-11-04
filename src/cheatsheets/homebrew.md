# Comprehensive Homebrew Cheatsheet

## Table of Contents
- [Installation](#installation)
- [Basic Commands](#basic-commands)
- [Package Management](#package-management)
- [Repository Management](#repository-management)
- [Troubleshooting](#troubleshooting)
- [Cask Commands](#cask-commands)
- [Services](#services)
- [Environment](#environment)
- [Advanced Usage](#advanced-usage)

## Installation

### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Post-installation (if needed)
Add Homebrew to your PATH:
```bash
# For macOS with zsh (default since Catalina)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For macOS with bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Linux
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

## Basic Commands

### Get Help
```bash
brew help                     # Print help information
brew help [command]           # Print help info for a specific command
```

### System Information
```bash
brew doctor                   # Check system for potential problems
brew --version                # Display version information
brew config                   # Show brew and system configuration
```

### Update Homebrew
```bash
brew update                   # Fetch latest version of Homebrew and formulae
```

### Search for Packages
```bash
brew search [TEXT|/REGEX/]    # Search for packages
brew search --casks [TEXT]    # Search for casks only
brew search --formulae [TEXT] # Search for formulae only
```

### Package Information
```bash
brew info [FORMULA|CASK]      # Display information about formula/cask
brew desc [FORMULA]           # Display formula's description
brew deps [FORMULA]           # List dependencies of formula
brew uses [FORMULA]           # List formulae that depend on specified formula
```

## Package Management

### Installation
```bash
brew install FORMULA          # Install formula
brew install FORMULA@VERSION  # Install specific version of formula
brew install --cask CASK      # Install cask application
brew reinstall FORMULA        # Reinstall formula
```

### Upgrades
```bash
brew upgrade                  # Upgrade all outdated packages
brew upgrade FORMULA          # Upgrade specific formula
brew upgrade --cask           # Upgrade all outdated casks
brew upgrade --cask CASK      # Upgrade specific cask
```

### List Installed Packages
```bash
brew list                     # List all installed formulae and casks
brew list --formulae          # List only installed formulae
brew list --casks             # List only installed casks
brew list --versions          # List installed formulae with versions
brew leaves                   # List installed formulae that aren't dependencies
brew outdated                 # List outdated formulae and casks
```

### Uninstallation
```bash
brew uninstall FORMULA        # Uninstall formula
brew uninstall --cask CASK    # Uninstall cask
brew uninstall --force FORMULA # Force uninstall formula
brew autoremove               # Remove unused dependencies
brew cleanup                  # Remove old versions of installed formulae
brew cleanup -n               # Show what would be removed (dry run)
```

### Pinning
```bash
brew pin FORMULA              # Prevent formula from being upgraded
brew unpin FORMULA            # Allow formula to be upgraded again
brew list --pinned            # List all pinned formulae
```

## Repository Management

### Taps (Third-party repositories)
```bash
brew tap                      # List currently tapped repositories
brew tap USER/REPO            # Add tap repository from GitHub
brew tap USER/REPO URL        # Add tap repository from specified URL
brew untap USER/REPO          # Remove a tapped repository
```

### Homebrew Bundle
```bash
brew bundle                   # Install packages from Brewfile in current directory
brew bundle dump              # Create a Brewfile from installed packages
brew bundle cleanup           # List packages to remove if following Brewfile
brew bundle list              # List packages in Brewfile
```

## Troubleshooting

### Fix Issues
```bash
brew doctor                   # Check for problems
brew missing                  # Check for missing dependencies
brew fix                      # Fix brew issues (if possible)
```

### Cache Management
```bash
brew cleanup                  # Remove old versions of installed formulae
brew cleanup -s               # Remove all cache files older than 120 days
brew cleanup FORMULA          # Remove old versions of specific formula
brew cleanup --prune=all      # Remove all cache files
```

### Permissions Fix
```bash
sudo chown -R $(whoami):admin /usr/local/*    # Fix permissions (macOS Intel)
sudo chown -R $(whoami):admin /opt/homebrew/* # Fix permissions (macOS Apple Silicon)
```

## Cask Commands

### Cask-specific Operations
```bash
brew install --cask CASK      # Install cask application
brew uninstall --cask CASK    # Uninstall cask application
brew list --casks             # List installed casks
brew outdated --casks         # List outdated casks
brew upgrade --cask           # Upgrade all outdated casks
brew info --cask CASK         # Display cask information
```

### Cask Options
```bash
brew install --cask --appdir=/Applications CASK   # Install to specific directory
brew install --cask --no-quarantine CASK          # Skip quarantine check
```

## Services

### Manage Services (formulae with service scripts)
```bash
brew services list            # List all services
brew services run FORMULA     # Run service without registering to launch at login
brew services start FORMULA   # Start service and register it to launch at login
brew services stop FORMULA    # Stop service and unregister it from launch at login
brew services restart FORMULA # Restart service
brew services cleanup         # Remove all unused services
```

## Environment

### Environment Variables
```bash
brew --env                    # Print environment variables used by Homebrew
HOMEBREW_NO_AUTO_UPDATE=1 brew install FORMULA  # Skip auto-update during install
HOMEBREW_NO_ANALYTICS=1                         # Disable analytics
```

### Paths
```bash
brew --prefix                 # Display Homebrew installation path
brew --prefix FORMULA         # Display installation path for formula
brew --cellar                 # Display Homebrew cellar path
brew --repository             # Display Homebrew repository path
brew --cache                  # Display Homebrew cache path
```

## Advanced Usage

### Creating Formulae
```bash
brew create URL               # Create formula from URL
brew edit FORMULA             # Edit formula in default editor
brew extract [--version=] FORMULA TAP  # Extract version of formula to tap
```

### Testing
```bash
brew test FORMULA             # Test formula
brew audit FORMULA            # Audit formula for issues
brew style FORMULA            # Check formula style
```

### External Commands (Brew extensions)
```bash
brew commands                 # List all brew commands, including external ones
```

### Common Flags
```bash
-v, --verbose                 # Show more verbose output
-d, --debug                   # Show debugging information
-q, --quiet                   # Suppress warnings
```
