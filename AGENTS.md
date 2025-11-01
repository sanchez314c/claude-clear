# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Claude Clear is a Python utility that cleans bloated Claude Code configuration files by removing accumulated chat history and cache data while preserving user settings, API keys, and MCP configurations. The tool reduces typical 27MB configuration files to under 100KB, restoring Claude Code's performance.

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

## Implementation Details

### Target Data Fields
The cleaner specifically removes these data structures:

**Project-Level Fields:**
- `history` - Project chat history
- `conversation` - Conversation logs
- `messages` - Message buffers
- `chat`, `conversations` - Alternative chat fields
- `messageHistory`, `chatHistory` - History variants
- `contextCache` - Cached conversation context

**Global-Level Fields:**
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

### Error Handling
```python
# JSON validation with detailed error messages
try:
    with open(claude_json_path, 'r') as f:
        data = json.load(f)
except json.JSONDecodeError as e:
    print(f"❌ Error: Invalid JSON in ~/.claude.json")
    print(f"   Details: {e}")
    return False

# File existence and permission checks
if not claude_json_path.exists():
    print("❌ ~/.claude.json not found")
    print("Claude Code might not be installed or has not been run yet")
    return False
```

## Installation & Distribution

### Local Installation
```bash
# Using the install script
./scripts/install.sh --local

# Using Makefile
make install

# Development mode (editable install)
make dev-install
```

### Distribution Package
The `build-universal.sh` script creates a complete distribution package with:
- Cross-platform launch scripts
- Dependency management
- Installation utilities
- Verification tools

### Service Integration
While the tool supports manual execution, it can also be installed as:
- **Automatic Service**: Runs every 24 hours
- **Manual Service**: On-demand execution via launch scripts
- **CLI Tool**: Direct Python execution

## Testing Strategy

### Test Structure
```bash
tests/
├── test_cleaner.py      # Core cleaning logic tests
├── test_backup.py       # Backup creation tests
├── test_validation.py   # JSON validation tests
└── fixtures/            # Test configuration files
```

### Test Execution
```bash
# Run all tests
make test

# Run specific test file
python -m pytest tests/test_cleaner.py -v

# Run with coverage
python -m pytest tests/ --cov=src/
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

### Argument Parsing
The CLI uses argparse with comprehensive help:
```python
parser.add_argument('--dry-run', action='store_true',
                   help='Show what would be cleaned without making changes')
parser.add_argument('--version', action='store_true',
                   help='Show version information')
parser.add_argument('--debug', action='store_true',
                   help='Enable debug output')
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