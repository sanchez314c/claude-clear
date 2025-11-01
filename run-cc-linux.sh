#!/bin/bash

# Claude Clear - Manual Launch Script for Linux
# Run Claude Clear manually without installing the service

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Animation function
show_spinner() {
    local pid=$1
    local message="$2"
    local spinners="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${GRAY}%s %s${NC}" "$message" "${spinners:$i:1}"
        sleep 0.1
        i=$(( (i + 1) % 9 ))
    done
    printf "\r${GREEN}✓${NC} %s\n" "$message"
}

# Show banner
echo -e "${PURPLE}"
if [ -f "$SCRIPT_DIR/assets/banner.txt" ]; then
    cat "$SCRIPT_DIR/assets/banner.txt"
else
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                              ║"
    echo "║                    🧹 Claude Clear - Manual Mode                           ║"
    echo "║               Clean Claude Code Configuration on Demand                      ║"
    echo "║                         Linux Edition                                       ║"
    echo "║                                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
fi
echo -e "${NC}"

# Check if we're on Linux
if [ "$OSTYPE" != "linux-gnu" ]; then
    echo -e "${YELLOW}⚠ Warning: This script is optimized for Linux${NC}"
    echo -e "${GRAY}On macOS, use run-cc-macos.sh instead${NC}"
    echo
fi

# Check Python
PYTHON_CMD=""
for py_cmd in python3 python3.9 python3.10 python3.11 python3.12; do
    if command -v "$py_cmd" >/dev/null 2>&1; then
        PYTHON_CMD="$py_cmd"
        break
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}✗ Error: Python 3 is required${NC}"
    echo -e "${GRAY}Install with: sudo apt install python3 (Ubuntu/Debian)${NC}"
    echo -e "${GRAY}Or: sudo yum install python3 (RHEL/CentOS)${NC}"
    echo -e "${GRAY}Or: sudo dnf install python3 (Fedora)${NC}"
    exit 1
fi

echo -e "${WHITE}Using Python:${NC} ${GRAY}$($PYTHON_CMD --version 2>&1)${NC}"
echo -e "${WHITE}Distribution:${NC} ${GRAY}$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2 2>/dev/null || echo 'Unknown')${NC}"
echo

# Check if we're in the right directory
if [ ! -f "$SCRIPT_DIR/bin/claude-clear.py" ]; then
    echo -e "${RED}✗ Error: claude-clear.py not found${NC}"
    echo -e "${GRAY}Please run this script from the Claude Clear repository root${NC}"
    exit 1
fi

# Parse command line arguments
ACTION="run"
if [ "$1" = "--dry-run" ]; then
    ACTION="dry-run"
elif [ "$1" = "--status" ]; then
    ACTION="status"
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo -e "${WHITE}Usage:${NC}"
    echo -e "${GRAY}  $0               # Run cleanup${NC}"
    echo -e "${GRAY}  $0 --dry-run     # Preview what would be cleaned${NC}"
    echo -e "${GRAY}  $0 --status      # Check Claude configuration status${NC}"
    echo -e "${GRAY}  $0 --help        # Show this help${NC}"
    echo
    echo -e "${WHITE}Options:${NC}"
    echo -e "${GRAY}  --dry-run    Show what would be cleaned without making changes${NC}"
    echo -e "${GRAY}  --status     Check Claude configuration file status${NC}"
    echo -e "${GRAY}  --help       Show this help message${NC}"
    exit 0
fi

# Check dependencies
echo -e "${CYAN}Checking dependencies...${NC}"
missing_deps=()

# Check required Python modules
if ! "$PYTHON_CMD" -c "import json" 2>/dev/null; then
    missing_deps+=("json")
fi
if ! "$PYTHON_CMD" -c "import pathlib" 2>/dev/null; then
    missing_deps+=("pathlib")
fi

if [ ${#missing_deps[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠ Warning: Missing Python modules: ${missing_deps[*]}${NC}"
    echo -e "${GRAY}These should be included with Python 3.6+${NC}"
    echo
fi

# Run the appropriate action
case "$ACTION" in
    "status")
        echo -e "${CYAN}Checking Claude configuration status...${NC}"
        "$PYTHON_CMD" "$SCRIPT_DIR/bin/claude-clear.py" --status
        ;;
    "dry-run")
        echo -e "${CYAN}Previewing Claude configuration cleanup...${NC}"
        echo
        "$PYTHON_CMD" "$SCRIPT_DIR/bin/claude-clear.py" --dry-run
        ;;
    "run")
        echo -e "${CYAN}Running Claude configuration cleanup...${NC}"
        echo

        # Check Claude config exists
        CLAUDE_JSON="$HOME/.claude.json"
        if [ ! -f "$CLAUDE_JSON" ]; then
            echo -e "${YELLOW}⚠ Warning: .claude.json not found${NC}"
            echo -e "${GRAY}Please run Claude Code at least once first${NC}"
            echo
            read -p "Continue anyway? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 0
            fi
        fi

        # Show current size if file exists
        if [ -f "$CLAUDE_JSON" ]; then
            SIZE=$(du -h "$CLAUDE_JSON" | cut -f1)
            echo -e "${GRAY}Current configuration size: $SIZE${NC}"
            echo
        fi

        # Run cleanup
        "$PYTHON_CMD" "$SCRIPT_DIR/bin/claude-clear.py"
        ;;
esac

echo
echo -e "${GREEN}✨ Done!${NC}"
echo -e "${GRAY}To install automatic cleaning on Linux, create a systemd service:${NC}"
echo -e "${GRAY}  sudo cp scripts/claude-clear.service /etc/systemd/system/${NC}"
echo -e "${GRAY}  sudo systemctl enable claude-clear.service${NC}"
echo -e "${GRAY}  sudo systemctl start claude-clear.service${NC}"