#!/bin/bash

# Claude Clear Uninstaller
# Removes Claude Clear completely from your system

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

INSTALL_DIR="$HOME/.claude-clear"
SERVICE_NAME="com.claude.cleanup"
BIN_DIR="/usr/local/bin"

clear

# Print banner
echo -e "${PURPLE}"
cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                    🗑️  Claude Clear Uninstaller v1.0.0                      ║
║                  Remove Claude Clear from your system                          ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo
echo -e "${WHITE}This will completely remove Claude Clear from your system.${NC}"
echo -e "${GRAY}• Your configuration backups will be preserved${NC}"
echo -e "${GRAY}• Claude Code will continue to work normally${NC}"
echo

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠ Claude Clear is not installed${NC}"
    exit 0
fi

# Confirmation
echo -ne "${CYAN}Are you sure you want to uninstall? (y/N): ${NC}"
read -r response
if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo -e "${GRAY}Uninstallation cancelled${NC}"
    exit 0
fi

echo
echo -e "${WHITE}🗑️  Uninstalling Claude Clear...${NC}\n"

# Stop and unload service
echo -ne "${GRAY}Stopping automatic service... "
if launchctl list | grep -q "$SERVICE_NAME"; then
    launchctl unload "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" 2>/dev/null || true
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}✓ Service not running${NC}"
fi

# Remove launch agent
echo -ne "${GRAY}Removing launch agent... "
launch_agent="$HOME/Library/LaunchAgents/$SERVICE_NAME.plist"
if [ -f "$launch_agent" ]; then
    rm "$launch_agent"
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}✓ Already removed${NC}"
fi

# Remove installation directory
echo -ne "${GRAY}Removing installation files... "
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}✓ Already removed${NC}"
fi

# Remove symlink
echo -ne "${GRAY}Removing command shortcut... "
if [ -L "$BIN_DIR/claude-clear" ]; then
    rm "$BIN_DIR/claude-clear"
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}✓ Not found${NC}"
fi

# Remove from shell configs
echo -ne "${GRAY}Cleaning shell configurations... "
modified=false

for rc_file in "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.bashrc"; do
    if [ -f "$rc_file" ]; then
        if grep -q "$INSTALL_DIR" "$rc_file"; then
            # Create backup
            cp "$rc_file" "$rc_file.backup.$(date +%Y%m%d_%H%M%S)"

            # Remove Claude Clear PATH entry
            ESCAPED_INSTALL_DIR=$(printf '%s\n' "$INSTALL_DIR" | sed 's/[[\.*^$()+?{|/]/\\&/g')
            sed -i.bak "/export PATH=\"\$PATH:$ESCAPED_INSTALL_DIR\"/d" "$rc_file" 2>/dev/null || true
            sed -i.bak "/$ESCAPED_INSTALL_DIR/d" "$rc_file" 2>/dev/null || true

            modified=true
        fi
    fi
done

if [ "$modified" = true ]; then
    echo -e "${GREEN}✓${NC}"
    echo -e "${GRAY}  Shell configs modified (backups created)${NC}"
else
    echo -e "${YELLOW}✓ Nothing to clean${NC}"
fi

# Check for backups
echo -ne "${GRAY}Checking for backup files... "
backup_count=$(ls -1 "$HOME/.claude.json.backup"* 2>/dev/null | wc -l)
if [ "$backup_count" -gt 0 ]; then
    echo -e "${YELLOW}✓ Found $backup_count backup(s)${NC}"
    echo -e "${GRAY}  Backups preserved in: ~/.claude.json.backup.*${NC}"
else
    echo -e "${GREEN}✓ No backups found${NC}"
fi

# Success message
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${WHITE}                    ✨ Uninstallation Complete! ✨                        ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo

echo -e "${WHITE}Claude Clear has been removed from your system.${NC}"
echo
if [ "$backup_count" -gt 0 ]; then
    echo -e "${CYAN}💡 To restore a backup:${NC}"
    echo -e "${GRAY}   cp ~/.claude.json.backup.YYYYMMDD_HHMMSS ~/.claude.json${NC}"
    echo
fi

echo -e "${PURPLE}Thank you for using Claude Clear! 🎉${NC}"