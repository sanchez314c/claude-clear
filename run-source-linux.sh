#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Running Claude Clear from source (Linux) ==="

# Check Python
PYTHON_CMD=""
for py_cmd in python3 python3.9 python3.10 python3.11 python3.12; do
    if command -v "$py_cmd" &> /dev/null; then
        PYTHON_CMD="$py_cmd"
        break
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo "Error: Python 3 is required"
    echo "Install with: sudo apt install python3 (Ubuntu/Debian)"
    exit 1
fi

echo "Using $($PYTHON_CMD --version 2>&1)"

# Pass all arguments through
"$PYTHON_CMD" src/cleaner.py "$@"
