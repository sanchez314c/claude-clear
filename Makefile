# Claude Clear Makefile

.PHONY: install uninstall test clean help

# Default target
help:
	@echo "Claude Clear - Available commands:"
	@echo "  install    - Install Claude Clear locally"
	@echo "  uninstall  - Remove Claude Clear"
	@echo "  test       - Run tests"
	@echo "  clean      - Clean build artifacts"
	@echo "  help       - Show this help"

# Install locally
install:
	@echo "Installing Claude Clear..."
	@./install.sh --local

# Uninstall
uninstall:
	@echo "Uninstalling Claude Clear..."
	@./uninstall.sh

# Run tests
test:
	@echo "Running tests..."
	@python -m pytest tests/ -v

# Clean build artifacts
clean:
	@echo "Cleaning..."
	@find . -type f -name "*.pyc" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -type d -name "*.egg-info" -exec rm -rf {} +
	@rm -rf build/ dist/

# Development install
dev-install:
	@echo "Installing in development mode..."
	@pip install -e .

# Show version
version:
	@echo "Claude Clear v1.0.0"