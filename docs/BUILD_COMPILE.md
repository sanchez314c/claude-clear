# Build and Compilation Guide

## Overview

This guide covers building Claude Clear from source, including compilation instructions, dependency management, and distribution packaging.

## Prerequisites

### System Requirements
- **Python**: 3.8 or higher
- **Git**: For source code management
- **Build Tools**: Platform-specific build tools
- **Virtual Environment**: Recommended for isolation

### Development Dependencies
```bash
# Install development dependencies
pip install -r requirements-dev.txt

# Key development tools:
# - pytest: Testing framework
# - black: Code formatting
# - flake8: Linting
# - mypy: Type checking
# - build: Package building
# - twine: Package publishing
```

## Build Process

### 1. Source Setup
```bash
# Clone repository
git clone https://github.com/your-org/claude-clear.git
cd claude-clear

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt
```

### 2. Development Build
```bash
# Install in development mode (editable)
pip install -e .

# Verify installation
claude-clear --version
```

### 3. Production Build
```bash
# Build distribution packages
python -m build

# This creates:
# dist/claude-clear-1.0.0-py3-none-any.whl
# dist/claude-clear-1.0.0.tar.gz
```

## Build Configuration

### setup.py Configuration
```python
from setuptools import setup, find_packages

setup(
    name="claude-clear",
    version="1.0.0",
    description="Clean bloated Claude Code configuration files",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="Your Name",
    author_email="your.email@example.com",
    url="https://github.com/your-org/claude-clear",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.8",
    install_requires=[
        # List dependencies here
    ],
    extras_require={
        "dev": [
            "pytest>=6.0",
            "black>=22.0",
            "flake8>=4.0",
            "mypy>=0.950",
        ],
    },
    entry_points={
        "console_scripts": [
            "claude-clear=cleaner:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": ["*.txt", "*.yml", "*.json"],
    },
)
```

### pyproject.toml Configuration
```toml
[build-system]
requires = ["setuptools>=45", "wheel", "setuptools_scm[toml]>=6.2"]
build-backend = "setuptools.build_meta"

[project]
name = "claude-clear"
dynamic = ["version"]
description = "Clean bloated Claude Code configuration files"
readme = "README.md"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "your.email@example.com"},
]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.8",
    "Programming Language :: Python :: 3.9",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
]
requires-python = ">=3.8"

[project.scripts]
claude-clear = "cleaner:main"

[project.optional-dependencies]
dev = [
    "pytest>=6.0",
    "black>=22.0",
    "flake8>=4.0",
    "mypy>=0.950",
]
```

## Makefile Build Targets

### Standard Makefile
```makefile
.PHONY: help install install-dev test lint format clean build upload

help:           ## Show this help
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'

install:         ## Install package
	pip install .

install-dev:      ## Install in development mode
	pip install -e .
	pip install -r requirements-dev.txt

test:            ## Run tests
	python -m pytest tests/ -v

test-cov:        ## Run tests with coverage
	python -m pytest tests/ --cov=src/ --cov-report=html

lint:            ## Run linting
	flake8 src/ tests/
	mypy src/

format:          ## Format code
	black src/ tests/
	isort src/ tests/

clean:           ## Clean build artifacts
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name __pycache__ -delete
	find . -type f -name "*.pyc" -delete

build:           ## Build distribution packages
	python -m build

upload:          ## Upload to PyPI
	twine upload dist/*

upload-test:      ## Upload to test PyPI
	twine upload --repository testpypi dist/
```

## Platform-Specific Builds

### macOS Build
```bash
# Create macOS application bundle
mkdir -p build/Claude\ Clear.app/Contents/MacOS
mkdir -p build/Claude\ Clear.app/Contents/Resources

# Copy executable
cp src/cleaner.py "build/Claude Clear.app/Contents/MacOS/"
cp -r src/ "build/Claude Clear.app/Contents/MacOS/"

# Create Info.plist
cat > "build/Claude Clear.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>cleaner.py</string>
    <key>CFBundleIdentifier</key>
    <string>com.claudeclear.app</string>
    <key>CFBundleName</key>
    <string>Claude Clear</string>
    <key>CFBundleVersion</key>
    <string>1.0.0</string>
</dict>
</plist>
EOF

# Create DMG
hdiutil create -volname "Claude Clear" -srcfolder build/ -ov -format UDZO claude-clear.dmg
```

### Windows Build
```batch
@echo off
REM Create Windows executable
echo Creating Windows executable...

REM Create directory structure
mkdir build\claude-clear
mkdir build\claude-clear\src
mkdir build\claude-clear\scripts

REM Copy files
copy src\*.py build\claude-clear\src\
copy scripts\*.bat build\claude-clear\scripts\
copy requirements.txt build\claude-clear\
copy README.md build\claude-clear\

REM Create launcher
echo @echo off > build\claude-clear\claude-clear.bat
echo python src\cleaner.py %%* >> build\claude-clear\claude-clear.bat

REM Create installer (requires NSIS or similar)
echo "Installer creation requires NSIS or Inno Setup"
```

### Linux Build
```bash
# Create Linux package
mkdir -p build/claude-clear/usr/local/bin
mkdir -p build/claude-clear/usr/local/share/claude-clear
mkdir -p build/claude-clear/DEBIAN

# Copy files
cp src/cleaner.py build/claude-clear/usr/local/bin/
cp -r src/* build/claude-clear/usr/local/share/claude-clear/
cp scripts/*.sh build/claude-clear/usr/local/bin/

# Create control file for Debian package
cat > build/claude-clear/DEBIAN/control << EOF
Package: claude-clear
Version: 1.0.0
Section: utils
Priority: optional
Architecture: all
Depends: python3 (>= 3.8)
Maintainer: Your Name <your.email@example.com>
Description: Clean bloated Claude Code configuration files
 Claude Clear is a utility that removes accumulated chat history
 and cache data from Claude Code configuration files while preserving
 user settings and API keys.
EOF

# Build Debian package
dpkg-deb --build build/claude-clear
```

## Distribution Packaging

### Universal Distribution Script
```bash
#!/bin/bash
# build-universal.sh

set -e

VERSION=$(python -c "import cleaner; print(cleaner.__version__)")
DIST_NAME="claude-clear-v${VERSION}-universal"

echo "Building Claude Clear v${VERSION} universal distribution..."

# Create distribution directory
mkdir -p "$DIST_NAME"
cd "$DIST_NAME"

# Copy source files
cp -r ../src .
cp ../requirements*.txt .
cp ../README.md .
cp ../LICENSE .
cp -r ../scripts .

# Create platform-specific launchers
cat > run-cc-macos.sh << 'EOF'
#!/bin/bash
# macOS launcher for Claude Clear
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/src/cleaner.py" "$@"
EOF

cat > run-cc-linux.sh << 'EOF'
#!/bin/bash
# Linux launcher for Claude Clear
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
python3 "$SCRIPT_DIR/src/cleaner.py" "$@"
EOF

cat > run-cc-windows.bat << 'EOF'
@echo off
REM Windows launcher for Claude Clear
python src\cleaner.py %*
EOF

# Make launchers executable
chmod +x *.sh

# Create installation script
cat > install.sh << 'EOF'
#!/bin/bash
# Installation script for Claude Clear

set -e

INSTALL_DIR="/usr/local/bin"
SRC_DIR="$(pwd)"

echo "Installing Claude Clear..."

# Install launcher
sudo cp run-cc-*.sh "$INSTALL_DIR/"

# Create symlink
sudo ln -sf "$INSTALL_DIR/run-cc-linux.sh" "$INSTALL_DIR/claude-clear"

echo "Installation complete!"
echo "Run 'claude-clear --help' for usage information."
EOF

chmod +x install.sh

# Create archive
cd ..
tar -czf "${DIST_NAME}.tar.gz" "$DIST_NAME"
echo "Universal distribution created: ${DIST_NAME}.tar.gz"
```

## Continuous Integration Builds

### GitHub Actions Workflow
```yaml
# .github/workflows/build.yml
name: Build and Test

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        python-version: [3.8, 3.9, "3.10", "3.11"]

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        pip install -r requirements-dev.txt
    
    - name: Run tests
      run: |
        python -m pytest tests/ -v --cov=src/
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: "3.10"
    
    - name: Install build dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build twine
    
    - name: Build package
      run: |
        python -m build
    
    - name: Check package
      run: |
        twine check dist/*
    
    - name: Upload to PyPI
      if: startsWith(github.ref, 'refs/tags/')
      env:
        TWINE_USERNAME: __token__
        TWINE_PASSWORD: ${{ secrets.PYPI_API_TOKEN }}
      run: |
        twine upload dist/*
```

## Build Verification

### Quality Checks
```bash
# Run comprehensive build verification
make test        # Run all tests
make lint        # Check code quality
make format       # Format code
make build        # Build packages

# Verify package integrity
twine check dist/*

# Test installation from package
pip install dist/claude-clear-1.0.0-py3-none-any.whl
claude-clear --version
```

### Performance Testing
```bash
# Test with large configuration files
python -m pytest tests/performance/ -v

# Memory usage testing
python -m memory_profiler src/cleaner.py

# Execution time testing
time python src/cleaner.py --dry-run
```

## Troubleshooting Build Issues

### Common Issues

**Issue: "ModuleNotFoundError: No module named 'setuptools'"**
```bash
# Solution: Install setuptools
pip install --upgrade setuptools
```

**Issue: "Permission denied" during installation**
```bash
# Solution: Use user installation or virtual environment
pip install --user .
# or
python -m venv venv && source venv/bin/activate
```

**Issue: Build fails on Windows**
```bash
# Solution: Use Visual Studio Build Tools
# or
pip install --upgrade setuptools wheel
```

**Issue: "error: invalid command 'bdist_wheel'"**
```bash
# Solution: Install wheel
pip install wheel
```

### Debug Build Process
```bash
# Verbose build output
python -m build --verbose .

# Debug installation
pip install -v .

# Check build environment
python setup.py --help-commands
```

## Release Process

### Pre-Release Checklist
- [ ] All tests passing
- [ ] Code coverage >90%
- [ ] Documentation updated
- [ ] Version number updated
- [ ] CHANGELOG.md updated
- [ ] Security scan passed

### Release Steps
```bash
# 1. Update version
# Update version in setup.py and __init__.py

# 2. Run full test suite
make test
make lint

# 3. Build packages
make clean
make build

# 4. Verify packages
twine check dist/*

# 5. Create git tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 6. Upload to PyPI
twine upload dist/*

# 7. Create GitHub release
# Upload dist files to GitHub release
```

## Advanced Build Options

### Cross-Compilation
```bash
# Build for different Python versions
python3.8 -m build
python3.9 -m build
python3.10 -m build

# Build for different platforms
docker run --rm -v $(pwd):/workspace python:3.8 bash -c "cd /workspace && python -m build"
```

### Custom Build Hooks
```python
# setup.py with custom commands
from setuptools import setup
from setuptools.command.build_py import build_py

class CustomBuildCommand(build_py):
    """Custom build command"""
    
    def run(self):
        # Custom build logic
        print("Running custom build steps...")
        
        # Generate version file
        with open("src/version.txt", "w") as f:
            f.write("1.0.0")
        
        # Run standard build
        super().run()

setup(
    cmdclass={
        'build_py': CustomBuildCommand,
    },
    # ... other setup parameters
)
```

---

This build guide provides comprehensive instructions for building Claude Clear across different platforms and deployment scenarios. For additional help, refer to the troubleshooting section or open an issue on GitHub.