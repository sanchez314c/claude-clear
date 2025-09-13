# Architecture

## Overview

Claude Clear is a single-file Python utility with a thin CLI wrapper. The core logic lives in `src/cleaner.py`; `bin/claude-clear.py` wraps it with additional CLI commands (status, logs, uninstall).

## System Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                       Entry Points                           │
│  bin/claude-clear.py  ──────┐                               │
│  run-cc-linux.sh             │                               │
│  run-cc-macos.sh             ▼                               │
│                    src/cleaner.py                            │
└─────────────────────────────────────────────────────────────┘
                              │
           ┌──────────────────┼──────────────────┐
           ▼                  ▼                   ▼
    ~/.claude.json     ~/.claude.json      ~/.claude.json
    (validate JSON)    .backup.TIMESTAMP   (write cleaned)
```

## File Structure (Actual)

```
claude-clear/
├── bin/
│   └── claude-clear.py    # CLI wrapper — status, logs, uninstall, dry-run
├── src/
│   └── cleaner.py         # Core logic — all cleaning functions live here
├── scripts/
│   ├── install.sh         # Copies files, creates symlink in /usr/local/bin
│   ├── uninstall.sh       # Removes installation
│   └── verify-install.sh  # Post-install check
├── run-cc-linux.sh        # Direct launcher (no install required)
├── run-cc-macos.sh        # macOS launcher with enhanced UI
├── run-source-windows.bat # Windows launcher
├── install.sh             # Root-level install entry point
├── install-enhanced.sh    # Enhanced installer with fallbacks
├── uninstall.sh           # Root-level uninstall
├── verify-install.sh      # Root-level verifier
├── Makefile               # make install / make test / make clean
├── requirements.txt       # click>=8.0.0, PyYAML>=6.0
└── requirements-dev.txt   # pytest and dev tools
```

## Core Components

### `src/cleaner.py`

The entire cleaning engine. No classes — procedural functions:

| Function | Purpose |
|----------|---------|
| `print_banner()` | ASCII art header |
| `clean_claude_json(dry_run)` | Main cleaning logic |
| `show_version()` | Print version info |
| `main()` | argparse entry point |

**`clean_claude_json(dry_run)`** flow:
1. Resolve `~/.claude.json`, check existence
2. Report current file size; warn if < 100KB
3. If not dry-run: read JSON, create timestamped backup
4. Iterate `data['projects']` dict — zero out `history` and 6 other chat fields
5. Zero out top-level fields: `globalHistory`, `conversations`, `conversationCache`, etc.
6. Print summary (items cleared, MB reclaimed)
7. If not dry-run: write cleaned JSON back; report size reduction

### `bin/claude-clear.py`

CLI wrapper built on argparse. Imports `Colors`, `clean_claude_json`, `print_banner` from `src/cleaner`. Adds:
- `show_status()` — checks install dir, launchctl service, config file size, recent logs
- `show_logs()` — reads `~/.claude-clear/logs/cleanup.log`
- `uninstall()` — removes launchctl plist, install dir, `/usr/local/bin` symlink, PATH entries

## Data Flow

```
CLI args
   │
   ▼
argparse (src/cleaner.py main())
   │
   ├──[--version] ──→ print version, exit
   ├──[--dry-run]  ──→ clean_claude_json(dry_run=True)
   └──[default]    ──→ clean_claude_json(dry_run=False)
                              │
                    ~/.claude.json
                              │
                    json.load()  ← validate JSON
                              │
                    Create backup → ~/.claude.json.backup.YYYYMMDD_HHMMSS
                              │
                    Clear project fields:
                      data['projects'][id]['history'] = []
                      data['projects'][id]['conversation'] = []
                      data['projects'][id]['messages'] = []
                      data['projects'][id]['chat'] = []
                      data['projects'][id]['conversations'] = []
                      data['projects'][id]['messageHistory'] = []
                      data['projects'][id]['chatHistory'] = []
                      data['projects'][id]['contextCache'] = []
                              │
                    Clear global fields:
                      data['globalHistory'] = []
                      data['globalMessages'] = []
                      data['conversations'] = []
                      data['recentConversations'] = []
                      data['conversationCache'] = {}
                      data['chatCache'] = {}
                              │
                    json.dump() → ~/.claude.json
                              │
                    Report: original MB → new KB, % reduction
```

## Configuration Target

Claude Clear operates exclusively on `~/.claude.json` — Claude Code's single configuration file.

**Structure targeted:**
```json
{
  "projects": {
    "<project_id>": {
      "history": [...],        ← REMOVED
      "conversation": [...],   ← REMOVED
      "messages": [...],       ← REMOVED
      "settings": {...},       ← PRESERVED
      "mcp_configs": {...}     ← PRESERVED
    }
  },
  "globalHistory": [...],      ← REMOVED
  "conversations": [...],      ← REMOVED
  "userSettings": {...}        ← PRESERVED
}
```

## Safety Design

1. **JSON validation first** — exits on parse error before any modification
2. **Backup always first** — timestamped copy created before any write
3. **Size threshold warning** — prompts if file is already < 100KB
4. **Dry-run mode** — full analysis without writing
5. **No network access** — entirely local file operations
6. **No sudo required** — operates on user-owned files only

## Performance

- Entirely I/O bound — loading and writing the JSON file
- Memory usage equals 2× file size (original + cleaned copy in RAM simultaneously)
- Typical 27MB file processes in < 2 seconds
- Backup doubles disk usage temporarily (cleaned original + backup on disk)

## Dependencies

**Runtime** (from `requirements.txt`):
- `click>=8.0.0` — listed but not used in current code (argparse is used instead)
- `PyYAML>=6.0` — listed for future config file support, not currently imported

**Stdlib only used** (no external imports at runtime): `json`, `os`, `sys`, `pathlib`, `datetime`, `typing`, `argparse`, `subprocess`, `shutil`

## Operational Modes

**Manual Script Mode** — run `./run-cc-linux.sh` or `python src/cleaner.py` directly, no install needed.

**Installed Service Mode** — `install.sh` creates symlink at `/usr/local/bin/claude-clear` and optionally sets up a macOS LaunchAgent (`com.claude.cleanup`) that runs every 24 hours.
