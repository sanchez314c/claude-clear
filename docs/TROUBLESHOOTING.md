# Troubleshooting Guide

This guide provides solutions to common issues encountered when using Claude Clear.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Runtime Errors](#runtime-errors)
- [Performance Issues](#performance-issues)
- [File System Issues](#file-system-issues)
- [Backup and Recovery](#backup-and-recovery)
- [Platform-Specific Issues](#platform-specific-issues)
- [Getting Help](#getting-help)

## Installation Issues

### Python Environment Not Found

**Problem**: `python: command not found` or Python version incompatible

**Solutions**:
```bash
# Check Python installation
python3 --version

# Install Python on macOS
brew install python3

# Install Python on Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# Use conda environment
conda create -n claude-clear python=3.8
conda activate claude-clear
```

### Permission Denied Errors

**Problem**: `Permission denied` when running installation scripts

**Solutions**:
```bash
# Make scripts executable
chmod +x scripts/install.sh
chmod +x run-cc-*.sh

# Install with user permissions
pip install --user -r requirements.txt

# Use virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Dependencies Fail to Install

**Problem**: `pip install` fails with dependency conflicts

**Solutions**:
```bash
# Upgrade pip first
pip install --upgrade pip

# Clean install with fresh environment
python3 -m venv fresh-env
source fresh-env/bin/activate
pip install -r requirements.txt

# Install specific versions if needed
pip install package==version
```

## Runtime Errors

### ~/.claude.json Not Found

**Problem**: `❌ ~/.claude.json not found`

**Solutions**:
```bash
# Check if Claude Code is installed
which claude

# Run Claude Code once to create config
claude --help

# Check config location
ls -la ~/.claude*

# Create empty config if needed
echo '{}' > ~/.claude.json
```

### JSON Parse Errors

**Problem**: `❌ Error: Invalid JSON in ~/.claude.json`

**Solutions**:
```bash
# Validate JSON syntax
python3 -m json.tool ~/.claude.json

# Find and fix syntax errors
# Common issues: trailing commas, missing quotes, mismatched brackets

# Restore from backup if available
ls ~/.claude.json.backup.*
cp ~/.claude.json.backup.LATEST ~/.claude.json
```

### Permission Denied on Config File

**Problem**: Cannot read or write `~/.claude.json`

**Solutions**:
```bash
# Check file permissions
ls -la ~/.claude.json

# Fix ownership (replace $USER with your username)
sudo chown $USER:$USER ~/.claude.json
chmod 644 ~/.claude.json

# Check directory permissions
ls -la ~/
chmod 755 ~/
```

## Performance Issues

### Slow Processing on Large Files

**Problem**: Cleaning takes too long on large configuration files

**Solutions**:
```bash
# Check file size
du -h ~/.claude.json

# Use debug mode to identify bottlenecks
python src/cleaner.py --debug

# Monitor system resources
top -p $(pgrep -f cleaner.py)

# Consider manual cleanup for extremely large files
# Move old project histories manually
```

### Memory Usage Too High

**Problem**: System runs out of memory during cleaning

**Solutions**:
```bash
# Check available memory
free -h  # Linux
vm_stat  # macOS

# Use smaller chunks (if supported)
python src/cleaner.py --chunk-size 1000

# Close other applications
# Use system monitor to identify memory hogs
```

## File System Issues

### Disk Space Full

**Problem**: `No space left on device` error

**Solutions**:
```bash
# Check disk usage
df -h

# Clean temporary files
rm -rf /tmp/*
rm -rf ~/.cache/*

# Remove old backups
find ~ -name "*.backup.*" -mtime +30 -delete

# Clean package caches
pip cache purge
brew cleanup  # macOS
```

### Backup Creation Fails

**Problem**: Cannot create backup files

**Solutions**:
```bash
# Check disk space in home directory
df -h ~/

# Check write permissions
touch ~/.test_write
rm ~/.test_write

# Clean old backups
ls ~/.claude.json.backup.*
find ~ -name "*.backup.*" -mtime +7 -delete

# Use alternative backup location
export CLAUDE_CLEAR_BACKUP_DIR="/tmp/claude-backups"
```

## Backup and Recovery

### Restoring from Backup

**Problem**: Need to restore original configuration

**Solutions**:
```bash
# List available backups
ls -la ~/.claude.json.backup.*

# Restore latest backup
LATEST_BACKUP=$(ls -t ~/.claude.json.backup.* | head -1)
cp "$LATEST_BACKUP" ~/.claude.json

# Verify restored configuration
python3 -m json.tool ~/.claude.json > /dev/null && echo "JSON is valid"
```

### Backup Corrupted

**Problem**: Backup files are corrupted or invalid

**Solutions**:
```bash
# Check backup integrity
for backup in ~/.claude.json.backup.*; do
    echo "Checking $backup..."
    python3 -m json.tool "$backup" > /dev/null && echo "✅ Valid" || echo "❌ Invalid"
done

# Find the most recent valid backup
VALID_BACKUP=$(ls -t ~/.claude.json.backup.* | xargs -I {} sh -c 'python3 -m json.tool "{}" > /dev/null 2>&1 && echo "{}' | head -1)
cp "$VALID_BACKUP" ~/.claude.json
```

## Platform-Specific Issues

### macOS Issues

#### Gatekeeper Blocking Execution

**Problem**: "app cannot be opened because the developer cannot be verified"

**Solutions**:
```bash
# Allow app execution
xattr -d com.apple.quarantine run-cc-macos.sh

# Or allow for any downloaded app
sudo spctl --master-disable

# Install via proper channels
./scripts/install.sh --local
```

#### Python Path Issues

**Problem**: Wrong Python version being used

**Solutions**:
```bash
# Use specific Python version
/usr/bin/python3 src/cleaner.py

# Update PATH in ~/.zshrc or ~/.bash_profile
export PATH="/usr/local/bin:$PATH"

# Use pyenv for version management
pyenv install 3.9.0
pyenv global 3.9.0
```

### Linux Issues

#### Distribution-Specific Paths

**Problem**: Different Linux distributions have different Python paths

**Solutions**:
```bash
# Find Python executable
which python3
which python

# Use absolute paths
/usr/bin/python3 src/cleaner.py

# Create symlink if needed
sudo ln -s /usr/bin/python3 /usr/local/bin/python
```

#### SELinux Blocking Access

**Problem**: SELinux prevents access to configuration files

**Solutions**:
```bash
# Check SELinux status
sestatus

# Temporarily disable (not recommended for production)
sudo setenforce 0

# Set proper context
sudo semanage fcontext -a -t home_root_t "/home/[^/]+/.claude.json"
sudo restorecon ~/.claude.json
```

### Windows Issues

#### Path Separator Problems

**Problem**: Script fails due to path separator issues

**Solutions**:
```powershell
# Use Windows launcher
.\run-cc-windows.bat

# Or use Python directly
python src\cleaner.py

# Use WSL (Windows Subsystem for Linux)
wsl python src/cleaner.py
```

#### Permission Issues

**Problem**: Administrator privileges required

**Solutions**:
```powershell
# Run PowerShell as Administrator
# Or modify file permissions
icacls ~/.claude.json /grant "$($env:USERNAME):(F)"
```

## Getting Help

### Debug Mode

Enable debug mode for detailed troubleshooting:

```bash
python src/cleaner.py --debug
```

### Verbose Output

Get more information about what's happening:

```bash
python src/cleaner.py --verbose
```

### Dry Run Testing

Test what would happen without making changes:

```bash
python src/cleaner.py --dry-run
```

### Log Files

Check for log files that might contain error details:

```bash
# Check application logs
ls -la ~/.claude-clear/logs/
tail -f ~/.claude-clear/logs/cleaner.log

# Check system logs
journalctl -u claude-clear  # systemd
tail -f /var/log/syslog     # Linux syslog
```

### Community Support

If you're still having issues:

1. **Check the FAQ**: Review [FAQ.md](FAQ.md) for common questions
2. **Search Issues**: Look at [GitHub Issues](https://github.com/your-repo/claude-clear/issues)
3. **Create New Issue**: Include:
   - Operating system and version
   - Python version
   - Exact error message
   - Steps to reproduce
   - Debug output (if available)

### Reporting Bugs

When reporting bugs, provide this information:

```bash
# System information
uname -a
python3 --version
pip --version

# Claude Clear version
python src/cleaner.py --version

# Configuration file info
ls -la ~/.claude.json*
du -h ~/.claude.json

# Error reproduction
python src/cleaner.py --debug 2>&1 | tee debug.log
```

## Advanced Troubleshooting

### Manual Configuration Inspection

Inspect your configuration manually:

```bash
# View configuration structure
python3 -c "
import json
with open('~/.claude.json') as f:
    data = json.load(f)
print('Keys:', list(data.keys()))
print('Projects:', len(data.get('projects', {})))
"
```

### Performance Profiling

Profile the cleaning process:

```bash
# Use Python profiler
python -m cProfile -o profile.stats src/cleaner.py
python -c "
import pstats
p = pstats.Stats('profile.stats')
p.sort_stats('cumulative').print_stats(20)
"
```

### Memory Profiling

Check memory usage patterns:

```bash
# Install memory profiler
pip install memory-profiler

# Profile memory usage
python -m memory_profiler src/cleaner.py
```

---

## Emergency Procedures

### Configuration Completely Corrupted

If your configuration is completely corrupted:

1. **Stop Claude Code**: Ensure no Claude Code processes are running
2. **Move Corrupted File**: `mv ~/.claude.json ~/.claude.json.corrupted`
3. **Restore from Backup**: Use the most recent valid backup
4. **Verify Configuration**: Test with `python src/cleaner.py --dry-run`
5. **Contact Support**: If no valid backups exist

### System Recovery After Failed Cleaning

If cleaning causes system issues:

1. **Immediate Restore**: Restore from the most recent backup
2. **Check Permissions**: Verify file permissions are correct
3. **Validate Configuration**: Ensure JSON is valid
4. **Test Claude Code**: Verify Claude Code works properly
5. **Report Issue**: Document what went wrong for future fixes

---

*For issues not covered in this guide, please create an issue on GitHub or contact the maintainers.*