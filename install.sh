#!/bin/bash

# Claude Clear Installer
# A beautiful terminal installation experience

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

# Animation
SPINNER="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
DOTS="⠁⠈⠐⠠⢀⡀⠄⠂⠁"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.claude-clear"
BIN_DIR="/usr/local/bin"
SERVICE_NAME="com.claude.cleanup"

# Clear screen and show banner
clear

# Function to print with delay
print_delay() {
    local text="$1"
    local delay="${2:-0.03}"
    echo -n -e "${text}"
    sleep "$delay"
}

# Function to show spinner
show_spinner() {
    local pid=$1
    local text="$2"
    local delay=0.1
    local i=0

    echo -n -e "${CYAN}${text}"
    while kill -0 $pid 2>/dev/null; do
        printf "\b${SPINNER:$((i%10)):1}"
        sleep $delay
        ((i++))
    done
    printf "\b${GREEN}✓${NC}\n"
}

# Function to check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Show banner with animation
echo -e "${PURPLE}"
cat "$SCRIPT_DIR/assets/banner.txt"
echo -e "${NC}"

# Introduction
echo
print_delay "${WHITE}Claude Clear removes Claude Code's bloated configuration file, restoring performance.\n" 0.05
print_delay "${GRAY}This will install Claude Clear and set up automatic daily cleaning.\n\n" 0.05

# Check requirements
print_delay "${CYAN}Checking requirements...${NC}\n"

# Check macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}✗ Error: Claude Clear requires macOS${NC}"
    exit 1
fi
print_delay "${GREEN}✓ macOS detected${NC}\n"

# Check Python
if command_exists python3; then
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    print_delay "${GREEN}✓ Python 3 found: $PYTHON_VERSION${NC}\n"
else
    echo -e "${RED}✗ Error: Python 3 is required but not installed${NC}"
    echo -e "${GRAY}Please install Python 3 from https://python.org${NC}"
    exit 1
fi

# Check Claude Code
if [ -d "$HOME/.claude" ]; then
    print_delay "${GREEN}✓ Claude Code installation found${NC}\n"
else
    echo -e "${YELLOW}⚠ Warning: Claude Code not detected in ~/.claude${NC}"
    echo -e "${GRAY}Claude Clear requires Claude Code to be installed${NC}"
fi

echo
print_delay "${BLUE}Press Enter to continue installation or Ctrl+C to cancel..."
read -r

# Installation steps
echo -e "\n${WHITE}📦 Installing Claude Clear...${NC}\n"

# Create install directory
print_delay "${GRAY}Creating installation directory... "
sleep 0.5
mkdir -p "$INSTALL_DIR"
print_delay "${GREEN}✓${NC}\n"

# Copy files
print_delay "${GRAY}Copying files... "
(
    cp -r "$SCRIPT_DIR/src" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/bin" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/assets" "$INSTALL_DIR/"
    mkdir -p "$INSTALL_DIR/logs"
) &
show_spinner $! "Copying files"

# Create executable
print_delay "${GRAY}Creating executable... "
sleep 0.5
cat > "$INSTALL_DIR/claude-clear" << 'EOF'
#!/bin/bash
INSTALL_DIR="$HOME/.claude-clear"
python3 "$INSTALL_DIR/bin/claude-clear.py" "$@"
EOF
chmod +x "$INSTALL_DIR/claude-clear"
print_delay "${GREEN}✓${NC}\n"

# Create symlink
print_delay "${GRAY}Creating command shortcut... "
sleep 0.5
if [ -w "$BIN_DIR" ]; then
    ln -sf "$INSTALL_DIR/claude-clear" "$BIN_DIR/claude-clear"
    print_delay "${GREEN}✓${NC}\n"
    CMD_INSTALLED=true
else
    # Try to add to PATH in .zshrc or .bash_profile
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_RC="$HOME/.bash_profile"
    fi

    if [ -n "$SHELL_RC" ]; then
        echo "" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
        print_delay "${YELLOW}⚠ Added to PATH in $(basename "$SHELL_RC")${NC}\n"
        print_delay "${GRAY}Please restart your terminal or run: source $SHELL_RC${NC}\n"
    else
        print_delay "${YELLOW}⚠ Please add $INSTALL_DIR to your PATH manually${NC}\n"
    fi
    CMD_INSTALLED=false
fi

# Setup launch agent
print_delay "${GRAY}Setting up automatic cleaning... "
sleep 0.5

# Create launch agent plist
cat > "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SERVICE_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>$INSTALL_DIR/src/cleaner.py</string>
    </array>
    <key>StartInterval</key>
    <integer>86400</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/logs/cleanup.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/error.log</string>
    <key>UserName</key>
    <string>$(whoami)</string>
    <key>WorkingDirectory</key>
    <string>$HOME</string>
</dict>
</plist>
EOF

# Load the service
launchctl load "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" 2>/dev/null || true
print_delay "${GREEN}✓${NC}\n"

# Run initial cleanup
echo
print_delay "${WHITE}Would you like to run initial cleanup now? (Y/n): " 0.05
read -r response
if [[ "$response" != "n" && "$response" != "N" ]]; then
    echo
    print_delay "${CYAN}Running initial cleanup...${NC}\n"
    python3 "$INSTALL_DIR/src/cleaner.py"
fi

# Success message
echo
echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${WHITE}                        ✨ Installation Complete! ✨                        ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo

if [ "$CMD_INSTALLED" = true ]; then
    echo -e "${WHITE}Usage:${NC}"
    echo -e "${GRAY}  claude-clear              # Run cleanup${NC}"
    echo -e "${GRAY}  claude-clear --status     # Check status${NC}"
    echo -e "${GRAY}  claude-clear --logs       # View logs${NC}"
    echo -e "${GRAY}  claude-clear --uninstall  # Remove Claude Clear${NC}"
else
    echo -e "${WHITE}Usage:${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear              # Run cleanup${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --status     # Check status${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --logs       # View logs${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --uninstall  # Remove Claude Clear${NC}"
fi

echo
echo -e "${WHITE}Automatic cleaning:${NC}"
echo -e "${GRAY}  Claude Clear will automatically clean your configuration every 24 hours.${NC}"

echo
echo -e "${PURPLE}Thank you for installing Claude Clear! 🎉${NC}"
echo -e "${GRAY}Report issues at: https://github.com/yourusername/claude-clear/issues${NC}"