# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2026-03-13 — Forensic Audit Remediation

### Fixed (CRITICAL)
- Fixed `NameError` crash on `--debug` flag: added missing `import logging` and `CLAUDE_JSON_PATH` constant
- Fixed non-atomic write to `~/.claude.json`: now writes to temp file then atomically renames
- Fixed `subprocess.run` with `shell=True` and list argument in uninstall (command injection surface)
- Fixed `clear()` syntax error in both uninstaller scripts (was broken function declaration)
- Fixed path injection via `$INSTALL_DIR` in sed patterns in both uninstallers
- Fixed Python code injection via `$CLAUDE_JSON` in verify-install scripts
- Updated `.python-version` from EOL 3.6 to 3.11; CI matrix from 3.6-3.11 to 3.9-3.12

### Fixed (HIGH)
- Fixed division by zero when `~/.claude.json` is 0 bytes
- Replaced bare `except:` clauses with specific exception types
- Added `platform.system() == 'Darwin'` guards around all `launchctl` calls
- Removed dead variable `cleaned_project` and dead counter `history_count`
- Removed redundant duplicate file read in `main()`
- Added `encoding='utf-8'` to all `open()` calls in both Python files
- Fixed background copy subshell exit code not being checked in all installers
- Fixed installer checking `assets/` existence but copying `resources/`
- Quoted `$PYTHON_CMD` in run-source scripts to prevent word splitting
- Removed `|| true` from MyPy and Bandit in CI (errors were being silently suppressed)

### Fixed (MEDIUM)
- Removed unused imports (`os`, `typing.Dict/List/Any`)
- Moved `import argparse` from function body to module level
- Changed `python` to `python3` in Makefile test target
- Added upper bounds to dependency versions: `click<9.0.0`, `PyYAML<7.0`
- Added `system-info.txt` to .gitignore

## [1.0.2] - 2026-03-13 — Documentation Standardization & Compliance

### Documentation
- Created `docs/FAQ.md` with real questions and answers from codebase analysis
- Created `docs/TECHSTACK.md` with full technology stack breakdown and rationale
- Created `docs/WORKFLOW.md` with branching strategy, commit conventions, and release process
- Created `docs/QUICK_START.md` with minimal clone-to-running steps
- Created `docs/DOCUMENTATION_INDEX.md` linking all documentation files
- Updated `docs/README.md` index to link all 15 docs/ files plus root-level docs
- All 27 standard documentation files now present

### Structure
- Consolidated `assets/` into `resources/` (banner.txt moved to resources/)
- Created `resources/icons/` with icon.png and icon.icns (moved from resources/ root)
- Created `run-source-linux.sh` and `run-source-mac.sh` (simple Python launchers)
- Created `legacy/` directory with .gitkeep
- Removed empty `dev/` directory
- Renamed archive backup to proper timestamp format (20260207_015926.zip)
- Synced AGENTS.md with CLAUDE.md
- Updated all installer and launcher references from assets/ to resources/
- Updated README.md and VERSION_MAP.md project structure diagrams

## [1.0.1] - 2026-03-07 — Documentation Standardization

### Documentation
- Moved `docs/CODE_OF_CONDUCT.md` → `CODE_OF_CONDUCT.md` (root, standard location)
- Moved `docs/CONTRIBUTING.md` → `CONTRIBUTING.md` (root, standard location)
- Moved `docs/SECURITY.md` → `SECURITY.md` (root, standard location)
- Moved `docs/LICENSE` → `archive/merged/` (root `LICENSE` already present)
- Moved `VERSION_MAP.md` → `dev/VERSION_MAP.md` (internal planning doc)
- Moved `TROUBLESHOOTING.md` (root duplicate) → `archive/merged/`
- Archived fragmented docs: `DOCUMENTATION_INDEX.md`, `QUICK_START.md`, `TECHSTACK.md`, `BUILD_COMPILE.md`, `WORKFLOW.md`, `FAQ.md`
- Merged Quick Start section into `docs/INSTALLATION.md`
- Merged tech stack, build, and workflow content into `docs/DEVELOPMENT.md`
- Merged FAQ into `docs/TROUBLESHOOTING.md`
- Moved internal docs to `dev/`: `LEARNINGS.md`, `PRD.md`, `TODO.md`
- Rewrote `docs/ARCHITECTURE.md` to reflect actual code structure (not aspirational)
- Rewrote `docs/README.md` as a proper documentation index
- Created `.github/ISSUE_TEMPLATE/bug_report.md`
- Created `.github/ISSUE_TEMPLATE/feature_request.md`
- Created `.github/PULL_REQUEST_TEMPLATE.md`
- Fixed all `yourusername` / `your-org` placeholder URLs to `sanchez314c`
- Fixed placeholder emails in `SECURITY.md` and `CODE_OF_CONDUCT.md`

## [Unreleased]

### Changed
- **Repository Compliance Audit (2024-12-04 18:45:00)**: Applied full standardization
  - Renamed `build_resources/` to `resources/` following standard conventions
  - Created `/archive/` directory with timestamped backup
  - Added `.gitkeep` to empty `tests/` folder
  - Created `CLAUDE.md` at project root with project guidance
  - Created `.editorconfig` for consistent code formatting
  - Created `.env.example` for environment configuration template
  - Created `.python-version` specifying Python 3.6+ requirement
  - Created `run-source-windows.bat` for Windows support
  - Created `VERSION_MAP.md` documenting project structure and version history
  - Updated `.gitignore` with additional patterns (`.env.local`, `.env.*.local`, `legacy/`)

### Added
- Manual launch scripts for immediate use without installation
  - `run-cc-macos.sh` - Optimized for macOS systems
  - `run-cc-linux.sh` - Cross-platform Linux support with distribution detection
- Comprehensive documentation structure in `/docs` folder
- Build instructions and development guides
- Security policy and threat model documentation
- Technology stack documentation
- Project learnings and insights documentation
- Contributing guidelines with development workflow

### Changed
- Clarified two operational modes: Automatic Service vs Manual Script
- Improved README with clearer installation and usage instructions
- Updated project structure to reflect new manual launch scripts
- Reorganized installation scripts into `/scripts` directory

### Security
- Added comprehensive security documentation
- Documented threat model and security controls
- Added secure coding practices and incident response procedures

---

## [1.0.0] - 2025-10-29

### Added
- Initial release of Claude Clear
- Core cleanup functionality for Claude Code configuration files
- Command-line interface with intuitive commands
- Automatic backup creation before cleanup
- macOS LaunchAgent integration for automatic 24-hour cleanup
- Dry-run mode for previewing changes
- Status command to inspect configuration health
- Restore functionality from backup files
- Comprehensive installation and verification scripts
- Troubleshooting documentation
- Performance optimization reducing file sizes by 99.67%

### Features
- **Core Cleanup**: Removes chat history and cache data while preserving settings
- **Backup System**: Timestamped backups with automatic rotation (keeps last 5)
- **CLI Interface**: User-friendly command-line tool with help system
- **Automatic Service**: Background cleanup via macOS LaunchAgent
- **Safety Features**: Dry-run mode, atomic file operations, graceful error handling
- **Performance**: Reduces typical 27MB config files to under 100KB
- **Verification**: Installation verification script to ensure proper setup

### Installation
- Standard installation script (`install.sh`)
- Enhanced installation script (`install-enhanced.sh`) with additional checks
- Verification script (`verify-install.sh`) for post-install validation
- Uninstall script (`uninstall.sh`) for complete removal

### Security
- User-only permissions (no sudo required)
- Secure backup creation with restricted permissions
- Input validation and sanitization
- No external network connections or data transmission
- Local-only operation for maximum privacy

### Documentation
- Comprehensive README with usage examples
- Troubleshooting guide for common issues
- Installation instructions for different scenarios
- Performance metrics and before/after comparisons

### Compatibility
- macOS 10.14 Mojave or later
- Python 3.6+ (pre-installed on modern macOS)
- Claude Code installed and configured

### Known Limitations
- macOS only (due to LaunchAgent integration)
- Requires Claude Code to be run at least once first
- Configuration file must be valid JSON format

---

## [0.9.0] - 2025-10-28 (Beta)

### Added
- Beta version for testing
- Basic cleanup functionality
- Initial command-line interface
- Simple backup mechanism

### Known Issues
- Limited error handling
- No automatic service integration
- Basic installation process

---

## [0.1.0] - 2025-10-15 (Alpha)

### Added
- Concept proof and initial development
- Basic file size analysis
- Manual cleanup procedures documentation

---

## Version History Philosophy

This project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html):
- **MAJOR**: Breaking changes or major feature releases
- **MINOR**: New features or improvements (backward compatible)
- **PATCH**: Bug fixes or minor improvements (backward compatible)

### Release Cadence
- **Major releases**: As needed for significant features
- **Minor releases**: Monthly or when features are ready
- **Patch releases**: As needed for bug fixes and security updates

### Support Policy
- **Current major version**: Full support including new features and bug fixes
- **Previous major version**: Security updates and critical bug fixes only
- **Older versions**: No support (upgrade recommended)

### Changelog Maintenance
- All changes are recorded here
- Format follows Keep a Changelog standards
- Entries include version number, date, and categorized changes
- Unreleased section tracks upcoming changes

---

*For detailed release notes and upgrade instructions, see the [GitHub Releases](https://github.com/sanchez314c/claude-clear/releases) page.*