# Installation Guide

## Overview

Claude Clear can be installed using multiple methods depending on your use case and platform. This guide covers all installation options from local development to production deployment.

## Prerequisites

### System Requirements
- **Python**: 3.8 or higher
- **Operating System**: macOS, Linux, or Windows
- **Disk Space**: 10MB free space for backups
- **Permissions**: Read/write access to `~/.claude.json`

### Verify Python Installation
```bash
python --version
# or
python3 --version

# Should show Python 3.8.x or higher
```

## Installation Methods

### Method 1: pip Installation (Recommended)

#### Standard Installation
```bash
# Install from PyPI
pip install claude-clear

# Verify installation
claude-clear --version
```

#### Development Installation
```bash
# Install in development mode
pip install -e .

# Or from GitHub
pip install -e git+https://github.com/your-org/claude-clear.git
```

### Method 2: Source Installation

#### Clone and Install
```bash
# Clone repository
git clone https://github.com/your-org/claude-clear.git
cd claude-clear

# Create virtual environment (recommended)
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt

# Install package
pip install .
```

#### Using Makefile
```bash
# Standard installation
make install

# Development installation (editable)
make dev-install

# Clean build artifacts
make clean
```

### Method 3: Install Script

#### Automated Installation
```bash
# Download and run install script
curl -fsSL https://raw.githubusercontent.com/your-org/claude-clear/main/scripts/install.sh | bash

# Or download first
wget https://raw.githubusercontent.com/your-org/claude-clear/main/scripts/install.sh
chmod +x install.sh
./install.sh
```

#### Install Script Options
```bash
# Local installation only
./scripts/install.sh --local

# Install with service integration
./scripts/install.sh --service

# Development installation
./scripts/install.sh --dev

# Custom installation prefix
./scripts/install.sh --prefix=/usr/local
```

### Method 4: Distribution Package

#### Download Universal Package
```bash
# Build distribution package
./scripts/build-universal.sh

# This creates: claude-clear-v1.0.0-universal.tar.gz

# Extract and install
tar -xzf claude-clear-v1.0.0-universal.tar.gz
cd claude-clear-v1.0.0
./install.sh
```

## Platform-Specific Instructions

### macOS

#### Installation Options

**Option 1: pip (Recommended)**
```bash
pip install claude-clear
```

**Option 2: Homebrew**
```bash
# If available in Homebrew
brew install claude-clear

# Or tap
brew tap your-org/claude-clear
brew install claude-clear
```

**Option 3: MacPorts**
```bash
sudo port install claude-clear
```

#### Service Integration
```bash
# Install as LaunchAgent
./scripts/install.sh --service

# Manual LaunchAgent setup
cp scripts/com.claudeclear.daily.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claudeclear.daily.plist
```

#### Verification
```bash
# Verify installation
./scripts/verify-install.sh

# Test execution
./run-cc-macos.sh --dry-run
```

### Linux

#### Distribution-Specific Installation

**Ubuntu/Debian:**
```bash
# Using apt (if package available)
sudo apt-get update
sudo apt-get install claude-clear

# Using pip
pip install claude-clear
```

**CentOS/RHEL/Fedora:**
```bash
# Using yum/dnf
sudo yum install claude-clear
# or
sudo dnf install claude-clear

# Using pip
pip install claude-clear
```

**Arch Linux:**
```bash
# Using AUR (if available)
yay -S claude-clear

# Using pip
pip install claude-clear
```

#### Service Integration
```bash
# Install as systemd service
sudo ./scripts/install.sh --service

# Manual systemd setup
sudo cp scripts/claude-clear.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable claude-clear
sudo systemctl start claude-clear
```

#### Cron Job Setup
```bash
# Add to crontab
crontab -e

# Add line for daily execution at 2 AM
0 2 * * * /usr/local/bin/run-cc-linux.sh
```

### Windows

#### Installation Options

**Option 1: pip (Recommended)**
```powershell
# Install using pip
pip install claude-clear

# Verify installation
claude-clear --version
```

**Option 2: Executable Installer**
```powershell
# Download installer from GitHub releases
# Run installer with administrator privileges
# Follow installation wizard
```

**Option 3: Chocolatey**
```powershell
# If available in Chocolatey
choco install claude-clear
```

#### PATH Configuration
```powershell
# Add to PATH if not automatically added
# System Properties > Advanced > Environment Variables
# Add: C:\Python39\Scripts and C:\Python39
```

#### Task Scheduler Setup
```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "python" -Argument "src\cleaner.py" -WorkingDirectory "C:\path\to\claude-clear"
$trigger = New-ScheduledTaskTrigger -Daily -At 2AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Claude Clear Daily"
```

## Virtual Environment Setup

### Using venv
```bash
# Create virtual environment
python -m venv claude-clear-env

# Activate environment
source claude-clear-env/bin/activate  # Linux/macOS
claude-clear-env\Scripts\activate   # Windows

# Install Claude Clear
pip install claude-clear

# Deactivate when done
deactivate
```

### Using conda
```bash
# Create conda environment
conda create -n claude-clear python=3.9
conda activate claude-clear

# Install Claude Clear
pip install claude-clear

# Deactivate when done
conda deactivate
```

### Using pipenv
```bash
# Install pipenv if not already installed
pip install pipenv

# Create Pipfile and install dependencies
pipenv install

# Activate shell
pipenv shell

# Install Claude Clear
pip install claude-clear
```

## Configuration

### Environment Variables
```bash
# Optional configuration
export CLAUDE_CLEAR_CONFIG_PATH="/custom/path/.claude.json"
export CLAUDE_CLEAR_BACKUP_DIR="/custom/backup/location"
export CLAUDE_CLEAR_LOG_LEVEL="INFO"
export CLAUDE_CLEAR_DRY_RUN="false"
```

### Configuration File
```yaml
# Create ~/.claude-clear/config.yml
general:
  backup_count: 5
  dry_run: false
  debug: false
  
paths:
  claude_config: "~/.claude.json"
  backup_dir: "~/.claude-clear/backups"
  log_file: "~/.claude-clear/logs/cleaner.log"
  
cleaning:
  size_threshold_kb: 100
  preserve_fields:
    - "userSettings"
    - "projects.*.settings"
    - "projects.*.mcp_configs"
```

## Verification

### Basic Verification
```bash
# Check installation
claude-clear --version

# Test dry run
claude-clear --dry-run

# Check help
claude-clear --help
```

### Comprehensive Verification
```bash
# Run verification script
./scripts/verify-install.sh

# Test all components
python -m pytest tests/ -v

# Check dependencies
pip list | grep claude-clear
```

### Platform-Specific Testing
```bash
# macOS
./run-cc-macos.sh --debug

# Linux
./run-cc-linux.sh --debug

# Windows
python src\cleaner.py --debug
```

## Troubleshooting

### Common Installation Issues

**Issue: "python: command not found"**
```bash
# Try python3
python3 --version

# Or install Python
# macOS: brew install python
# Ubuntu: sudo apt-get install python3
# Windows: Download from python.org
```

**Issue: "Permission denied"**
```bash
# Use user installation
pip install --user claude-clear

# Or use sudo (Linux/macOS)
sudo pip install claude-clear

# Windows: Run PowerShell as Administrator
```

**Issue: "SSL certificate verification failed"**
```bash
# Update pip
pip install --upgrade pip

# Or disable SSL verification (not recommended)
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org claude-clear
```

**Issue: "Virtual environment activation fails"**
```bash
# Ensure bash/zsh is used
bash -c "source venv/bin/activate"

# Windows: Use PowerShell
.\venv\Scripts\Activate.ps1

# Or use Python directly
venv/bin/python src/cleaner.py
```

### Post-Installation Issues

**Issue: "claude-clear: command not found"**
```bash
# Check if Python Scripts directory is in PATH
echo $PATH | grep python

# Add to PATH (Linux/macOS)
export PATH="$HOME/.local/bin:$PATH"

# Add to PATH (Windows)
set PATH=%PATH%;C:\Python39\Scripts

# Or use Python directly
python -m claude_clear
```

**Issue: "ModuleNotFoundError"**
```bash
# Reinstall package
pip uninstall claude-clear
pip install claude-clear

# Or install in development mode
pip install -e .
```

**Issue: "Configuration not found"**
```bash
# Run Claude Code first to create configuration
# Or create dummy configuration for testing
mkdir -p ~/.claude
echo '{"projects": {}, "userSettings": {}}' > ~/.claude.json
```

## Uninstallation

### Using pip
```bash
pip uninstall claude-clear
```

### Using Makefile
```bash
make uninstall
```

### Manual Cleanup
```bash
# Remove package files
rm -rf ~/.claude-clear
rm -f /usr/local/bin/run-cc-*
rm -f /usr/local/bin/claude-clear

# Remove service files
sudo rm -f /etc/systemd/system/claude-clear.service
rm -f ~/Library/LaunchAgents/com.claudeclear.daily.plist
```

## Next Steps

After installation:

1. **Verify Installation**: Run `claude-clear --version`
2. **Test Dry Run**: Execute `claude-clear --dry-run`
3. **Configure Automation**: Set up cron/launch agent if desired
4. **Read Documentation**: Check `docs/` for advanced usage

For additional help, see:
- [FAQ.md](FAQ.md) for common questions
- [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for detailed troubleshooting
- [GitHub Issues](https://github.com/your-org/claude-clear/issues) for support