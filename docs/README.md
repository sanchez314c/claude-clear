# 🧹 Claude Clear

> Automatically clean Claude Code's bloated configuration file, restoring performance

Claude Clear removes accumulated chat history and cache data from Claude Code's configuration, reducing a typical 27MB file to under 100KB while preserving all your settings and API keys.

## ⚡ Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/claude-clear/main/install.sh | bash
```

## 📋 Requirements

- **macOS** (10.14 Mojave or later)
- **Python 3.6+** (pre-installed on modern macOS)
- **Claude Code** installed

## 🎯 What It Cleans

- ✅ All conversation history
- ✅ Chat caches
- ✅ Message buffers
- ✅ Project histories
- ❌ User settings (preserved)
- ❌ API keys (preserved)
- ❌ MCP configurations (preserved)

## 📊 Before & After

| Metric | Before | After |
|--------|--------|-------|
| File Size | 27.53 MB | 89.74 KB |
| Load Time | ~5 seconds | < 0.1 seconds |
| Performance | Slow | Instant |

## 🛠️ Usage

Claude Clear can be used in two ways:

### 1. Automatic Service Mode (Recommended)
After installation, Claude Clear runs automatically every 24 hours:

```bash
# Installation enables automatic service
./install-enhanced.sh

# Check if service is running
claude-clear --status
```

### 2. Manual Script Mode
Run Claude Clear on-demand without installing the service:

```bash
# Using the provided launch scripts
./run-cc-macos.sh    # On macOS
./run-cc-linux.sh    # On Linux

# Or run directly with Python
python3 bin/claude-clear.py

# Check status
claude-clear --status

# Preview changes
claude-clear --dry-run

# View logs
claude-clear --logs

# Show version
claude-clear --version

# Uninstall
claude-clear --uninstall
```

## 📦 Installation Options

### Option 1: Manual Mode (Quick Start)
No installation required - just clone and run:
```bash
git clone https://github.com/yourusername/claude-clear.git
cd claude-clear

# Run immediately
./run-cc-macos.sh    # On macOS
./run-cc-linux.sh    # On Linux

# Or with Python directly
python3 bin/claude-clear.py
```

### Option 2: Automatic Service Install
Install as a system service for automatic cleaning:

#### Standard Install
```bash
git clone https://github.com/yourusername/claude-clear.git
cd claude-clear
./install.sh
```

#### Enhanced Install (Recommended)
The enhanced installer includes additional checks and fallbacks for problematic systems:
```bash
./install-enhanced.sh
```

### Verify Installation
After installing, verify everything is working correctly:
```bash
./verify-install.sh
```

## 🔧 Troubleshooting

Having trouble? We've got you covered:

- **[📖 docs/troubleshooting.md](docs/troubleshooting.md)** - Comprehensive troubleshooting guide
- **[✅ verify-install.sh](verify-install.sh)** - Automated installation checker

### Common Issues

1. **Permission denied errors**
   - Don't use sudo - Claude Clear installs in user space only
   - Check if `/usr/local/bin` exists and is writable
   - The enhanced installer will find an alternative location

2. **Command not found after install**
   - Restart your terminal or run: `source ~/.zshrc`
   - Try: `~/claude-clear/claude-clear` directly

3. **Python not found**
   - Install Python 3: `brew install python3`
   - Or download from https://python.org

4. **Service not loading**
   - Check macOS version (requires 10.14+)
   - Manual cleanup still works: `claude-clear`
   - Check logs: `claude-clear --logs`

5. **Claude config not found**
   - Run Claude Code at least once first
   - Check location: `find ~ -name ".claude.json" 2>/dev/null`

## 📁 Project Structure

```
claude-clear/
├── bin/
│   └── claude-clear.py    # Main CLI interface
├── src/
│   └── cleaner.py         # Core cleanup logic
├── scripts/
│   ├── install.sh         # Standard installer
│   ├── install-enhanced.sh # Enhanced installer with checks
│   ├── verify-install.sh  # Installation verifier
│   └── uninstall.sh       # Complete uninstaller
├── docs/
│   ├── build.md           # Build instructions
│   ├── contributing.md    # Contribution guidelines
│   ├── development.md     # Development guide
│   ├── security.md        # Security policy
│   ├── techstack.md       # Technology stack
│   ├── troubleshooting.md # Troubleshooting guide
│   └── learnings.md       # Project insights
├── tests/
│   └── test_cleaner.py    # Test suite
├── assets/
│   └── banner.txt         # ASCII art banner
├── .github/
│   ├── ISSUE_TEMPLATE/    # GitHub issue templates
│   └── pull_request_template.md
├── run-cc-macos.sh        # Manual launch script for macOS
├── run-cc-linux.sh        # Manual launch script for Linux
├── LICENSE                # MIT License
├── CHANGELOG.md           # Version history
├── CLAUDE.md              # Claude AI assistant context
├── Makefile              # Build tasks
├── requirements.txt       # Python dependencies
├── requirements-dev.txt   # Development dependencies
└── README.md             # This file
```

## 🚀 Operational Modes

### Automatic Service Mode
When installed, Claude Clear sets up a system service that runs automatically:
- **macOS**: LaunchAgent runs every 24 hours
- **Linux**: Systemd service runs every 24 hours
- **Benefits**: Set it and forget it, always maintains clean config
- **Resource Usage**: Minimal, runs in background

### Manual Script Mode
Run Claude Clear only when you need it:
- **No installation required** - just clone and run
- **Full control** - clean exactly when you want
- **Portable** - works on any system with Python 3.6+
- **Same functionality** as automatic mode

### Service Details (Automatic Mode)
- **Name**: `com.claude.cleanup` (macOS)
- **Interval**: Every 24 hours
- **Logs**: `~/.claude-clear/logs/`
- **Can be disabled**: Run `claude-clear --uninstall`

## 🔒 Safety Features

- **Automatic backups**: Creates timestamped backups before cleaning
- **Dry-run mode**: Preview changes before applying
- **Preserves settings**: Only removes chat history and caches
- **Error handling**: Graceful failure with detailed error messages
- **Verbose logging**: Track all operations in log files

## 📚 Documentation

- **[📖 docs/build.md](docs/build.md)** - Build and development instructions
- **[🤝 docs/contributing.md](docs/contributing.md)** - Contribution guidelines
- **[🔧 docs/development.md](docs/development.md)** - Development guide and architecture
- **[🔒 docs/security.md](docs/security.md)** - Security policy and considerations
- **[⚙️ docs/techstack.md](docs/techstack.md)** - Technology stack information
- **[📈 docs/learnings.md](docs/learnings.md)** - Project insights and learnings
- **[📋 CHANGELOG.md](CHANGELOG.md)** - Version history and changes

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

We welcome contributions! Please see **[📖 docs/contributing.md](docs/contributing.md)** for detailed guidelines.

Quick start:
1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## ⚠️ Disclaimer

This is an unofficial tool. Claude's configuration bloat appears to be an intentional design choice by Anthropic. Use at your own risk. Always create backups before cleaning.

## 🐛 Bug Reports

Found an issue? Please include:
- macOS version
- Python version
- Claude Clear version
- Error messages
- Steps to reproduce

Report at: https://github.com/yourusername/claude-clear/issues

---

> "The simplest solutions are often the most elegant."