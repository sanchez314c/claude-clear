# API Documentation

## Overview

Claude Clear does not expose a traditional API for external consumption. The tool is designed as a command-line utility that operates on local Claude Code configuration files.

## Command-Line Interface

### Main Commands

```bash
# Run the cleaner with default settings
python src/cleaner.py

# Dry run to preview changes without execution
python src/cleaner.py --dry-run

# Display version information
python src/cleaner.py --version

# Enable debug mode with verbose logging
python src/cleaner.py --debug
```

### Platform-Specific Launchers

```bash
# macOS launcher with enhanced UI
./run-cc-macos.sh

# Linux launcher
./run-cc-linux.sh

# Windows launcher (if available)
./run-source-windows.bat
```

## Exit Codes

| Exit Code | Description |
|-----------|-------------|
| 0 | Success - Configuration cleaned successfully |
| 1 | Error - File not found or permission denied |
| 2 | Error - Invalid JSON format in configuration |
| 3 | Error - Configuration already below size threshold |
| 4 | Error - Backup creation failed |

## Configuration File Structure

Claude Clear operates on `~/.claude.json` with the following expected structure:

```json
{
  "projects": {
    "project_id": {
      "history": [...],
      "conversation": [...],
      "messages": [...],
      "settings": {...},
      "mcp_configs": {...}
    }
  },
  "globalHistory": [...],
  "conversations": [...],
  "userSettings": {...}
}
```

## Data Processing

### Fields Removed
- `projects.*.history`
- `projects.*.conversation`
- `projects.*.messages`
- `projects.*.chat`
- `projects.*.conversations`
- `projects.*.messageHistory`
- `projects.*.chatHistory`
- `projects.*.contextCache`
- `globalHistory`
- `globalMessages`
- `conversations`
- `recentConversations`
- `conversationCache`
- `chatCache`

### Fields Preserved
- `projects.*.settings`
- `projects.*.mcp_configs`
- `userSettings`
- API keys and authentication tokens
- Workspace and project metadata

## Error Handling

All errors are printed to stderr with descriptive messages:

```bash
❌ Error: ~/.claude.json not found
   Claude Code might not be installed or has not been run yet

❌ Error: Invalid JSON in ~/.claude.json
   Details: Expecting ',' delimiter: line 42 column 5 (char 1234)
```

## Integration Examples

### Cron Job (Linux/macOS)

```bash
# Add to crontab for daily execution at 2 AM
0 2 * * * /path/to/claude-clear/run-cc-linux.sh
```

### LaunchAgent (macOS)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claudeclear.daily</string>
    <key>ProgramArguments</key>
    <array>
        <string>/path/to/claude-clear/run-cc-macos.sh</string>
    </array>
    <key>StartInterval</key>
    <integer>86400</integer>
</dict>
</plist>
```

## Development API

### Python Module Usage

```python
from src.cleaner import ClaudeCleaner

# Create cleaner instance
cleaner = ClaudeCleaner()

# Run cleaning process
success = cleaner.clean()

# Check if cleaning is needed
needs_cleaning = cleaner.should_clean()
```

### Testing API

```python
from tests.test_cleaner import TestClaudeCleaner

# Run tests programmatically
test_suite = TestClaudeCleaner()
test_suite.test_clean_configuration()
test_suite.test_backup_creation()
test_suite.test_json_validation()
```