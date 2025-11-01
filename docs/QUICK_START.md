# Quick Start Guide

## Get Started in 5 Minutes

Claude Clear helps you clean bloated Claude Code configuration files in seconds. Follow this quick start to restore your Claude Code performance.

## 1. Installation

### Option A: pip Install (Recommended)
```bash
pip install claude-clear
```

### Option B: Source Install
```bash
git clone https://github.com/your-org/claude-clear.git
cd claude-clear
pip install .
```

## 2. First Run - Preview Changes

Always run with `--dry-run` first to see what will be cleaned:

```bash
claude-clear --dry-run
```

**Example Output:**
```
🔍 Claude Clear v1.0.0 - Dry Run Mode
📁 Configuration: /Users/alex/.claude.json
📊 Current size: 27.3 MB

🧹 Data to be removed:
   • Project chat history: 15.2 MB
   • Conversation cache: 8.1 MB
   • Message buffers: 3.7 MB
   • Global history: 0.3 MB

💾 Data to be preserved:
   • User settings and API keys
   • MCP configurations
   • Project metadata
   • Tool configurations

📈 Expected size after cleaning: ~85 KB (99.7% reduction)

💡 Run without --dry-run to execute cleaning
```

## 3. Execute Cleaning

Once you're satisfied with the preview, run the actual cleaning:

```bash
claude-clear
```

**Example Output:**
```
🧹 Claude Clear v1.0.0 - Starting cleanup
📁 Configuration: /Users/alex/.claude.json
💾 Creating backup: ~/.claude.json.backup.20231031_143022
✅ Backup created successfully

🔄 Processing configuration...
   ✅ Cleaned project chat history
   ✅ Cleaned conversation cache
   ✅ Cleaned message buffers
   ✅ Cleaned global history

📊 Results:
   • Original size: 27.3 MB
   • Cleaned size: 85 KB
   • Space saved: 27.2 MB (99.7% reduction)

✨ Claude Code configuration cleaned successfully!
🚀 Your Claude Code should now start much faster.
```

## 4. Verify Results

Check that Claude Code starts faster:

```bash
# Test Claude Code startup
time claude --help

# Verify backup was created
ls -la ~/.claude.json.backup.*
```

## Platform-Specific Commands

### macOS
```bash
# Use the enhanced launcher
./run-cc-macos.sh

# Install as automatic service
./scripts/install.sh --service
```

### Linux
```bash
# Use the Linux launcher
./run-cc-linux.sh

# Set up daily cron job
crontab -e
# Add: 0 2 * * * /path/to/claude-clear/run-cc-linux.sh
```

### Windows
```powershell
# Run directly
python src\cleaner.py

# Create scheduled task
# Open Task Scheduler and create daily task
```

## Common Usage Patterns

### Regular Maintenance
```bash
# Weekly cleaning
claude-clear

# Check if cleaning is needed
claude-clear --dry-run | grep "size after cleaning"
```

### Before Major Work
```bash
# Clean before important projects
claude-clear --debug
```

### Troubleshooting
```bash
# If Claude Code is slow
claude-clear --dry-run

# If something went wrong
ls -la ~/.claude.json.backup.*
cp ~/.claude.json.backup.LATEST ~/.claude.json
```

## Automation Setup

### Daily Automatic Cleaning

#### macOS (LaunchAgent)
```bash
# Install as service
./scripts/install.sh --service

# Manual setup
cp scripts/com.claudeclear.daily.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.claudeclear.daily.plist
```

#### Linux (Cron)
```bash
# Edit crontab
crontab -e

# Add daily execution at 2 AM
0 2 * * * /usr/local/bin/run-cc-linux.sh
```

#### Windows (Task Scheduler)
```powershell
# Create scheduled task via GUI or PowerShell
$action = New-ScheduledTaskAction -Execute "python" -Argument "src\cleaner.py"
$trigger = New-ScheduledTaskTrigger -Daily -At 2AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Claude Clear Daily"
```

## What Gets Cleaned?

### Removed Data
- ✅ Chat history in projects
- ✅ Conversation logs
- ✅ Message buffers
- ✅ Global chat cache
- ✅ Temporary conversation data

### Preserved Data
- 🔒 User settings and preferences
- 🔒 API keys and authentication
- 🔒 MCP configurations
- 🔒 Project metadata
- 🔒 Tool customizations

## Troubleshooting Quick Fixes

### "Permission Denied"
```bash
# Fix permissions
chmod 600 ~/.claude.json
chmod +x run-cc-*.sh
```

### "Configuration Not Found"
```bash
# Run Claude Code first to create config
claude --help

# Or check alternative location
find ~ -name ".claude.json" 2>/dev/null
```

### "Invalid JSON"
```bash
# Validate and restore from backup
python -m json.tool ~/.claude.json > /dev/null
cp ~/.claude.json.backup.LATEST ~/.claude.json
```

## Next Steps

1. **Set up automation** for regular cleaning
2. **Read the full documentation** at `docs/`
3. **Check FAQ.md** for common questions
4. **Configure custom settings** if needed

## Need Help?

- **Documentation**: See `docs/` directory
- **FAQ**: Check `FAQ.md` for common questions
- **Issues**: Report problems at GitHub Issues
- **Community**: Join discussions in GitHub Discussions

## One-Liner Summary

```bash
# Install and run in one command
pip install claude-clear && claude-clear --dry-run && claude-clear
```

That's it! Your Claude Code should now start significantly faster. 🚀