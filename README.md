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

```bash
# Run cleanup
claude-clear

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

### Standard Install
```bash
git clone https://github.com/yourusername/claude-clear.git
cd claude-clear
./install.sh
```

### Enhanced Install (Recommended)
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

- **[📖 TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Comprehensive troubleshooting guide
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
├── docs/
│   └── TROUBLESHOOTING.md # Troubleshooting guide
├── tests/
│   └── test_cleaner.py    # Test suite
├── assets/
│   └── banner.txt         # ASCII art banner
├── install.sh             # Standard installer
├── install-enhanced.sh    # Enhanced installer with checks
├── verify-install.sh      # Installation verifier
├── uninstall.sh           # Complete uninstaller
├── LICENSE                # MIT License
├── Makefile              # Build tasks
├── requirements.txt       # Python dependencies
└── README.md             # This file
```

## 🚀 Automatic Cleaning

Claude Clear sets up a macOS LaunchAgent that automatically cleans your configuration every 24 hours. The service runs in the background with minimal resource usage.

### Service Details
- **Name**: `com.claude.cleanup`
- **Interval**: Every 24 hours
- **Logs**: `~/.claude-clear/logs/`
- **Can be disabled**: Run `claude-clear --uninstall`

## 🔒 Safety Features

- **Automatic backups**: Creates timestamped backups before cleaning
- **Dry-run mode**: Preview changes before applying
- **Preserves settings**: Only removes chat history and caches
- **Error handling**: Graceful failure with detailed error messages
- **Verbose logging**: Track all operations in log files

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🤝 Contributing

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