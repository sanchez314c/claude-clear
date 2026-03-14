# Project: Claude Clear

## Overview
Claude Clear is a Python utility that cleans bloated Claude Code configuration files by removing accumulated chat history and cache data while preserving user settings, API keys, and MCP configurations. The tool reduces typical 27MB configuration files to under 100KB, restoring Claude Code's performance.

## Tech Stack
- **Language**: Python 3.6+
- **CLI Framework**: Click 8.0+
- **Configuration**: PyYAML 6.0+
- **Platform**: macOS, Linux, Windows

## Development Commands

### Core Execution
```bash
# Run the cleaner directly
python src/cleaner.py

# Dry run to preview changes
python src/cleaner.py --dry-run

# Show version information
python src/cleaner.py --version

# Debug mode with verbose logging
python src/cleaner.py --debug
```

### Platform-Specific Launchers
```bash
# macOS launcher with enhanced UI
./run-cc-macos.sh

# Linux launcher
./run-cc-linux.sh

# Windows launcher
./run-source-windows.bat
```

### Build & Installation
```bash
# Install locally using Makefile
make install

# Development installation (editable)
make dev-install

# Build universal distribution package
./scripts/build-universal.sh

# Verify installation
./scripts/verify-install.sh

# Uninstall completely
make uninstall
```

### Testing & Quality
```bash
# Run tests using pytest
make test

# Manual test with pytest
python -m pytest tests/ -v

# Clean build artifacts
make clean
```

## Key Files

### Entry Points
- `bin/claude-clear.py` - Main CLI interface
- `src/cleaner.py` - Core cleanup logic

### Configuration Files
- `requirements.txt` - Production dependencies
- `requirements-dev.txt` - Development dependencies
- `Makefile` - Build tasks and installation

### Launch Scripts
- `run-cc-macos.sh` - macOS launcher (with enhanced UI)
- `run-cc-linux.sh` - Linux launcher (with enhanced UI)
- `run-source-linux.sh` - Linux source runner (simple)
- `run-source-mac.sh` - macOS source runner (simple)
- `run-source-windows.bat` - Windows launcher

### Documentation
- `README.md` - Project overview and quick start
- `AGENTS.md` - AI assistant guidance file (identical to this file)
- `CHANGELOG.md` - Version history
- `docs/` - Comprehensive documentation suite

## Architecture Overview

### Core Cleaning Process
The application targets `~/.claude.json` with intelligent data parsing:

```
Configuration Structure:
{
  "projects": {
    "project_id": {
      "history": [...],          # REMOVED - Largest component
      "conversation": [...],     # REMOVED - Chat data
      "messages": [...],         # REMOVED - Message buffers
      "settings": {...},         # PRESERVED - User preferences
      "mcp_configs": {...}       # PRESERVED - MCP configurations
    }
  },
  "globalHistory": [...],        # REMOVED - Global chat data
  "conversations": [...],        # REMOVED - Conversation cache
  "userSettings": {...}          # PRESERVED - Global settings
}
```

### Safety Mechanisms
1. **Backup Creation**: Timestamped backups before any modifications
2. **JSON Validation**: Validates file integrity before processing
3. **Size Thresholding**: Warns if file is already small (< 100KB)
4. **Dry Run Mode**: Preview changes without execution
5. **Selective Preservation**: Protects critical user data

### Cleaning Algorithm
```python
# Process flow:
1. Validate ~/.claude.json exists and is readable JSON
2. Create timestamped backup (.json.backup.YYYYMMDD_HHMMSS)
3. Parse configuration and identify chat-related fields
4. Clear project-level history and conversation data
5. Clear global chat caches and conversation buffers
6. Preserve user settings, API keys, and MCP configurations
7. Write cleaned configuration with proper JSON formatting
8. Report size reduction and statistics
```

## Target Data Fields

### Project-Level Fields (Removed)
- `history` - Project chat history
- `conversation` - Conversation logs
- `messages` - Message buffers
- `chat`, `conversations` - Alternative chat fields
- `messageHistory`, `chatHistory` - History variants
- `contextCache` - Cached conversation context

### Global-Level Fields (Removed)
- `globalHistory` - Global chat history
- `globalMessages` - Global message cache
- `conversations` - Conversation storage
- `recentConversations` - Recent conversation cache
- `conversationCache` - Conversation context cache
- `chatCache` - Chat data cache

### Preserved Data
These fields are never modified or removed:
- User settings and preferences
- API keys and authentication tokens
- MCP (Model Context Protocol) configurations
- Workspace and project metadata
- Tool configurations and customizations

## Important Notes

### Configuration Location
The tool specifically targets `~/.claude.json` - the standard Claude Code configuration location. This path is hardcoded and should not be changed without updating all references.

### Data Privacy
- All processing happens locally on the user's machine
- No data is transmitted or stored externally
- Backup files are created in the same directory as the original
- Users can restore from backups at any time

### Platform Compatibility
- **macOS**: Full support with enhanced terminal UI
- **Linux**: Full support with standard terminal output
- **Windows**: Support via batch launcher scripts

### Performance Considerations
- Large configuration files (>25MB) may take several seconds to process
- Memory usage scales with file size during JSON parsing
- Backup creation doubles disk space usage temporarily
- Cleaning operation is I/O bound for large files

## Installation

### Standard Install
```bash
git clone https://github.com/sanchez314c/claude-clear.git
cd claude-clear
./install.sh
```

### Enhanced Install (Recommended)
```bash
./install-enhanced.sh
```

### Verify Installation
```bash
./verify-install.sh
```

## Development Patterns

### Color Output System
The application uses a consistent color scheme for terminal output:
```python
class Colors:
    RED = '\033[0;31m'      # Errors and warnings
    GREEN = '\033[0;32m'    # Success messages
    YELLOW = '\033[1;33m'   # Caution messages
    BLUE = '\033[0;34m'     # Informational messages
    PURPLE = '\033[0;35m'   # UI elements and banners
    CYAN = '\033[0;36m'     # Statistics and data
    WHITE = '\033[1;37m'    # Important text
    GRAY = '\033[0;37m'     # Secondary information
    NC = '\033[0m'          # No Color (reset)
```

### File Safety Patterns
Always create backups before modification:
```python
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
backup_path = claude_json_path.with_suffix(f'.json.backup.{timestamp}')

# Create backup
with open(backup_path, 'w') as f:
    json.dump(original_data, f, indent=2)
```

## Troubleshooting

Common issues and solutions:

1. **Permission denied errors**
   - Don't use sudo - Claude Clear installs in user space only
   - Check if `/usr/local/bin` exists and is writable

2. **Command not found after install**
   - Restart your terminal or run: `source ~/.zshrc`
   - Try: `~/claude-clear/claude-clear` directly

3. **Python not found**
   - Install Python 3: `brew install python3`
   - Or download from https://python.org

4. **Claude config not found**
   - Run Claude Code at least once first
   - Check location: `find ~ -name ".claude.json" 2>/dev/null`

## Project Metadata

- **Author**: J. Michaels (sanchez314c)
- **Repository**: https://github.com/sanchez314c/claude-clear
- **License**: MIT
- **Version**: 1.0.0
