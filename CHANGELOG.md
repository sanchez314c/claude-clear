# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

*For detailed release notes and upgrade instructions, see the [GitHub Releases](https://github.com/yourusername/claude-clear/releases) page.*