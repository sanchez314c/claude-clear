# Frequently Asked Questions

## General Questions

### Q: What is Claude Clear?
**A**: Claude Clear is a Python utility that cleans bloated Claude Code configuration files by removing accumulated chat history and cache data while preserving user settings, API keys, and MCP configurations.

### Q: How much space can Claude Clear save?
**A**: Claude Clear typically reduces 27MB configuration files to under 100KB, saving approximately 99.6% of the file size.

### Q: Is Claude Clear safe to use?
**A**: Yes. Claude Clear creates timestamped backups before making any changes, validates JSON integrity, and only removes chat-related data while preserving all essential configurations.

## Installation and Setup

### Q: How do I install Claude Clear?
**A**: 
```bash
# Option 1: Using pip
pip install claude-clear

# Option 2: From source
git clone https://github.com/your-org/claude-clear.git
cd claude-clear
make install

# Option 3: Using install script
./scripts/install.sh
```

### Q: What are the system requirements?
**A**: 
- Python 3.8 or higher
- 10MB free disk space for backups
- Read/write access to `~/.claude.json`
- macOS, Linux, or Windows

### Q: Do I need to uninstall Claude Code to use Claude Clear?
**A**: No. Claude Clear works alongside Claude Code and can be used while Claude Code is running.

## Usage and Operation

### Q: How do I run Claude Clear?
**A**: 
```bash
# Basic usage
python src/cleaner.py

# Platform-specific launchers
./run-cc-macos.sh    # macOS
./run-cc-linux.sh    # Linux

# Preview changes without executing
python src/cleaner.py --dry-run
```

### Q: What data gets removed?
**A**: Claude Clear removes:
- Project chat history (`projects.*.history`)
- Conversation logs (`projects.*.conversation`)
- Message buffers (`projects.*.messages`)
- Global chat caches (`globalHistory`, `conversations`)
- Temporary conversation data

### Q: What data gets preserved?
**A**: Claude Clear preserves:
- User settings and preferences
- API keys and authentication tokens
- MCP (Model Context Protocol) configurations
- Workspace and project metadata
- Tool configurations and customizations

### Q: How often should I run Claude Clear?
**A**: It depends on your usage:
- Light users: Monthly
- Regular users: Weekly
- Heavy users: Daily or every few days

You can also set up automatic execution via cron or launch agents.

## Backup and Recovery

### Q: Does Claude Clear create backups?
**A**: Yes. Claude Clear automatically creates timestamped backups before making any changes. Backups are named `~/.claude.json.backup.YYYYMMDD_HHMMSS`.

### Q: How do I restore from a backup?
**A**: 
```bash
# List available backups
ls -la ~/.claude.json.backup.*

# Restore from specific backup
cp ~/.claude.json.backup.20231031_143022 ~/.claude.json
```

### Q: How many backups are kept?
**A**: Claude Clear keeps all backups by default. You can manually clean up old backups or configure automatic cleanup.

## Troubleshooting

### Q: I get "Permission denied" error
**A**: Check file permissions:
```bash
# Fix permissions on configuration file
chmod 600 ~/.claude.json

# Fix permissions on backup directory
chmod 700 ~/.claude-clear/backups
```

### Q: Claude Clear says "Configuration not found"
**A**: This means Claude Code hasn't been run yet or the configuration is in a different location. Run Claude Code first to create the configuration file.

### Q: The tool reports "Invalid JSON format"
**A**: Your Claude Code configuration may be corrupted. Try:
```bash
# Validate JSON syntax
python -m json.tool ~/.claude.json > /dev/null

# If corrupted, restore from backup
cp ~/.claude.json.backup.LATEST ~/.claude.json
```

### Q: No space is saved after cleaning
**A**: This can happen if:
- Configuration file is already small (< 100KB)
- Most data consists of settings (not chat history)
- Claude Code is configured to store history elsewhere

Run with `--debug` flag to see detailed analysis.

## Advanced Usage

### Q: Can I automate Claude Clear?
**A**: Yes. Here are some options:

**Cron Job (Linux/macOS):**
```bash
# Edit crontab
crontab -e

# Add daily execution at 2 AM
0 2 * * * /path/to/claude-clear/run-cc-linux.sh
```

**LaunchAgent (macOS):**
```bash
# Install as service
./scripts/install.sh --service
```

**Windows Task Scheduler:**
```powershell
# Create scheduled task via GUI or PowerShell
$action = New-ScheduledTaskAction -Execute "python" -Argument "src\cleaner.py"
$trigger = New-ScheduledTaskTrigger -Daily -At 2AM
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Claude Clear"
```

### Q: Can I customize what gets cleaned?
**A**: Currently, Claude Clear uses predefined rules for safety. Future versions may support custom cleaning rules via configuration files.

### Q: How do I run in debug mode?
**A**: 
```bash
python src/cleaner.py --debug
```

This provides detailed information about:
- File analysis
- Field identification
- Size calculations
- Cleaning operations

## Integration and Compatibility

### Q: Does Claude Clear work with all Claude Code versions?
**A**: Claude Clear is designed to work with all current Claude Code versions. If you encounter compatibility issues, please report them.

### Q: Can I use Claude Clear in a CI/CD pipeline?
**A**: Yes. Claude Clear can be integrated into CI/CD pipelines for automated maintenance:

```yaml
# GitHub Actions example
- name: Clean Claude Configuration
  run: |
    pip install claude-clear
    claude-clear --dry-run
```

### Q: Is Claude Clear open source?
**A**: Yes. Claude Clear is open source and available on GitHub. Contributions are welcome!

## Performance and Resources

### Q: How long does cleaning take?
**A**: 
- Small files (< 1MB): < 1 second
- Medium files (1-10MB): 1-5 seconds
- Large files (> 10MB): 5-30 seconds

### Q: How much memory does Claude Clear use?
**A**: Memory usage scales with file size:
- Small files: < 10MB
- Large files: 50-100MB during processing

### Q: Does Claude Clear affect Claude Code performance?
**A**: No. Claude Clear only operates when explicitly run and doesn't interfere with Claude Code's normal operation.

## Security and Privacy

### Q: Does Claude Clear send data anywhere?
**A**: No. All processing happens locally on your machine. No data is transmitted or stored externally.

### Q: Are my API keys safe?
**A**: Yes. Claude Clear preserves all API keys and authentication tokens. They are never removed or modified.

### Q: Can Claude Clear access my chat history?
**A**: Claude Clear only reads the local configuration file to identify and remove chat history. It doesn't access or transmit chat content.

## Development and Contributing

### Q: How can I contribute to Claude Clear?
**A**: 
1. Fork the repository on GitHub
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

See `CONTRIBUTING.md` for detailed guidelines.

### Q: How do I report bugs or request features?
**A**: 
- Bugs: Use the GitHub issue tracker with the "Bug Report" template
- Features: Use the "Feature Request" template
- Security issues: Email security@your-org.com

### Q: Is there a development version available?
**A**: Yes. You can install the development version:
```bash
pip install -e git+https://github.com/your-org/claude-clear.git@develop
```

## Miscellaneous

### Q: Where are configuration files stored?
**A**: 
- Main configuration: `~/.claude.json`
- Backups: `~/.claude.json.backup.*`
- Logs: `~/.claude-clear/logs/`
- Custom config: `~/.claude-clear/config.yml`

### Q: Can I use Claude Clear on multiple machines?
**A**: Yes, but each machine has its own Claude Code configuration. You'll need to install and run Claude Clear on each machine separately.

### Q: What's the difference between `--dry-run` and normal execution?
**A**: `--dry-run` shows what would be cleaned without making any changes. Normal execution performs the actual cleaning after creating backups.

### Q: How do I uninstall Claude Clear?
**A**: 
```bash
# Using pip
pip uninstall claude-clear

# Using Makefile
make uninstall

# Manual cleanup
rm -rf ~/.claude-clear
rm -f /usr/local/bin/run-cc-*
```

## Still Have Questions?

If your question isn't answered here, please:

1. Check the [documentation](docs/)
2. Search [existing issues](https://github.com/your-org/claude-clear/issues)
3. [Create a new issue](https://github.com/your-org/claude-clear/issues/new)
4. Email support@your-org.com for security concerns