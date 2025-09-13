# Frequently Asked Questions

## General

**What is Claude Clear?**
A Python utility that cleans `~/.claude.json` by removing accumulated chat history and cache data while preserving your settings, API keys, and MCP configurations.

**Why does ~/.claude.json get so big?**
Claude Code stores conversation history, message buffers, and context caches per project inside a single JSON file. With regular use across multiple projects, this file can grow to 25MB+ and slow down Claude Code's startup.

**How much space does it save?**
Typically reduces a 27MB config to under 100KB, about a 99.6% reduction.

**Is it safe?**
Yes. Claude Clear creates a timestamped backup before making any changes. If something goes wrong, you can restore instantly.

**Does it send data anywhere?**
No. All processing is local. Nothing is transmitted, logged externally, or phoned home.

## What Gets Cleaned

**What exactly gets removed?**
Per-project fields: `history`, `conversation`, `messages`, `chat`, `conversations`, `messageHistory`, `chatHistory`, `contextCache`. Global fields: `globalHistory`, `globalMessages`, `conversations`, `recentConversations`, `conversationCache`, `chatCache`.

**What is preserved?**
User settings, API keys, MCP configurations, project metadata, workspace preferences, and tool configurations. Everything that makes Claude Code *yours* stays untouched.

**Will I lose my Claude Code settings?**
No. Settings, API keys, and MCP configs are explicitly preserved. Only chat history and caches are removed.

**Will this break Claude Code?**
No. Claude Code works fine with empty history fields. It simply rebuilds history as you use it.

## Usage

**How often should I run it?**
Depends on your usage pattern:
- Light users: monthly
- Regular users: weekly
- Heavy users: daily or every few days

**Can I preview changes before running?**
Yes. Use `--dry-run` to see exactly what would be cleaned without making any changes:
```bash
python3 src/cleaner.py --dry-run
```

**Can I automate it?**
Yes. Use cron (Linux/macOS), LaunchAgent (macOS), or Task Scheduler (Windows). The install scripts can set this up for you. See [DEPLOYMENT.md](DEPLOYMENT.md) for details.

**How do I restore from a backup?**
```bash
# List available backups
ls ~/.claude.json.backup.*

# Restore a specific backup
cp ~/.claude.json.backup.YYYYMMDD_HHMMSS ~/.claude.json
```

## Installation

**Do I need to install anything?**
No. You can run it directly from the cloned repo with `python3 src/cleaner.py`. The install scripts are optional and set up automatic cleaning.

**Does it require sudo?**
No. Claude Clear operates entirely in user space and never needs elevated privileges.

**What Python version do I need?**
Python 3.6 or higher. The tool only uses Python standard library modules at runtime.

**Does it work on Linux?**
Yes. Full support. Use `./run-cc-linux.sh` or run `python3 src/cleaner.py` directly.

**Does it work on Windows?**
Yes, via `run-source-windows.bat` or running `python src/cleaner.py` directly.

## Troubleshooting

**"~/.claude.json not found"**
Claude Code hasn't been run yet, or the config is in a non-standard location. Run Claude Code at least once first.

**"Invalid JSON" error**
The config file is corrupted. Restore from a backup: `cp ~/.claude.json.backup.LATEST ~/.claude.json`. You can also validate it with `python3 -m json.tool ~/.claude.json`.

**The file is already small**
Claude Clear warns if the file is under 100KB. You can still clean it by confirming when prompted, but there's probably nothing to gain.

**Command not found after install**
Restart your terminal or run `source ~/.zshrc` (or `~/.bashrc`). If that doesn't work, run directly: `~/.claude-clear/claude-clear`.

For more issues, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).
