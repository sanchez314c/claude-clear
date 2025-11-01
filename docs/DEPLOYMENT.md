# Deployment Documentation

## Overview

Claude Clear is distributed as a Python package with multiple deployment options ranging from local installation to system-wide service integration.

## Deployment Options

### 1. Local Development Installation

**Use Case**: Development and testing on local machine

```bash
# Clone repository
git clone https://github.com/your-org/claude-clear.git
cd claude-clear

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Install in development mode
make dev-install
# or
pip install -e .

# Run directly
python src/cleaner.py
```

### 2. System-Wide Installation

**Use Case**: Production deployment for regular use

```bash
# Using Makefile
make install

# Using install script
./scripts/install.sh

# Manual installation
pip install .
```

### 3. Distribution Package

**Use Case**: Deploying to multiple machines or offline installation

```bash
# Build universal distribution package
./scripts/build-universal.sh

# This creates:
# claude-clear-v1.0.0-universal.tar.gz
# Contains all dependencies and platform scripts
```

### 4. Container Deployment

**Use Case**: Isolated deployment or CI/CD integration

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ ./src/
COPY bin/ ./bin/

ENTRYPOINT ["python", "src/cleaner.py"]
```

## Platform-Specific Deployment

### macOS

#### Installation Options

```bash
# Option 1: Direct installation
./scripts/install.sh

# Option 2: Homebrew (if available)
brew install claude-clear

# Option 3: Manual setup
python -m pip install claude-clear
```

#### Service Integration

```bash
# Install as LaunchAgent for automatic execution
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

#### Installation Options

```bash
# Option 1: Package manager (if available)
apt-get install claude-clear
# or
yum install claude-clear

# Option 2: pip installation
pip install claude-clear

# Option 3: Source installation
./scripts/install.sh
```

#### Service Integration

```bash
# Install as systemd service
sudo ./scripts/install.sh --service

# Manual systemd setup
sudo cp scripts/claude-clear.service /etc/systemd/system/
sudo systemctl enable claude-clear
sudo systemctl start claude-clear
```

#### Cron Job Setup

```bash
# Add to crontab for daily execution
crontab -e

# Add line:
0 2 * * * /usr/local/bin/run-cc-linux.sh
```

### Windows

#### Installation Options

```powershell
# Option 1: pip installation
pip install claude-clear

# Option 2: Executable installer
# Download claude-clear-installer.exe from releases
# Run installer with administrator privileges

# Option 3: Manual setup
git clone https://github.com/your-org/claude-clear.git
cd claude-clear
pip install -r requirements.txt
```

#### Task Scheduler Setup

```powershell
# Create scheduled task
$action = New-ScheduledTaskAction -Execute "python" -Argument "src\cleaner.py" -WorkingDirectory "C:\path\to\claude-clear"
$trigger = New-ScheduledTaskTrigger -Daily -At 2AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Claude Clear Daily"
```

## Configuration Management

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
# ~/.claude-clear/config.yml
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

## CI/CD Integration

### GitHub Actions

```yaml
name: Claude Clear Maintenance

on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM
  workflow_dispatch:

jobs:
  clean-claude-config:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          
      - name: Install Claude Clear
        run: |
          pip install claude-clear
          
      - name: Run Cleaner
        run: |
          claude-clear --dry-run
          # Add actual execution in production
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    triggers {
        cron('0 2 * * *')
    }
    
    stages {
        stage('Setup') {
            steps {
                sh 'pip install claude-clear'
            }
        }
        
        stage('Clean Configuration') {
            steps {
                sh 'claude-clear --dry-run'
                // Add actual execution with proper credentials
            }
        }
    }
}
```

## Monitoring and Logging

### Log Configuration

```python
# logging_config.py
LOGGING_CONFIG = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
        },
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '~/.claude-clear/logs/cleaner.log',
            'maxBytes': 10485760,  # 10MB
            'backupCount': 5,
            'formatter': 'standard',
        },
        'console': {
            'level': 'INFO',
            'class': 'logging.StreamHandler',
            'formatter': 'standard',
        },
    },
    'loggers': {
        'claude_clear': {
            'handlers': ['file', 'console'],
            'level': 'INFO',
            'propagate': False,
        },
    }
}
```

### Health Checks

```bash
# Health check script
#!/bin/bash
# health-check.sh

CLAUDE_CONFIG="$HOME/.claude.json"
BACKUP_DIR="$HOME/.claude-clear/backups"

# Check if configuration exists
if [ ! -f "$CLAUDE_CONFIG" ]; then
    echo "ERROR: Claude configuration not found"
    exit 1
fi

# Check backup directory
if [ ! -d "$BACKUP_DIR" ]; then
    echo "WARNING: Backup directory not found"
fi

# Check configuration size
CONFIG_SIZE=$(du -k "$CLAUDE_CONFIG" | cut -f1)
if [ "$CONFIG_SIZE" -gt 1024 ]; then  # > 1MB
    echo "WARNING: Configuration file is large ($CONFIG_SIZE KB)"
fi

echo "Health check completed"
```

## Rollback Procedures

### Backup Restoration

```bash
# List available backups
ls -la ~/.claude.json.backup.*

# Restore from specific backup
cp ~/.claude.json.backup.20231031_143022 ~/.claude.json

# Verify restored configuration
python src/cleaner.py --dry-run
```

### Complete Uninstallation

```bash
# Using Makefile
make uninstall

# Manual uninstallation
pip uninstall claude-clear
rm -rf ~/.claude-clear
rm -f /usr/local/bin/run-cc-*
```

## Security Considerations

### File Permissions

```bash
# Secure configuration file
chmod 600 ~/.claude.json

# Secure backup directory
chmod 700 ~/.claude-clear/backups

# Secure executable scripts
chmod 755 run-cc-*.sh
```

### Access Control

```bash
# Run as non-root user
sudo -u claude-clear ./run-cc-linux.sh

# Restrict execution to specific users
chown claude-clear:claude-clear /usr/local/bin/run-cc-*
chmod 750 /usr/local/bin/run-cc-*
```

## Performance Optimization

### Resource Limits

```bash
# Set memory limits for large configurations
ulimit -v 1048576  # 1GB virtual memory limit

# Set timeout for execution
timeout 300 ./run-cc-linux.sh  # 5 minute timeout
```

### Parallel Processing

```python
# Configuration for parallel processing
PARALLEL_CONFIG = {
    'max_workers': 4,
    'chunk_size': 1000,
    'enable_parallel': True
}
```

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   # Fix permissions
   chmod 755 ~/.claude-clear
   chmod +x run-cc-*.sh
   ```

2. **Python Path Issues**
   ```bash
   # Ensure Python in PATH
   which python
   export PATH="/usr/local/bin:$PATH"
   ```

3. **Dependency Conflicts**
   ```bash
   # Use virtual environment
   python -m venv claude-clear-env
   source claude-clear-env/bin/activate
   pip install -r requirements.txt
   ```

### Debug Mode

```bash
# Enable debug output
./run-cc-linux.sh --debug

# Check logs
tail -f ~/.claude-clear/logs/cleaner.log
```

## Version Management

### Upgrade Procedure

```bash
# Check current version
python src/cleaner.py --version

# Upgrade to latest
pip install --upgrade claude-clear

# Or from source
git pull origin main
make install
```

### Version Compatibility

| Version | Python Support | Claude Code Support |
|---------|----------------|-------------------|
| 1.0.x   | 3.8+          | All versions      |
| 1.1.x   | 3.9+          | All versions      |
| 2.0.x   | 3.10+         | v1.0+            |