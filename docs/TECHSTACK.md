# Technology Stack

## Language

**Python 3.6+** - chosen for cross-platform compatibility, rich standard library, and zero compilation requirement. The tool runs on any system with Python installed.

## Runtime Dependencies

The core cleaner uses **only Python standard library modules** at runtime. No pip install is required to run it.

| Module | Purpose |
|--------|---------|
| `json` | Parse and write `~/.claude.json` |
| `pathlib` | Cross-platform file path handling |
| `datetime` | Timestamped backup filenames |
| `argparse` | CLI argument parsing |
| `os` | Environment and path utilities |
| `sys` | Exit codes and path manipulation |
| `subprocess` | Service status checks (launchctl) |
| `shutil` | File copy operations for uninstall |
| `typing` | Type annotations (Dict, List, Any) |

### Listed but Unused

These are in `requirements.txt` but not currently imported anywhere in the code:

| Package | Version | Status |
|---------|---------|--------|
| `click` | >=8.0.0 | Listed for potential future CLI refactor. Currently using argparse. |
| `PyYAML` | >=6.0 | Listed for potential future config file support. Not imported. |

## Development Dependencies

From `requirements-dev.txt`:

| Package | Version | Purpose |
|---------|---------|---------|
| `pytest` | >=7.0.0 | Test runner |
| `pytest-cov` | >=4.0.0 | Coverage reporting |
| `pytest-mock` | >=3.8.0 | Mock utilities |
| `black` | >=22.0.0 | Code formatter (88 char line length) |
| `flake8` | >=5.0.0 | Linter |
| `isort` | >=5.10.0 | Import sorter (Black-compatible profile) |
| `mypy` | >=0.991 | Static type checker |
| `sphinx` | >=5.0.0 | Documentation generator |
| `sphinx-rtd-theme` | >=1.0.0 | Docs theme |
| `build` | >=0.8.0 | Package builder (wheel + sdist) |
| `twine` | >=4.0.0 | PyPI upload tool |
| `pre-commit` | >=2.20.0 | Git hook manager |
| `memory-profiler` | >=0.60.0 | Memory usage profiling |
| `bandit` | >=1.7.0 | Security linter |

## Build System

| Tool | Purpose |
|------|---------|
| `Makefile` | Primary build interface (`make install`, `make test`, `make clean`) |
| `pip` | Dependency installation |
| `python -m build` | Package building (wheel + sdist) |
| `twine` | Package verification and upload |

## Platform Support

| Platform | Launcher | Auto-Scheduling |
|----------|----------|-----------------|
| macOS | `run-cc-macos.sh` | LaunchAgent (`com.claude.cleanup` plist) |
| Linux | `run-cc-linux.sh` | systemd service or cron |
| Windows | `run-source-windows.bat` | Task Scheduler |

## Code Quality

| Tool | Configuration |
|------|---------------|
| Black | Line length 88, Python 3.8+ target |
| isort | Black-compatible profile |
| flake8 | Line length 88, ignore E203/W503 |
| mypy | Type checking for all functions |
| bandit | Security-focused static analysis |
| `.editorconfig` | Consistent formatting across editors |

## Why This Stack

- **No external runtime dependencies**: Users don't need to pip install anything to use the tool. Clone and run.
- **Standard library JSON**: The `json` module handles the 25-50MB files fast enough (< 2 seconds). No need for streaming parsers at current scale.
- **argparse over click**: One less dependency. The CLI is simple enough that argparse covers it.
- **Shell launchers**: Platform-specific bash/bat scripts handle Python detection and environment setup without requiring the user to know anything about Python paths.
