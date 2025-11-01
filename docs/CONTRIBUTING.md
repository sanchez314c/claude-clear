# Contributing to Claude Clear

Thank you for your interest in contributing to Claude Clear! This guide will help you get started with contributing to our project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Types](#contribution-types)
- [Pull Request Process](#pull-request-process)
- [Code Guidelines](#code-guidelines)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)
- [Community Guidelines](#community-guidelines)

## Getting Started

### Prerequisites

Before contributing, make sure you have:

- **Python 3.8+** installed on your system
- **Git** configured with your SSH keys
- **GitHub account** with two-factor authentication enabled
- **Development tools** (IDE/editor, terminal, etc.)

### First Steps

1. **Fork the Repository**
   ```bash
   # Fork the repository on GitHub
   # Then clone your fork
   git clone https://github.com/your-username/claude-clear.git
   cd claude-clear
   ```

2. **Set Up Remotes**
   ```bash
   # Add upstream remote
   git remote add upstream https://github.com/original-org/claude-clear.git
   
   # Verify remotes
   git remote -v
   ```

3. **Create Development Environment**
   ```bash
   # Create virtual environment
   python -m venv venv
   source venv/bin/activate  # Linux/macOS
   # venv\Scripts\activate   # Windows
   
   # Install dependencies
   pip install -r requirements-dev.txt
   pip install -e .
   ```

## Development Setup

### Environment Configuration

1. **Pre-commit Hooks** (Recommended)
   ```bash
   # Install pre-commit
   pip install pre-commit
   
   # Install hooks
   pre-commit install
   
   # Run manually
   pre-commit run --all-files
   ```

2. **IDE Configuration**
   - **VS Code**: Install Python extension and recommended extensions
   - **PyCharm**: Configure Python interpreter and code style
   - **Vim/Neovim**: Use python-mode and linting plugins

3. **Development Tools**
   ```bash
   # Verify tools are working
   python --version
   git --version
   pytest --version
   black --version
   flake8 --version
   ```

### Project Structure

```
claude-clear/
├── src/                    # Source code
│   ├── cleaner.py           # Main application
│   ├── components/          # Core components
│   └── utils/              # Utility functions
├── tests/                  # Test suite
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   └── fixtures/           # Test data
├── docs/                   # Documentation
├── scripts/                # Build and utility scripts
├── .github/               # GitHub workflows
└── requirements/          # Dependencies
```

## Contribution Types

### Code Contributions

#### Bug Fixes
1. **Find an Issue**
   - Browse [open issues](https://github.com/your-org/claude-clear/issues)
   - Look for "good first issue" or "help wanted" labels
   - Comment that you're working on it

2. **Reproduce the Bug**
   ```bash
   # Create minimal reproduction case
   git checkout -b fix/bug-description
   # Write test that reproduces issue
   python -m pytest tests/test_bug_reproduction.py -v
   ```

3. **Fix the Bug**
   - Write code to fix the issue
   - Ensure all tests pass
   - Add regression tests if needed

#### New Features
1. **Propose Feature**
   - Open an issue with "feature request" label
   - Describe the problem and proposed solution
   - Wait for maintainer approval

2. **Implement Feature**
   ```bash
   # Create feature branch
   git checkout -b feature/your-feature-name
   
   # Follow development workflow
   # Write tests first (TDD)
   # Implement feature
   # Update documentation
   ```

#### Performance Improvements
1. **Identify Bottlenecks**
   - Use profiling tools
   - Measure before and after
   - Focus on user-impacting improvements

2. **Implement Optimizations**
   - Maintain code readability
   - Add performance tests
   - Document trade-offs

### Non-Code Contributions

#### Documentation
1. **Improve Existing Docs**
   - Fix typos and grammar
   - Add missing information
   - Improve clarity and examples

2. **Add New Documentation**
   - Write tutorials and guides
   - Create API documentation
   - Add troubleshooting sections

#### Testing
1. **Add Test Coverage**
   - Write unit tests for uncovered code
   - Add integration tests for workflows
   - Improve test reliability

2. **Test Infrastructure**
   - Improve test performance
   - Add new test tools
   - Enhance CI/CD pipeline

#### Community Support
1. **Answer Questions**
   - Help in GitHub Discussions
   - Respond to issues with guidance
   - Share knowledge and experiences

2. **Review Contributions**
   - Review pull requests
   - Provide constructive feedback
   - Help maintain quality standards

## Pull Request Process

### Before Opening PR

1. **Prepare Your Branch**
   ```bash
   # Ensure your branch is up to date
   git checkout develop
   git pull upstream develop
   git checkout feature/your-feature
   git rebase develop
   
   # Clean up commit history
   git rebase -i develop  # squash/rearrange commits
   ```

2. **Run Quality Checks**
   ```bash
   # Run full test suite
   make test
   
   # Check code formatting
   make format
   make lint
   
   # Run security checks
   make security-check
   ```

3. **Update Documentation**
   - Update relevant documentation
   - Add changelog entry
   - Update README if needed

### Opening Pull Request

1. **Create PR**
   - Use descriptive title
   - Fill out PR template completely
   - Link to relevant issues
   - Add appropriate labels

2. **PR Description Template**
   ```markdown
   ## Description
   Brief description of changes and their purpose.
   
   ## Type of Change
   - [ ] Bug fix (non-breaking change which fixes an issue)
   - [ ] New feature (non-breaking change which adds functionality)
   - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
   - [ ] Documentation update
   
   ## Testing
   - [ ] All new and existing tests pass
   - [ ] Code follows project style guidelines
   - [ ] Self-review of code completed
   - [ ] Code is commented appropriately
   
   ## Checklist
   - [ ] My code follows the style guidelines of this project
   - [ ] I have performed a self-review of my own code
   - [ ] I have commented my code, particularly in hard-to-understand areas
   - [ ] I have made corresponding changes to the documentation
   - [ ] My changes generate no new warnings
   - [ ] I have added tests that prove my fix is effective or that my feature works
   - [ ] New and existing unit tests pass locally with my changes
   - [ ] Any dependent changes have been merged and published in downstream modules
   ```

### During Review

1. **Respond to Feedback**
   - Address reviewer comments promptly
   - Explain your reasoning when needed
   - Make requested changes
   - Be open to suggestions

2. **Update Your PR**
   ```bash
   # Make changes based on feedback
   git add .
   git commit -m "address reviewer feedback"
   git push origin feature/your-feature
   ```

3. **Maintain Communication**
   - Keep PR discussion focused
   - Ask for clarification when needed
   - Thank reviewers for their time
   - Be patient with the review process

## Code Guidelines

### Style Guidelines

#### Python Code Style
```python
# Follow PEP 8 standards
# Use Black for formatting
# Use isort for import sorting

# Good example:
def clean_configuration(config_path: Path, backup: bool = True) -> CleanResult:
    """
    Clean Claude Code configuration file.
    
    Args:
        config_path: Path to configuration file
        backup: Whether to create backup
        
    Returns:
        CleanResult with operation details
    """
    cleaner = ConfigurationCleaner(config_path)
    return cleaner.clean(backup=backup)


# Bad example:
def cleanConfig(path, backup=True):
    # clean the config
    c=ConfigurationCleaner(path)
    return c.clean(backup)
```

#### Naming Conventions
- **Variables**: `snake_case`
- **Functions**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private**: `_leading_underscore`

#### Documentation Standards
```python
def process_data(data: List[str], threshold: Optional[int] = None) -> Dict[str, Any]:
    """
    Process input data and return results.
    
    Args:
        data: List of strings to process
        threshold: Optional minimum count threshold
        
    Returns:
        Dictionary containing processed results and statistics
        
    Raises:
        ValueError: If data is empty or threshold is negative
        
    Example:
        >>> process_data(["a", "b", "c"], threshold=2)
        {"processed": ["A", "B", "C"], "count": 3, "threshold_met": True}
    """
    pass
```

### Architecture Guidelines

#### Separation of Concerns
```python
# Good: Separate responsibilities
class ConfigurationReader:
    def read(self, path: Path) -> Dict[str, Any]:
        pass

class ConfigurationCleaner:
    def clean(self, data: Dict[str, Any]) -> Dict[str, Any]:
        pass

class ConfigurationWriter:
    def write(self, path: Path, data: Dict[str, Any]) -> None:
        pass

# Bad: Mixed responsibilities
class ConfigurationManager:
    def read_clean_and_write(self, path: Path) -> None:
        # Reads, cleans, and writes in one method
        pass
```

#### Error Handling
```python
# Good: Specific error handling
try:
    config = self.load_configuration(config_path)
except FileNotFoundError:
    logger.error(f"Configuration file not found: {config_path}")
    raise ConfigurationError(f"File not found: {config_path}")
except json.JSONDecodeError as e:
    logger.error(f"Invalid JSON in configuration: {e}")
    raise ConfigurationError(f"Invalid JSON: {e}")

# Bad: Generic error handling
try:
    config = self.load_configuration(config_path)
except:
    logger.error("Something went wrong")
    return None
```

## Testing Guidelines

### Test Structure

#### Test Organization
```python
# tests/unit/test_cleaner.py
import pytest
from unittest.mock import Mock, patch
from src.cleaner import ClaudeCleaner

class TestClaudeCleaner:
    def setup_method(self):
        """Setup for each test method"""
        self.cleaner = ClaudeCleaner()
        self.test_config = "tests/fixtures/sample_config.json"
    
    def teardown_method(self):
        """Cleanup after each test method"""
        if hasattr(self, 'cleaner'):
            del self.cleaner
    
    def test_clean_configuration_success(self):
        """Test successful configuration cleaning"""
        # Arrange
        expected_size_reduction = 0.95
        
        # Act
        result = self.cleaner.clean(self.test_config)
        
        # Assert
        assert result.success is True
        assert result.size_reduction >= expected_size_reduction
        assert result.backup_path.exists()
```

#### Test Categories
1. **Unit Tests**: Test individual functions/classes
2. **Integration Tests**: Test component interactions
3. **End-to-End Tests**: Test complete workflows
4. **Performance Tests**: Validate performance requirements

### Writing Good Tests

#### Test Coverage
```python
# Test all code paths
def test_clean_configuration_with_various_scenarios(self):
    """Test cleaning with different configuration scenarios"""
    
    # Test normal case
    result = self.cleaner.clean("tests/fixtures/normal_config.json")
    assert result.success is True
    
    # Test edge case - empty configuration
    result = self.cleaner.clean("tests/fixtures/empty_config.json")
    assert result.success is True
    assert result.size_reduction == 0.0
    
    # Test error case - invalid JSON
    with pytest.raises(ConfigurationError):
        self.cleaner.clean("tests/fixtures/invalid_config.json")
```

#### Test Data Management
```python
# Use fixtures for test data
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

def test_clean_with_sample_config(self, sample_config):
    """Test cleaning with sample configuration"""
    cleaner = ConfigurationCleaner()
    result = cleaner.clean_data(sample_config)
    
    assert "history" not in result["projects"]["test_project"]
    assert "settings" in result["projects"]["test_project"]
```

### Running Tests

#### Local Testing
```bash
# Run all tests
make test

# Run specific test file
pytest tests/unit/test_cleaner.py -v

# Run with coverage
pytest tests/ --cov=src/ --cov-report=html

# Run performance tests
pytest tests/performance/ -v
```

#### Continuous Integration
- Tests run automatically on pull requests
- All tests must pass before merge
- Coverage requirements must be met
- Performance benchmarks must pass

## Documentation Guidelines

### Documentation Types

#### Code Documentation
```python
def clean_configuration(config_path: str, backup: bool = True) -> bool:
    """
    Clean Claude Code configuration by removing chat history.
    
    This function processes the Claude Code configuration file located at
    config_path, removes accumulated chat history and conversation data,
    and preserves user settings and API keys.
    
    Args:
        config_path: Absolute path to the .claude.json file
        backup: If True, creates a timestamped backup before cleaning
        
    Returns:
        True if cleaning was successful, False otherwise
        
    Raises:
        FileNotFoundError: If config_path doesn't exist
        PermissionError: If insufficient permissions to modify file
        json.JSONDecodeError: If configuration file is invalid JSON
        
    Example:
        >>> success = clean_configuration("/home/user/.claude.json")
        >>> print(f"Cleaning successful: {success}")
        Cleaning successful: True
        
    Note:
        The function creates a backup with timestamp format:
        .claude.json.backup.YYYYMMDD_HHMMSS
    """
    pass
```

#### README Documentation
```markdown
# Claude Clear

## Quick Start

```bash
# Install
pip install claude-clear

# Run
claude-clear --dry-run
claude-clear
```

## Features

- 🧹 **Automatic Cleaning**: Removes chat history and cache data
- 💾 **Safe Backups**: Creates timestamped backups before changes
- 🔒 **Data Preservation**: Preserves settings, API keys, and MCP configs
- 📊 **Size Reduction**: Typically reduces 27MB to <100KB (99.6% savings)
```

#### API Documentation
```markdown
## API Reference

### claude_clear.clean(config_path, backup=True)

Clean Claude Code configuration file.

**Parameters:**
- `config_path` (str): Path to configuration file
- `backup` (bool, optional): Create backup before cleaning (default: True)

**Returns:**
- `CleanResult`: Object containing operation results

**Example:**
```python
from claude_clear import clean

result = clean("/home/user/.claude.json")
print(f"Size reduced by {result.size_reduction:.1%}")
```
```

### Documentation Updates

#### When to Update Documentation
- Adding new features or functions
- Changing existing behavior
- Fixing bugs in documentation
- Adding new examples or tutorials
- Responding to user questions

#### Documentation Review Process
1. **Write Documentation**
   - Clear, concise language
   - Include examples and code snippets
   - Add cross-references
   - Use consistent formatting

2. **Review Documentation**
   - Technical accuracy check
   - Clarity and completeness review
   - Example verification
   - Link validation

3. **Update Documentation**
   - Commit with documentation changes
   - Include in pull request
   - Request documentation review
   - Update changelog

## Community Guidelines

### Communication Standards

#### GitHub Issues
- **Search First**: Check if issue already exists
- **Use Templates**: Fill out issue templates completely
- **Be Specific**: Provide detailed information and reproduction steps
- **One Issue**: Keep each issue focused on one problem
- **Follow Up**: Respond to maintainer questions promptly

#### Pull Requests
- **Small Changes**: Keep PRs focused and manageable
- **Clear Description**: Explain what changes and why
- **Testing**: Ensure all tests pass
- **Documentation**: Update relevant documentation
- **Patience**: Allow time for review and feedback

#### Discussions and Community
- **Be Respectful**: Treat all community members with respect
- **Stay On Topic**: Keep discussions relevant to the project
- **Help Others**: Share knowledge and assist newcomers
- **Learn**: Be open to learning from others
- **Constructive**: Provide helpful, constructive feedback

### Getting Help

#### When You Need Help
1. **Search First**: Check documentation and existing issues
2. **Ask Specific Questions**: Provide context and what you've tried
3. **Use Appropriate Channels**: Issues for bugs, Discussions for questions
4. **Be Patient**: Community members volunteer their time

#### Where to Get Help
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **Documentation**: Check docs/ folder for comprehensive guides
- **Code Examples**: Look at tests for usage examples

## Recognition and Appreciation

### Contributor Recognition
- **Contributors List**: Maintained in README.md
- **Release Notes**: Contributors mentioned in changelog
- **Community Highlights**: Featured in project communications
- **Special Recognition**: Outstanding contributions acknowledged

### Ways to Contribute
- **Code**: Bug fixes, features, performance improvements
- **Documentation**: Guides, tutorials, API docs
- **Testing**: Test cases, bug reports, feedback
- **Community**: Support, outreach, advocacy
- **Design**: UI/UX improvements, graphics, branding

## Additional Resources

### Learning Resources
- [Python Style Guide](https://pep8.org/)
- [Testing Best Practices](https://docs.pytest.org/)
- [Git Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/)
- [Open Source Guides](https://opensource.guide/)

### Project Resources
- [Project Documentation](docs/)
- [API Reference](API.md)
- [Architecture Guide](ARCHITECTURE.md)
- [Development Workflow](WORKFLOW.md)

### Community Resources
- [GitHub Discussions](https://github.com/your-org/claude-clear/discussions)
- [Issue Tracker](https://github.com/your-org/claude-clear/issues)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Security Policy](SECURITY.md)

---

Thank you for contributing to Claude Clear! Your contributions help make this project better for everyone. If you have any questions about contributing, please don't hesitate to ask in our [GitHub Discussions](https://github.com/your-org/claude-clear/discussions) or open an issue.

**Happy Contributing!** 🚀