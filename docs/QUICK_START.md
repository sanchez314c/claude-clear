# Quick Start

Get Claude Clear running in under 2 minutes.

## 1. Clone

```bash
git clone https://github.com/sanchez314c/claude-clear.git
cd claude-clear
```

## 2. Preview (Safe, No Changes)

```bash
python3 src/cleaner.py --dry-run
```

This shows what would be cleaned without touching anything.

## 3. Run

```bash
python3 src/cleaner.py
```

A timestamped backup is created automatically before any changes.

## 4. Verify

Your `~/.claude.json` should now be under 100KB. Claude Code will start faster.

## Restore if Needed

```bash
ls ~/.claude.json.backup.*
cp ~/.claude.json.backup.YYYYMMDD_HHMMSS ~/.claude.json
```

## Platform Launchers

If you prefer shell wrappers that handle Python detection:

```bash
./run-cc-linux.sh     # Linux
./run-cc-macos.sh     # macOS
```

## Next Steps

- Set up automatic cleaning: [DEPLOYMENT.md](DEPLOYMENT.md)
- Full installation options: [INSTALLATION.md](INSTALLATION.md)
- Having issues: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
