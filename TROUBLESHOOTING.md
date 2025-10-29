# Troubleshooting Guide

## Common Installation Issues

### 🚨 Permission Errors

**Problem**: `Permission denied` when creating directories or files
```bash
# Error: mkdir: /usr/local/bin: Permission denied
```

**Solutions**:
1. **Don't use sudo** - The installer is designed to work in user space only
2. **Check if /usr/local/bin exists**:
   ```bash
   ls -la /usr/local/bin
   ```
3. **Create missing directories**:
   ```bash
   mkdir -p ~/bin  # Alternative if /usr/local/bin is restricted
   ```

### 🐍 Python Issues

**Problem**: `python3: command not found`
```bash
# On macOS, you might need to use python3 instead of python
```

**Solutions**:
1. **Install Python**:
   - Using Homebrew: `brew install python3`
   - Download from: https://python.org

2. **Check Python installation**:
   ```bash
   which python3
   python3 --version
   ```

3. **Alternative: Use system Python on macOS**:
   ```bash
   /usr/bin/python3 --version
   ```

### 📂 Path Issues

**Problem**: Script can't find Claude configuration
```bash
# Error: No such file or directory: ~/.claude.json
```

**Solutions**:
1. **Claude Code might not be installed** - Install Claude Code first
2. **Check configuration location**:
   ```bash
   find ~ -name ".claude.json" -type f 2>/dev/null
   ```
3. **Manual configuration** - Run Claude Code once to create the config

### 🔧 Service Installation Issues

**Problem**: `launchctl: Could not find service`

**Solutions**:
1. **Check LaunchAgent directory**:
   ```bash
   ls -la ~/Library/LaunchAgents/
   ```

2. **Manual service loading**:
   ```bash
   launchctl load ~/Library/LaunchAgents/com.claude.cleanup.plist
   ```

3. **Check service status**:
   ```bash
   launchctl list | grep claude
   ```

### 🖥️ Shell Configuration Issues

**Problem**: `claude-clear: command not found` after installation

**Solutions**:
1. **Check which shell you're using**:
   ```bash
   echo $SHELL
   ```

2. **Reload shell configuration**:
   ```bash
   # For Zsh (default on macOS)
   source ~/.zshrc

   # For Bash
   source ~/.bash_profile
   ```

3. **Manual PATH addition**:
   ```bash
   echo 'export PATH="$PATH:'$HOME'/.claude-clear"' >> ~/.zshrc
   ```

### 📱 M1/M2/M3 Mac Specific Issues

**Problem**: Rosetta compatibility or architecture issues

**Solutions**:
1. **Check architecture**:
   ```bash
   uname -m
   ```

2. **Install Rosetta 2 if needed**:
   ```bash
   softwareupdate --install-rosetta --agree-to-license
   ```

### 🔄 Backup and Restore

**If something goes wrong**:

1. **Restore from backup**:
   ```bash
   # List available backups
   ls -la ~/.claude.json.backup.*

   # Restore latest backup
   cp ~/.claude.json.backup.LATEST ~/.claude.json
   ```

2. **Check logs**:
   ```bash
   cat ~/.claude-clear/logs/cleanup.log
   cat ~/.claude-clear/logs/error.log
   ```

### 🐛 Debug Mode

**Enable verbose logging**:
```bash
# Run with debug output
python3 ~/.claude-clear/src/cleaner.py --debug
```

### 📝 Environment Variables

**Override default paths**:
```bash
export CLAUDE_CLEAR_DIR="/custom/path"
export CLAUDE_CONFIG_FILE="/custom/.claude.json"
```

### 🔍 Manual Installation

**If the installer fails**:

1. **Create directories manually**:
   ```bash
   mkdir -p ~/.claude-clear/{bin,src,logs}
   ```

2. **Copy files manually**:
   ```bash
   cp -r /path/to/claude-clear/* ~/.claude-clear/
   ```

3. **Create symlink manually**:
   ```bash
   ln -s ~/.claude-clear/claude-clear ~/bin/claude-clear
   ```

## Platform-Specific Notes

### macOS
- Requires macOS 10.14 (Mojave) or later
- Python 3.7+ required
- launchctl used for automatic cleaning

### Linux (Not officially supported)
- Use cron instead of launchctl
- Different paths for binaries
- Package manager differences

### Windows (Not supported)
- WSL might work with modifications
- Different service management
- Path separators need changes

## Getting Help

If you encounter issues not covered here:

1. **Check the logs**: `~/.claude-clear/logs/`
2. **Create an issue**: https://github.com/yourusername/claude-clear/issues
3. **Include system information**:
   ```bash
   # For bug reports
   echo "OS: $(uname -s)"
   echo "Shell: $SHELL"
   echo "Python: $(python3 --version 2>/dev/null || echo 'Not found')"
   echo "Claude Clear: $(claude-clear --version 2>/dev/null || echo 'Not installed')"
   ```

## Uninstallation Issues

**If uninstall.sh doesn't work**:
```bash
# Manual cleanup
rm -rf ~/.claude-clear
rm ~/Library/LaunchAgents/com.claude.cleanup.plist
launchctl remove com.claude.cleanup 2>/dev/null || true

# Remove from shell configs
sed -i '' '/.claude-clear/d' ~/.zshrc ~/.bash_profile 2>/dev/null || true
```