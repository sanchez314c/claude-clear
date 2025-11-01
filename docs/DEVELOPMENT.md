# Development Guide

## Overview

This guide covers setting up a development environment for Claude Clear, understanding the codebase, and contributing effectively to the project.

## Table of Contents

- [Environment Setup](#environment-setup)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Debugging Guide](#debugging-guide)
- [Testing Guide](#testing-guide)
- [Code Style](#code-style)
- [Common Tasks](#common-tasks)

## Environment Setup

### Prerequisites

Before starting development, ensure you have:

- **Python 3.8+** with pip
- **Git** version 2.25+
- **IDE/Editor** (VS Code, PyCharm, etc.)
- **Terminal** with basic Unix commands
- **Virtual Environment** tool (venv, conda, pipenv)

### Initial Setup

#### 1. Clone Repository
```bash
# Fork the repository on GitHub first
git clone https://github.com/your-username/claude-clear.git
cd claude-clear

# Add upstream remote
git remote add upstream https://github.com/original-org/claude-clear.git
git fetch upstream
```

#### 2. Create Virtual Environment
```bash
# Using venv (recommended)
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Using conda
conda create -n claude-clear python=3.9
conda activate claude-clear

# Using pipenv
pipenv install
pipenv shell
```

#### 3. Install Dependencies
```bash
# Install development dependencies
pip install -r requirements-dev.txt

# Install package in development mode
pip install -e .

# Verify installation
claude-clear --version
```

### Development Tools Setup

#### VS Code Configuration
```json
// .vscode/settings.json
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": false,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "python.sortImports.args": ["--profile", "black"],
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "files.exclude": {
        "**/__pycache__": true,
        "**/*.pyc": true,
        ".pytest_cache": true,
        ".coverage": true,
        "htmlcov": true
    }
}
```

#### PyCharm Configuration
1. **Project Interpreter**: Set to venv Python
2. **Code Style**: Configure Black and isort
3. **Testing**: Configure pytest
4. **Version Control**: Set up Git integration

#### Pre-commit Hooks
```bash
# Install pre-commit
pip install pre-commit

# Install hooks
pre-commit install

# Test hooks
pre-commit run --all-files
```

## Project Structure

### Directory Layout
```
claude-clear/
├── src/                    # Source code
│   ├── cleaner.py           # Main application entry point
│   ├── components/          # Core components
│   │   ├── __init__.py
│   │   ├── parser.py       # Configuration parsing
│   │   ├── cleaner.py      # Data cleaning logic
│   │   ├── backup.py       # Backup management
│   │   └── validator.py    # Validation engine
│   ├── utils/              # Utility functions
│   │   ├── __init__.py
│   │   ├── logging.py      # Logging configuration
│   │   ├── colors.py       # Terminal colors
│   │   ├── platform.py     # Platform detection
│   │   └── errors.py      # Error definitions
│   └── __init__.py         # Package initialization
├── tests/                  # Test suite
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   ├── e2e/               # End-to-end tests
│   ├── performance/        # Performance tests
│   └── fixtures/           # Test data
├── docs/                   # Documentation
├── scripts/                # Build and utility scripts
├── .github/               # GitHub workflows
├── requirements/            # Dependencies
│   ├── requirements.txt     # Production dependencies
│   └── requirements-dev.txt # Development dependencies
├── Makefile               # Build commands
├── pyproject.toml         # Project configuration
└── README.md              # Project overview
```

### Core Components

#### Main Application (`src/cleaner.py`)
```python
class ClaudeClear:
    """Main application class for Claude Clear."""
    
    def __init__(self, config_path: Optional[Path] = None):
        self.config_path = config_path or self._get_default_config_path()
        self.backup_manager = BackupManager()
        self.cleaner = ConfigurationCleaner()
        self.validator = ValidationEngine()
    
    def run(self, dry_run: bool = False) -> CleanResult:
        """Run the cleaning process."""
        pass
```

#### Configuration Parser (`src/components/parser.py`)
```python
class ConfigurationParser:
    """Parse and validate Claude Code configuration files."""
    
    def load(self, path: Path) -> Dict[str, Any]:
        """Load configuration from file."""
        pass
    
    def validate_structure(self, data: Dict[str, Any]) -> bool:
        """Validate configuration structure."""
        pass
```

#### Data Cleaner (`src/components/cleaner.py`)
```python
class ConfigurationCleaner:
    """Clean configuration data by removing chat history."""
    
    def clean(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Clean configuration data."""
        pass
    
    def _clean_project_data(self, project: Dict[str, Any]) -> Dict[str, Any]:
        """Clean individual project data."""
        pass
```

## Development Workflow

### Daily Workflow

#### 1. Start Development
```bash
# Activate environment
source venv/bin/activate

# Pull latest changes
git checkout develop
git pull upstream develop

# Create feature branch
git checkout -b feature/your-feature-name
```

#### 2. Make Changes
```bash
# Write code
# Run tests frequently
pytest tests/unit/test_your_feature.py -v

# Check code style
black src/
isort src/
flake8 src/
```

#### 3. Commit Changes
```bash
# Stage changes
git add .

# Commit with conventional message
git commit -m "feat: add new cleaning algorithm"

# Push to your fork
git push origin feature/your-feature-name
```

#### 4. Create Pull Request
1. Go to GitHub repository
2. Click "New Pull Request"
3. Select feature branch
4. Fill out PR template
5. Request review

### Branch Strategy

#### Main Branches
- **main**: Stable, production-ready code
- **develop**: Integration branch for features
- **feature/***: Feature development branches
- **fix/***: Bug fix branches
- **hotfix/***: Emergency fixes

#### Branch Naming
```bash
# Features
feature/configuration-validation
feature/performance-optimization
feature/user-interface

# Bug fixes
fix/memory-leak-in-parser
fix/windows-path-handling
fix/backup-creation-failure

# Hotfixes
hotfix/critical-security-vulnerability
hotfix/data-corruption-issue
```

### Commit Guidelines

#### Conventional Commits
```bash
# Format: <type>[optional scope]: <description>

# Types
feat:     New feature
fix:      Bug fix
docs:     Documentation changes
style:    Formatting changes
refactor: Code refactoring
test:     Test additions/changes
chore:    Build process or auxiliary tool changes

# Examples
feat: add configuration file validation
fix: resolve Windows path separator issue
docs: update API documentation
test: add integration tests for backup system
refactor: simplify JSON parsing logic
```

#### Commit Message Structure
```bash
# Good commit message
feat(parser): add streaming JSON parser for large files

Add streaming JSON parser to handle configuration files larger than
50MB without loading entire file into memory. This reduces
memory usage from 200MB to 20MB for large files.

Closes #123
```

## Debugging Guide

### Debugging Tools

#### Python Debugger (pdb)
```python
# Add breakpoints in code
import pdb; pdb.set_trace()

# Or use breakpoint() (Python 3.7+)
breakpoint()

# Run with debugger
python -m pdb src/cleaner.py
```

#### IDE Debugging
```python
# VS Code launch configuration (.vscode/launch.json)
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Claude Clear",
            "type": "python",
            "request": "launch",
            "program": "${workspaceFolder}/src/cleaner.py",
            "args": ["--debug", "--dry-run"],
            "console": "integratedTerminal",
            "cwd": "${workspaceFolder}"
        }
    ]
}
```

#### Logging Configuration
```python
# Enable debug logging
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# Or use environment variable
import os
log_level = os.getenv('LOG_LEVEL', 'INFO')
logging.basicConfig(level=getattr(logging, log_level))
```

### Common Debugging Scenarios

#### Debugging Configuration Loading
```python
def load_configuration(path: Path) -> Dict[str, Any]:
    logger.debug(f"Loading configuration from: {path}")
    
    if not path.exists():
        logger.error(f"Configuration file not found: {path}")
        raise FileNotFoundError(f"File not found: {path}")
    
    try:
        with open(path, 'r') as f:
            data = json.load(f)
        logger.debug(f"Configuration loaded successfully")
        return data
    except json.JSONDecodeError as e:
        logger.error(f"Invalid JSON in configuration: {e}")
        raise
```

#### Debugging File Operations
```python
def create_backup(path: Path) -> Path:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = path.with_suffix(f'.json.backup.{timestamp}')
    
    logger.debug(f"Creating backup: {backup_path}")
    
    try:
        shutil.copy2(path, backup_path)
        logger.info(f"Backup created: {backup_path}")
        return backup_path
    except Exception as e:
        logger.error(f"Backup creation failed: {e}")
        raise
```

### Performance Debugging

#### Profiling Memory Usage
```bash
# Using memory_profiler
pip install memory_profiler

# Run with memory profiling
python -m memory_profiler src/cleaner.py

# Or add to code
@profile
def clean_large_config(data: Dict[str, Any]) -> Dict[str, Any]:
    # Function to profile
    pass
```

#### Profiling Execution Time
```bash
# Using cProfile
python -m cProfile -s time src/cleaner.py

# Or use line_profiler
pip install line_profiler
kernprof -l -v src/cleaner.py
```

## Testing Guide

### Test Structure

#### Unit Tests
```python
# tests/unit/test_cleaner.py
import pytest
from unittest.mock import Mock, patch
from src.cleaner import ClaudeClear

class TestClaudeClear:
    def setup_method(self):
        """Setup for each test method"""
        self.cleaner = ClaudeClear()
    
    def test_clean_configuration_success(self):
        """Test successful configuration cleaning"""
        # Arrange
        test_config = {"projects": {}, "userSettings": {}}
        
        # Act
        result = self.cleaner.clean(test_config)
        
        # Assert
        assert result.success is True
        assert result.size_reduction > 0
```

#### Integration Tests
```python
# tests/integration/test_workflow.py
import pytest
import tempfile
from pathlib import Path
from src.cleaner import ClaudeClear

class TestWorkflow:
    def test_full_cleaning_workflow(self):
        """Test complete cleaning workflow"""
        with tempfile.TemporaryDirectory() as temp_dir:
            # Create test configuration
            config_path = Path(temp_dir) / ".claude.json"
            # ... setup test data
            
            # Run cleaning
            cleaner = ClaudeClear(config_path)
            result = cleaner.run()
            
            # Verify results
            assert result.success is True
            assert result.backup_path.exists()
```

### Running Tests

#### Local Testing
```bash
# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/unit/test_cleaner.py -v

# Run with coverage
pytest tests/ --cov=src/ --cov-report=html

# Run performance tests
pytest tests/performance/ -v
```

#### Test Categories
```bash
# Unit tests only
pytest tests/unit/ -v

# Integration tests only
pytest tests/integration/ -v

# End-to-end tests only
pytest tests/e2e/ -v

# Performance tests only
pytest tests/performance/ -v
```

### Writing Tests

#### Test Data Management
```python
# tests/conftest.py
import pytest
import tempfile
import json
from pathlib import Path

@pytest.fixture
def sample_config():
    """Provide sample configuration for testing"""
    return {
        "projects": {
            "test_project": {
                "history": ["chat1", "chat2"],
                "settings": {"theme": "dark"}
            }
        },
        "userSettings": {"api_key": "test_key"}
    }

@pytest.fixture
def temp_config_file(sample_config):
    """Create temporary configuration file"""
    with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as f:
        json.dump(sample_config, f)
        return Path(f.name)
```

#### Mock Testing
```python
# Test with mocks
def test_backup_creation_with_mock(self):
    """Test backup creation using mocks"""
    with patch('shutil.copy2') as mock_copy:
        mock_copy.return_value = True
        
        result = self.cleaner._create_backup(Path("test.json"))
        
        mock_copy.assert_called_once()
        assert result is not None
```

## Code Style

### Formatting Standards

#### Black Configuration
```toml
# pyproject.toml
[tool.black]
line-length = 88
target-version = ['py38', 'py39', 'py310']
include = '\.pyi?$'
extend-exclude = '''
/(
  # directories
  \.eggs
  | \.git
  | \.hg
  | \.mypy_cache
  | \.tox
  | \.venv
  | build
  | dist
)/
'''
```

#### isort Configuration
```toml
# pyproject.toml
[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
known_first_party = ["src"]
```

#### Linting Configuration
```ini
# .flake8
[flake8]
max-line-length = 88
extend-ignore = E203, W503
exclude = 
    .git,
    __pycache__,
    build,
    dist,
    .venv,
    .eggs
per-file-ignores =
    __init__.py:F401
```

### Code Quality Standards

#### Type Hints
```python
from typing import Dict, List, Optional, Union, Any

def process_data(
    data: List[str], 
    threshold: Optional[int] = None
) -> Dict[str, Any]:
    """Process input data with optional threshold."""
    pass
```

#### Error Handling
```python
# Custom exceptions
class ConfigurationError(Exception):
    """Base exception for configuration errors."""
    pass

class InvalidFormatError(ConfigurationError):
    """Raised when configuration format is invalid."""
    pass

# Usage
try:
    config = load_configuration(path)
except InvalidFormatError as e:
    logger.error(f"Invalid configuration format: {e}")
    raise
```

#### Documentation Standards
```python
def clean_configuration(
    config_path: Path, 
    backup: bool = True,
    dry_run: bool = False
) -> CleanResult:
    """
    Clean Claude Code configuration file.
    
    Args:
        config_path: Path to the configuration file
        backup: Whether to create a backup before cleaning
        dry_run: If True, only show what would be cleaned
        
    Returns:
        CleanResult object with operation details
        
    Raises:
        FileNotFoundError: If configuration file doesn't exist
        PermissionError: If insufficient permissions
        InvalidFormatError: If configuration format is invalid
        
    Example:
        >>> result = clean_configuration(Path("/home/user/.claude.json"))
        >>> print(f"Size reduced: {result.size_reduction:.1%}")
    """
    pass
```

## Common Tasks

### Adding New Features

#### 1. Feature Development Process
```bash
# Create feature branch
git checkout -b feature/new-feature-name

# Write tests first (TDD)
pytest tests/unit/test_new_feature.py -v  # Should fail initially

# Implement feature
# Write code to make tests pass

# Run full test suite
pytest tests/ -v

# Update documentation
# Update relevant documentation files
```

#### 2. Feature Implementation Example
```python
# src/components/new_feature.py
from typing import Dict, Any
import logging

logger = logging.getLogger(__name__)

class NewFeature:
    """New feature implementation."""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
    
    def process(self) -> Dict[str, Any]:
        """Process configuration with new feature."""
        logger.debug("Processing with new feature")
        
        # Implementation logic
        result = self._implement_logic()
        
        logger.info("New feature processing completed")
        return result
    
    def _implement_logic(self) -> Dict[str, Any]:
        """Implement core logic."""
        pass
```

### Fixing Bugs

#### 1. Bug Fix Process
```bash
# Create bug fix branch
git checkout -b fix/bug-description

# Reproduce bug with test
pytest tests/unit/test_bug_reproduction.py -v

# Fix bug
# Modify code to fix the issue

# Verify fix
pytest tests/unit/test_bug_fix.py -v

# Add regression test
# Ensure bug doesn't reoccur
```

#### 2. Bug Fix Example
```python
# Before fix
def get_config_path() -> str:
    return "~/.claude.json"  # Doesn't expand ~

# After fix
from pathlib import Path
import os

def get_config_path() -> Path:
    """Get configuration file path with proper expansion."""
    return Path(os.path.expanduser("~/.claude.json"))
```

### Performance Optimization

#### 1. Optimization Process
```bash
# Profile current performance
python -m cProfile -s time src/cleaner.py

# Identify bottlenecks
# Look for high time/memory usage functions

# Implement optimizations
# Focus on identified bottlenecks

# Benchmark improvements
# Measure before and after performance
```

#### 2. Optimization Example
```python
# Before optimization
def load_large_config(path: Path) -> Dict[str, Any]:
    with open(path, 'r') as f:
        return json.load(f)  # Loads entire file into memory

# After optimization
import ijson  # Streaming JSON parser

def load_large_config(path: Path) -> Dict[str, Any]:
    """Load large configuration file using streaming parser."""
    with open(path, 'rb') as f:
        return ijson.load(f)  # Streams data, lower memory usage
```

### Documentation Updates

#### 1. Documentation Process
```bash
# Identify documentation needs
# Check what needs updating for your changes

# Update documentation
# Edit relevant .md files

# Test documentation
# Ensure examples work
# Check links and formatting

# Commit documentation changes
git add docs/
git commit -m "docs: update API documentation for new feature"
```

#### 2. Documentation Example
```markdown
## API Reference

### clean_configuration(config_path, backup=True)

Clean Claude Code configuration file.

**Parameters:**
- `config_path` (str): Path to configuration file
- `backup` (bool): Create backup before cleaning (default: True)

**Returns:**
- `CleanResult`: Object containing operation results

**Example:**
```python
from claude_clear import clean_configuration

result = clean_configuration("/home/user/.claude.json")
print(f"Size reduced: {result.size_reduction:.1%}")
```

**New in version 1.1.0:** Added `dry_run` parameter
```

## Additional Resources

### Development Tools
- **Python**: [Official Documentation](https://docs.python.org/3/)
- **Testing**: [pytest Documentation](https://docs.pytest.org/)
- **Code Style**: [Black Documentation](https://black.readthedocs.io/)
- **Type Hints**: [typing Documentation](https://docs.python.org/3/library/typing.html)

### Project Resources
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)
- **API Reference**: [API.md](API.md)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Code of Conduct**: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

### Community Resources
- **GitHub Issues**: [Report bugs](https://github.com/your-org/claude-clear/issues)
- **GitHub Discussions**: [Ask questions](https://github.com/your-org/claude-clear/discussions)
- **Discord/Slack**: Join community channels
- **Email**: development@claude-clear.org

---

This development guide should help you get started with contributing to Claude Clear. For additional help, don't hesitate to reach out to the community through the channels listed above.

Happy coding! 🚀