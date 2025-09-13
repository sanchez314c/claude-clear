# Build & Compile

## Overview

Claude Clear is a pure Python project. There is no compilation step. You can run it directly from source or build a distributable package.

## Running from Source (No Build)

```bash
# Clone and run directly
git clone https://github.com/sanchez314c/claude-clear.git
cd claude-clear
python3 src/cleaner.py --dry-run
```

Platform launchers handle Python detection automatically:

```bash
./run-cc-linux.sh     # Linux
./run-cc-macos.sh     # macOS
run-source-windows.bat  # Windows
```

## Editable Install

For development, install in editable mode so changes take effect immediately:

```bash
pip install -e .
claude-clear --version
```

## Building a Distribution Package

### Wheel + Source Distribution

```bash
# Install build tools
pip install build twine

# Build wheel and sdist
python -m build

# Output:
#   dist/claude-clear-1.0.0-py3-none-any.whl
#   dist/claude-clear-1.0.0.tar.gz

# Verify package metadata
twine check dist/*
```

### Universal Distribution Archive

The `scripts/build-universal.sh` script creates a standalone tar.gz that includes all dependencies and platform launchers:

```bash
./scripts/build-universal.sh
# Output: claude-clear-v1.0.0-universal.tar.gz
```

## Makefile Targets

```bash
make install       # pip install .
make dev-install   # pip install -e . + dev deps
make test          # pytest tests/ -v
make clean         # remove __pycache__, *.pyc, build/, dist/, *.egg-info/
make uninstall     # pip uninstall claude-clear
make version       # print current version
make help          # list all targets
```

## Release Checklist

- [ ] All tests pass (`make test`)
- [ ] Code formatted (`black src/`)
- [ ] Linting clean (`flake8 src/`)
- [ ] `CHANGELOG.md` updated with version and date
- [ ] Version bumped in `src/cleaner.py` (`show_version()`)
- [ ] Git tag created (`git tag v1.x.x`)
- [ ] Build artifacts verified (`twine check dist/*`)

## Dependencies

**Runtime**: The core cleaner uses only Python stdlib (`json`, `pathlib`, `datetime`, `argparse`, `subprocess`, `shutil`, `sys`, `os`). `click` and `PyYAML` are listed in `requirements.txt` for future use but are not currently imported.

**Dev**: `pytest`, `black`, `flake8`, `mypy`, `isort`, `bandit`, `memory-profiler`. See `requirements-dev.txt`.
