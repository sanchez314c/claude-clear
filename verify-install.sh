#!/bin/bash

# Claude Clear Installation Verification Script
# Checks that all components are properly installed and functional

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'

INSTALL_DIR="$HOME/.claude-clear"
SERVICE_NAME="com.claude.cleanup"
ERRORS=0

echo -e "${BLUE}Claude Clear Installation Verification${NC}\n"

# Check installation directory
echo -e "${WHITE}Checking installation directory...${NC}"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${GREEN}✓${NC} Found at $INSTALL_DIR"

    # Check required files
    required_files=("src/cleaner.py" "bin/claude-clear.py" "claude-clear")
    for file in "${required_files[@]}"; do
        if [ -f "$INSTALL_DIR/$file" ]; then
            echo -e "${GREEN}✓${NC} $file exists"
        else
            echo -e "${RED}✗${NC} $file missing"
            ((ERRORS++))
        fi
    done

    # Check permissions
    if [ -x "$INSTALL_DIR/claude-clear" ]; then
        echo -e "${GREEN}✓${NC} Executable permissions set"
    else
        echo -e "${RED}✗${NC} Executable permissions missing"
        ((ERRORS++))
    fi
else
    echo -e "${RED}✗${NC} Installation directory not found"
    ((ERRORS++))
fi

echo

# Check command availability
echo -e "${WHITE}Checking command availability...${NC}"
if command -v claude-clear >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} claude-clear command available"

    # Test version
    if claude-clear --version >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Version command works"
    else
        echo -e "${YELLOW}⚠${NC} Version command failed"
    fi
else
    echo -e "${YELLOW}⚠${NC} claude-clear not in PATH"
    echo -e "${GRAY}  Try: source ~/.zshrc or restart terminal${NC}"
fi

echo

# Check service
echo -e "${WHITE}Checking automatic service...${NC}"
if launchctl list | grep -q "$SERVICE_NAME"; then
    echo -e "${GREEN}✓${NC} Service loaded"

    # Check if it's running
    if pgrep -f "$SERVICE_NAME" >/dev/null; then
        echo -e "${GREEN}✓${NC} Service running"
    else
        echo -e "${YELLOW}⚠${NC} Service loaded but not running (normal for interval service)"
    fi
else
    echo -e "${YELLOW}⚠${NC} Service not loaded"
    echo -e "${GRAY}  Manual cleanup required${NC}"
fi

echo

# Check configuration
echo -e "${WHITE}Checking Claude configuration...${NC}"
CLAUDE_JSON="$HOME/.claude.json"
if [ -f "$CLAUDE_JSON" ]; then
    SIZE=$(du -h "$CLAUDE_JSON" | cut -f1)
    echo -e "${GREEN}✓${NC} Found at $CLAUDE_JSON ($SIZE)"

    # Test if it's valid JSON
    if python3 -c "import json; json.load(open('$CLAUDE_JSON'))" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Valid JSON format"
    else
        echo -e "${RED}✗${NC} Invalid JSON format"
        ((ERRORS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Claude configuration not found"
    echo -e "${GRAY}  Run Claude Code at least once${NC}"
fi

echo

# Check logs
echo -e "${WHITE}Checking logs...${NC}"
if [ -d "$INSTALL_DIR/logs" ]; then
    if [ -f "$INSTALL_DIR/logs/cleanup.log" ]; then
        LINES=$(wc -l < "$INSTALL_DIR/logs/cleanup.log" 2>/dev/null || echo "0")
        echo -e "${GREEN}✓${NC} Cleanup log exists ($LINES lines)"
    else
        echo -e "${YELLOW}⚠${NC} No cleanup log yet"
    fi

    if [ -f "$INSTALL_DIR/logs/error.log" ]; then
        ERR_LINES=$(wc -l < "$INSTALL_DIR/logs/error.log" 2>/dev/null || echo "0")
        if [ "$ERR_LINES" -gt 0 ]; then
            echo -e "${YELLOW}⚠${NC} Error log has $ERR_LINES entries"
            echo -e "${GRAY}  Check with: claude-clear --logs${NC}"
        else
            echo -e "${GREEN}✓${NC} No errors logged"
        fi
    else
        echo -e "${GREEN}✓${NC} No error log (clean)${NC}"
    fi
else
    echo -e "${YELLOW}⚠${NC} Logs directory not found"
fi

echo

# Test dry run
echo -e "${WHITE}Testing dry-run functionality...${NC}"
if [ -x "$INSTALL_DIR/claude-clear" ]; then
    if "$INSTALL_DIR/claude-clear" --dry-run >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Dry-run works correctly"
    else
        echo -e "${YELLOW}⚠${NC} Dry-run failed (may need Claude config)"
    fi
else
    echo -e "${RED}✗${NC} Cannot test - executable not found"
    ((ERRORS++))
fi

echo

# Summary
echo -e "${BLUE}Verification Summary${NC}"
echo "═════════════════════════════════════"

if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}✓ Installation appears to be working correctly${NC}"
    echo
    echo -e "${WHITE}Next steps:${NC}"
    echo -e "${GRAY}1. Run: claude-clear --status${NC}"
    echo -e "${GRAY}2. Try: claude-clear --dry-run${NC}"
    echo -e "${GRAY}3. Clean: claude-clear${NC}"
else
    echo -e "${RED}✗ Found $ERRORS issue(s)${NC}"
    echo
    echo -e "${WHITE}Troubleshooting:${NC}"
    echo -e "${GRAY}1. Check TROUBLESHOOTING.md for solutions${NC}"
    echo -e "${GRAY}2. Reinstall: ./install.sh${NC}"
    echo -e "${GRAY}3. Report: https://github.com/yourusername/claude-clear/issues${NC}"
fi

echo
echo -e "${GRAY}System info:${NC}"
echo -e "${GRAY}  OS: $(uname -s) $(uname -r)${NC}"
echo -e "${GRAY}  Shell: $SHELL${NC}"
echo -e "${GRAY}  Python: $(python3 --version 2>/dev/null || echo 'Not found')${NC}"