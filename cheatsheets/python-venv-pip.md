# Python Virtual Environments & pip Cheatsheet

## Table of Contents
- [Introduction](#introduction)
- [Virtual Environments](#virtual-environments)
- [venv Module](#venv-module)
- [virtualenv Package](#virtualenv-package)
- [conda Environments](#conda-environments)
- [pip Package Manager](#pip-package-manager)
- [Requirements Files](#requirements-files)
- [pip Configuration](#pip-configuration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Introduction

Virtual environments isolate Python projects by creating separate directories containing their own Python installation and packages. This prevents dependency conflicts between projects.

## Virtual Environments

### Why Use Virtual Environments?
- Isolate project dependencies
- Avoid conflicts between package versions
- Maintain reproducible environments
- Keep global Python installation clean
- Easily share project requirements

## venv Module

Built-in Python module (Python 3.3+) for creating virtual environments.

### Create Virtual Environment
```bash
# Basic creation
python -m venv venv
python3 -m venv venv

# Create with specific Python version
python3.11 -m venv venv

# Create without pip (install manually later)
python -m venv --without-pip venv

# Create with system site-packages access
python -m venv --system-site-packages venv

# Create with prompt name
python -m venv --prompt myproject venv
```

### Activate Virtual Environment

**Linux/macOS:**
```bash
# Activate
source venv/bin/activate

# Or using dot notation
. venv/bin/activate
```

**Windows (Command Prompt):**
```cmd
venv\Scripts\activate.bat
```

**Windows (PowerShell):**
```powershell
venv\Scripts\Activate.ps1

# If execution policy error occurs:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Fish Shell:**
```bash
source venv/bin/activate.fish
```

**Csh/Tcsh:**
```bash
source venv/bin/activate.csh
```

### Deactivate Virtual Environment
```bash
# Works on all platforms
deactivate
```

### Delete Virtual Environment
```bash
# Simply remove the directory
rm -rf venv          # Linux/macOS
rmdir /s venv        # Windows
```

### Upgrade venv's pip
```bash
# After activating venv
python -m pip install --upgrade pip
```

## virtualenv Package

Third-party tool with more features than venv. Supports Python 2 and 3.

### Installation
```bash
pip install virtualenv
```

### Create Virtual Environment
```bash
# Basic creation
virtualenv venv

# Specify Python version
virtualenv -p python3.11 venv
virtualenv --python=/usr/bin/python3.9 venv

# Use specific Python interpreter
virtualenv -p /usr/local/bin/python3 venv

# Create with no pip/setuptools/wheel
virtualenv --no-pip --no-setuptools --no-wheel venv

# Copy Python binary instead of symlink
virtualenv --always-copy venv
```

### Activation
Same as venv (see above).

## conda Environments

Anaconda/Miniconda package and environment manager.

### Create conda Environment
```bash
# Create with specific Python version
conda create --name venv python=3.11

# Create with packages
conda create --name venv python=3.11 numpy pandas

# Create from environment file
conda env create -f environment.yml

# Create with specific channel
conda create --name venv python=3.11 -c conda-forge
```

### Activate/Deactivate conda Environment
```bash
# Activate
conda activate venv

# Deactivate
conda deactivate
```

### List conda Environments
```bash
conda env list
conda info --envs
```

### Remove conda Environment
```bash
conda env remove --name venv
```

### Export conda Environment
```bash
# Export to YAML file
conda env export > environment.yml

# Export without builds
conda env export --no-builds > environment.yml

# Export cross-platform compatible
conda env export --from-history > environment.yml
```

## pip Package Manager

Python's package installer for installing packages from PyPI (Python Package Index).

### Installation and Upgrade
```bash
# Check pip version
pip --version
pip -V

# Upgrade pip
python -m pip install --upgrade pip

# Install pip (if not present)
python -m ensurepip --upgrade
```

### Installing Packages
```bash
# Install latest version
pip install package_name

# Install specific version
pip install package_name==1.2.3

# Install minimum version
pip install "package_name>=1.2.3"

# Install version range
pip install "package_name>=1.2,<2.0"

# Install compatible version
pip install "package_name~=1.2.3"  # >=1.2.3, <1.3.0

# Install from requirements file
pip install -r requirements.txt

# Install multiple packages
pip install package1 package2 package3

# Install with extras
pip install package_name[extra1,extra2]
pip install "requests[security,socks]"

# Install from Git repository
pip install git+https://github.com/user/repo.git
pip install git+https://github.com/user/repo.git@branch_name
pip install git+https://github.com/user/repo.git@v1.0

# Install from local directory
pip install /path/to/package
pip install .  # Install current directory

# Install in editable/development mode
pip install -e /path/to/package
pip install -e .  # Install current directory in editable mode

# Install from wheel file
pip install package_name.whl

# Install from source archive
pip install package_name.tar.gz
```

### Upgrading Packages
```bash
# Upgrade single package
pip install --upgrade package_name
pip install -U package_name

# Upgrade pip itself
python -m pip install --upgrade pip

# Upgrade all packages (using pip-review)
pip install pip-review
pip-review --auto
```

### Uninstalling Packages
```bash
# Uninstall single package
pip uninstall package_name

# Uninstall multiple packages
pip uninstall package1 package2

# Uninstall from requirements file
pip uninstall -r requirements.txt

# Uninstall without confirmation
pip uninstall -y package_name
```

### Listing Packages
```bash
# List installed packages
pip list

# List outdated packages
pip list --outdated
pip list -o

# List up-to-date packages
pip list --uptodate
pip list -u

# List packages in requirements format
pip freeze

# List packages not required by others
pip list --not-required

# Show package details
pip show package_name

# Show package files
pip show --files package_name
```

### Searching Packages
```bash
# Search PyPI (deprecated in pip 21.0+)
pip search package_name

# Use PyPI website instead
# https://pypi.org/search/?q=package_name
```

### Package Information
```bash
# Show package information
pip show package_name

# Show all package details including dependencies
pip show package_name

# Check package dependencies
pip show package_name | grep Requires
```

### Dependency Management
```bash
# Show dependency tree (requires pipdeptree)
pip install pipdeptree
pipdeptree

# Show packages that depend on a package
pipdeptree --reverse --packages package_name

# Check for conflicts
pip check
```

## Requirements Files

### Generate Requirements File
```bash
# Generate from current environment
pip freeze > requirements.txt

# Generate only top-level packages (manual)
pip list --format=freeze > requirements.txt

# Using pipreqs (scans project imports)
pip install pipreqs
pipreqs /path/to/project
pipreqs . --force  # Overwrite existing

# Using pip-tools
pip install pip-tools
pip-compile requirements.in
```

### Requirements File Format
```txt
# requirements.txt

# Exact version
Django==4.2.0

# Minimum version
requests>=2.28.0

# Version range
numpy>=1.20.0,<2.0.0

# Compatible version
Flask~=2.3.0

# Install from Git
git+https://github.com/user/repo.git@v1.0#egg=package_name

# Install with extras
celery[redis,msgpack]>=5.3.0

# Comments
# This is a comment

# Environment markers
pytest>=7.0.0; python_version >= "3.8"
typing-extensions>=4.0.0; python_version < "3.10"

# Local package
-e ./local_package

# Include another requirements file
-r base.txt
```

### Install from Requirements
```bash
# Install all requirements
pip install -r requirements.txt

# Install with specific index URL
pip install -r requirements.txt -i https://pypi.org/simple

# Install with extra index URL
pip install -r requirements.txt --extra-index-url https://custom.pypi.org
```

### Multiple Requirements Files
```txt
# Common structure:
# requirements/
#   ├── base.txt       # Common dependencies
#   ├── dev.txt        # Development dependencies
#   ├── prod.txt       # Production dependencies
#   └── test.txt       # Testing dependencies

# dev.txt example:
-r base.txt
pytest>=7.0.0
black>=23.0.0
mypy>=1.0.0

# prod.txt example:
-r base.txt
gunicorn>=20.1.0
```

## pip Configuration

### Configuration File Locations
```bash
# Global
# Linux/macOS: /etc/pip.conf or /etc/xdg/pip/pip.conf
# Windows: C:\ProgramData\pip\pip.ini

# User
# Linux/macOS: ~/.config/pip/pip.conf or ~/.pip/pip.conf
# Windows: %APPDATA%\pip\pip.ini or %USERPROFILE%\pip\pip.ini

# Virtual environment
# <venv>/pip.conf (Linux/macOS)
# <venv>\pip.ini (Windows)
```

### Configuration File Format
```ini
[global]
timeout = 60
index-url = https://pypi.org/simple
trusted-host = pypi.org
               files.pythonhosted.org

[install]
no-cache-dir = true
ignore-installed = true

[list]
format = columns
```

### Environment Variables
```bash
# Set custom index URL
export PIP_INDEX_URL=https://custom.pypi.org/simple

# Set timeout
export PIP_DEFAULT_TIMEOUT=60

# Disable cache
export PIP_NO_CACHE_DIR=1

# Set trusted host
export PIP_TRUSTED_HOST=custom.pypi.org
```

### pip Command Options
```bash
# Use specific index URL
pip install --index-url https://custom.pypi.org/simple package_name

# Add extra index URL
pip install --extra-index-url https://custom.pypi.org package_name

# Install without using cache
pip install --no-cache-dir package_name

# Install to user directory (no admin required)
pip install --user package_name

# Install to custom directory
pip install --target /path/to/dir package_name

# Set timeout
pip install --timeout 60 package_name

# Ignore installed packages (reinstall)
pip install --ignore-installed package_name
pip install -I package_name

# Force reinstall
pip install --force-reinstall package_name

# Disable binary packages (compile from source)
pip install --no-binary :all: package_name

# Only use binary packages
pip install --only-binary :all: package_name

# Install with verbose output
pip install -v package_name
pip install -vv package_name  # More verbose
pip install -vvv package_name  # Maximum verbosity

# Quiet mode
pip install -q package_name
```

## Best Practices

### Virtual Environment Management
```bash
# Always use virtual environments for projects
python -m venv .venv  # Common convention: .venv or venv

# Add .venv to .gitignore
echo ".venv/" >> .gitignore
echo "venv/" >> .gitignore

# Activate before working on project
source .venv/bin/activate

# Keep virtual environment in project root
project/
  ├── .venv/          # Virtual environment
  ├── src/            # Source code
  ├── tests/          # Tests
  └── requirements.txt
```

### Dependency Management
```bash
# Pin exact versions in production
pip freeze > requirements.txt

# Use version ranges for libraries
# requirements.in:
requests>=2.28.0,<3.0.0
Django>=4.2.0,<5.0.0

# Separate dev and prod dependencies
requirements/
  ├── base.txt
  ├── dev.txt
  └── prod.txt

# Use pip-tools for dependency management
pip install pip-tools
pip-compile requirements.in
pip-sync requirements.txt
```

### Security
```bash
# Check for security vulnerabilities
pip install safety
safety check

# Use pip-audit for auditing
pip install pip-audit
pip-audit

# Always upgrade pip
python -m pip install --upgrade pip
```

### Performance
```bash
# Use pip cache for faster installs
pip cache info
pip cache list
pip cache purge  # Clear cache if needed

# Install multiple packages in one command
pip install package1 package2 package3

# Use --no-deps to avoid dependency resolution
pip install --no-deps package_name
```

## Troubleshooting

### Common Issues

**Permission Denied:**
```bash
# Use --user flag
pip install --user package_name

# Or use virtual environment (recommended)
python -m venv myenv
source myenv/bin/activate
pip install package_name
```

**SSL Certificate Error:**
```bash
# Add trusted host
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org package_name

# Or upgrade certifi
pip install --upgrade certifi
```

**Conflicting Dependencies:**
```bash
# Check for conflicts
pip check

# View dependency tree
pip install pipdeptree
pipdeptree

# Create fresh virtual environment
deactivate
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

**Package Not Found:**
```bash
# Verify package name on PyPI
# https://pypi.org/

# Check for typos
pip search package_name  # (deprecated)

# Try upgrading pip
python -m pip install --upgrade pip
```

**Slow Installation:**
```bash
# Use --no-cache-dir if cache is large
pip install --no-cache-dir package_name

# Clear pip cache
pip cache purge

# Use binary packages
pip install --only-binary :all: package_name
```

**ImportError After Installation:**
```bash
# Verify installation
pip show package_name
pip list | grep package_name

# Check Python path
python -c "import sys; print(sys.path)"

# Ensure virtual environment is activated
which python  # Should show venv path
```

### Debug pip Issues
```bash
# Verbose output
pip install -vvv package_name

# Show pip configuration
pip config list

# Check pip version and location
pip --version
which pip

# Use python -m pip instead of pip command
python -m pip install package_name
```

## References

- [venv Documentation](https://docs.python.org/3/library/venv.html)
- [virtualenv Documentation](https://virtualenv.pypa.io/)
- [pip Documentation](https://pip.pypa.io/)
- [PyPI - Python Package Index](https://pypi.org/)
- [pip-tools](https://github.com/jazzband/pip-tools)
- [Python Packaging User Guide](https://packaging.python.org/)
