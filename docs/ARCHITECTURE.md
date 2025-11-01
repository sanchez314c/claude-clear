# Architecture Documentation

## System Overview

Claude Clear is a Python-based command-line utility designed to clean bloated Claude Code configuration files while preserving essential user data. The architecture follows a modular design with clear separation of concerns.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Claude Clear System                      │
├─────────────────────────────────────────────────────────────┤
│  CLI Interface Layer                                       │
│  ├── Argument Parser                                      │
│  ├── Platform Launchers                                    │
│  └── Output Formatting                                     │
├─────────────────────────────────────────────────────────────┤
│  Core Processing Layer                                     │
│  ├── Configuration Parser                                  │
│  ├── Data Cleaner                                          │
│  ├── Backup Manager                                        │
│  └── Validation Engine                                      │
├─────────────────────────────────────────────────────────────┤
│  Data Access Layer                                         │
│  ├── File System Operations                                │
│  ├── JSON Processing                                       │
│  └── Path Management                                       │
├─────────────────────────────────────────────────────────────┤
│  Utility Layer                                            │
│  ├── Logging System                                        │
│  ├── Color Output                                          │
│  ├── Error Handling                                        │
│  └── Platform Detection                                   │
└─────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. CLI Interface Layer

**Location**: `src/cleaner.py` (main entry point)

**Responsibilities**:
- Parse command-line arguments
- Route to appropriate processing functions
- Format and display output
- Handle user interaction

**Key Classes**:
- `ArgumentParser`: Command-line argument processing
- `OutputFormatter`: Terminal output formatting
- `ProgressIndicator`: User feedback during operations

### 2. Configuration Parser

**Location**: `src/cleaner.py` (ConfigurationParser class)

**Responsibilities**:
- Read and parse `~/.claude.json`
- Validate JSON structure
- Extract configuration data
- Identify data fields for cleaning

**Key Methods**:
```python
def load_configuration(self) -> dict
def validate_structure(self, data: dict) -> bool
def identify_cleanable_fields(self, data: dict) -> list
```

### 3. Data Cleaner

**Location**: `src/cleaner.py` (DataCleaner class)

**Responsibilities**:
- Remove chat history and conversation data
- Preserve user settings and configurations
- Maintain data integrity
- Generate cleaning statistics

**Key Methods**:
```python
def clean_project_data(self, project: dict) -> dict
def clean_global_data(self, data: dict) -> dict
def calculate_size_reduction(self, original: dict, cleaned: dict) -> dict
```

### 4. Backup Manager

**Location**: `src/cleaner.py` (BackupManager class)

**Responsibilities**:
- Create timestamped backups
- Manage backup rotation
- Provide restore functionality
- Validate backup integrity

**Key Methods**:
```python
def create_backup(self, file_path: Path) -> Path
def restore_from_backup(self, backup_path: Path) -> bool
def cleanup_old_backups(self, keep_count: int = 5) -> None
```

### 5. Validation Engine

**Location**: `src/cleaner.py` (ValidationEngine class)

**Responsibilities**:
- Validate JSON syntax
- Check file permissions
- Verify configuration structure
- Ensure data consistency

**Key Methods**:
```python
def validate_json_syntax(self, file_path: Path) -> bool
def validate_file_permissions(self, file_path: Path) -> bool
def validate_configuration_structure(self, data: dict) -> bool
```

## Data Flow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   CLI Args  │───▶│   Parser    │───▶│  Validator  │───▶│  Backup     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                                                                │
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Output    │◀───│  Cleaner    │◀───│   Loader    │◀───│   Manager   │
│ Formatter   │    └─────────────┘    └─────────────┘    └─────────────┘
└─────────────┘
```

## File Structure

```
src/
├── cleaner.py              # Main application entry point
├── components/             # Core processing components
│   ├── __init__.py
│   ├── parser.py          # Configuration parsing
│   ├── cleaner.py         # Data cleaning logic
│   ├── backup.py          # Backup management
│   └── validator.py       # Validation engine
├── utils/                 # Utility functions
│   ├── __init__.py
│   ├── logging.py         # Logging configuration
│   ├── colors.py          # Terminal color output
│   ├── platform.py       # Platform detection
│   └── errors.py         # Error definitions
└── tests/                 # Test suite
    ├── test_cleaner.py
    ├── test_backup.py
    └── test_validation.py
```

## Design Patterns

### 1. Strategy Pattern
Used for different cleaning strategies based on configuration versions:

```python
class CleaningStrategy:
    def clean(self, data: dict) -> dict:
        pass

class V1CleaningStrategy(CleaningStrategy):
    def clean(self, data: dict) -> dict:
        # Version 1 specific cleaning logic
        pass

class V2CleaningStrategy(CleaningStrategy):
    def clean(self, data: dict) -> dict:
        # Version 2 specific cleaning logic
        pass
```

### 2. Factory Pattern
Used for creating appropriate cleaners based on platform:

```python
class CleanerFactory:
    @staticmethod
    def create_cleaner(platform: str) -> Cleaner:
        if platform == "macos":
            return MacOSCleaner()
        elif platform == "linux":
            return LinuxCleaner()
        else:
            return GenericCleaner()
```

### 3. Observer Pattern
Used for progress tracking and logging:

```python
class ProgressObserver:
    def on_progress(self, progress: int, message: str):
        pass

class ProgressTracker:
    def __init__(self):
        self.observers = []
    
    def add_observer(self, observer: ProgressObserver):
        self.observers.append(observer)
    
    def notify_progress(self, progress: int, message: str):
        for observer in self.observers:
            observer.on_progress(progress, message)
```

## Security Considerations

### 1. Data Privacy
- All processing happens locally
- No data transmitted externally
- Backup files stored locally with same permissions

### 2. File Safety
- Atomic file operations
- Validation before modification
- Rollback capability via backups

### 3. Permission Handling
- Check file permissions before operations
- Graceful handling of permission denied errors
- Clear error messages for permission issues

## Performance Considerations

### 1. Memory Usage
- Stream JSON parsing for large files
- Garbage collection optimization
- Memory-efficient data structures

### 2. I/O Optimization
- Minimal file reads/writes
- Efficient backup creation
- Batch operations where possible

### 3. Processing Speed
- Optimized JSON parsing
- Efficient field identification
- Parallel processing for independent operations

## Error Handling Strategy

### 1. Hierarchical Error Handling
```
Application Level
├── Critical Errors (exit immediately)
├── Recoverable Errors (continue with warning)
└── Validation Errors (user intervention required)
```

### 2. Error Recovery
- Automatic rollback on failure
- Detailed error reporting
- Suggested resolution steps

## Testing Architecture

### 1. Unit Tests
- Individual component testing
- Mock external dependencies
- High code coverage target (>90%)

### 2. Integration Tests
- End-to-end workflow testing
- Real file system operations
- Platform-specific testing

### 3. Performance Tests
- Large file handling
- Memory usage profiling
- Execution time benchmarks

## Future Extensibility

### 1. Plugin Architecture
- Support for custom cleaning rules
- Extensible field definitions
- Third-party integration points

### 2. Configuration System
- User-defined cleaning preferences
- Custom field preservation rules
- Configurable backup strategies

### 3. API Layer
- REST API for remote management
- Web interface for configuration
- Integration with CI/CD pipelines