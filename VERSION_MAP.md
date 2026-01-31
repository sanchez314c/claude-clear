# Version Map

This document tracks the version history and folder structure of the Claude Clear project.

## Active Version

| Version | Folder | Status | Release Date | Notes |
|---------|--------|--------|--------------|-------|
| **1.0.0** | `/` (root) | ✅ ACTIVE | 2024-10-06 | Initial release - Production stable |

## Project Structure

```
claude-clear/                    ← Active version lives here (v1.0.0)
├── bin/                         # Executable scripts
│   └── claude-clear.py          # Main CLI entry point
├── src/                         # Source code
│   └── cleaner.py               # Core cleaning logic
├── resources/                   # Application resources (renamed from build_resources)
│   └── icons/                   # Application icons
│       ├── icon.png
│       └── icon.icns
├── resources/                   # Application resources
│   ├── banner.txt               # ASCII art banner
│   └── icons/                   # Application icons (icon.png, icon.icns)
├── docs/                        # Documentation
├── tests/                       # Test suite
├── scripts/                     # Build and installation scripts
├── archive/                     # Timestamped backups (gitignored)
└── [root files]                 # Configuration and documentation
```

## Legacy Versions

No legacy versions exist. All version history is managed through Git tags and commits.

## Git Tags

```bash
# List all version tags
git tag -l

# Show specific version
git show v1.0.0

# Compare versions
git diff v0.9.0..v1.0.0
```

## Version Guidelines

### Version Numbering (Semantic Versioning)

- **MAJOR**: Incompatible API changes
- **MINOR**: Backwards-compatible functionality additions
- **PATCH**: Backwards-compatible bug fixes

Example: `1.0.0` → `1.0.1` (bug fix) → `1.1.0` (new feature) → `2.0.0` (breaking change)

### Release Checklist

Before releasing a new version:

- [ ] Update version in all source files
- [ ] Update CHANGELOG.md with release notes
- [ ] Create git tag: `git tag -a v1.x.x -m "Release v1.x.x"`
- [ ] Push tag: `git push origin v1.x.x`
- [ ] Create GitHub Release with release notes
- [ ] Update VERSION_MAP.md

## Migration Notes

### build_resources → resources (2024-12-04)

The `build_resources/` folder was renamed to `resources/` to follow standard conventions. This was a structural change to align with best practices for resource folder naming.

**Impact:**
- `scripts/build-universal.sh` updated (line 737)
- Icon files now located at `resources/icons/`
- No functional changes to the application

## Archive Structure

The `/archive/` folder contains timestamped backups for local recovery purposes. This folder is gitignored and not part of the repository.

Example backup filename: `claude-clear_20241204_183945.zip`

## Notes

- The active version always lives at the repository root
- Historical versions are tracked via Git tags, not folder copies
- Use `git checkout <tag>` to view previous versions
- Use `git checkout main` to return to the active version
