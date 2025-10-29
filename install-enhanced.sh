#!/bin/bash

# Claude Clear Enhanced Installer with Environment Detection
# Includes comprehensive checks and fallbacks

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
INSTALL_DIR="$HOME/.claude-clear"
SERVICE_NAME="com.claude.cleanup"
BIN_DIR="/usr/local/bin"
CMD_INSTALLED=false

# System info for debugging
SYSTEM_INFO="OS: $(uname -s)
Kernel: $(uname -r)
Arch: $(uname -m)
Shell: $SHELL
Python: $(python3 --version 2>/dev/null || echo 'Not found')
Home: $HOME"

# Save system info for troubleshooting
echo "$SYSTEM_INFO" > "$SCRIPT_DIR/system-info.txt"

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

# Enhanced print with delay
print_delay() {
    local text="$1"
    local delay="${2:-0.03}"
    while IFS= read -r -n1 char; do
        printf "%c" "$char"
        sleep "$delay"
    done <<< "$text"
}

# Function to check command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check writable directory
check_writable() {
    local dir="$1"
    if [ -w "$dir" ]; then
        return 0
    else
        return 1
    fi
}

# Function to detect shell and config file
detect_shell_config() {
    case "$SHELL" in
        */zsh)
            echo "$HOME/.zshrc"
            ;;
        */bash)
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            echo "$HOME/.profile"
            ;;
    esac
}

# Function to check Claude installation more thoroughly
check_claude_installation() {
    local claude_paths=(
        "$HOME/.claude"
        "$HOME/Library/Application Support/Claude"
        "/Applications/Claude.app"
    )

    for path in "${claude_paths[@]}"; do
        if [ -d "$path" ] || [ -f "$path" ]; then
            return 0
        fi
    done

    # Check if claude command exists
    if command_exists claude; then
        return 0
    fi

    return 1
}

# Function to find alternative bin directory
find_bin_dir() {
    local bin_dirs=(
        "$HOME/.local/bin"
        "$HOME/bin"
        "/opt/homebrew/bin"  # For Apple Silicon
        "/usr/local/bin"
    )

    for dir in "${bin_dirs[@]}"; do
        if [ -d "$dir" ] && check_writable "$dir"; then
            echo "$dir"
            return 0
        fi
    done

    # Create ~/.local/bin if it doesn't exist
    if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p "$HOME/.local/bin" 2>/dev/null && echo "$HOME/.local/bin" && return 0
    fi

    return 1
}

# Function to test Python functionality
test_python() {
    local python_cmd="$1"

    # Test basic Python
    if ! "$python_cmd" -c "import sys; print(sys.version)" >/dev/null 2>&1; then
        return 1
    fi

    # Test required modules
    if ! "$python_cmd" -c "import json, os, pathlib, subprocess; print('OK')" >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

# Show banner with animation
echo -e "${PURPLE}"
cat "$SCRIPT_DIR/assets/banner.txt" 2>/dev/null || echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║                    🧹 Claude Clear Enhanced Installer                      ║"
echo "║               Clean Claude Code Configuration Automatically                 ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Introduction
echo
print_delay "${WHITE}Claude Clear removes Claude Code's bloated configuration file, restoring performance.\n" 0.05
print_delay "${GRAY}This installer will check your system and install Claude Clear with automatic daily cleaning.\n\n" 0.05

# System check
echo -e "${CYAN}System Information:${NC}\n"
printf "${GRAY}Operating System:${NC} %s\n" "$(uname -s)"
printf "${GRAY}Architecture:${NC} %s\n" "$(uname -m)"
printf "${GRAY}Shell:${NC} %s\n" "$SHELL"
echo

# Enhanced requirements check
print_delay "${CYAN}Checking requirements...${NC}\n"

# Check macOS version
if [[ "$OSTYPE" == "darwin"* ]]; then
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)
    if [ "$MACOS_MAJOR" -ge 10 ]; then
        print_delay "${GREEN}✓ macOS $MACOS_VERSION detected${NC}\n"
    else
        echo -e "${RED}✗ Error: macOS 10.14 or later required${NC}"
        echo -e "${GRAY}Your version: $MACOS_VERSION${NC}"
        exit 1
    fi
else
    echo -e "${RED}✗ Error: Claude Clear requires macOS${NC}"
    echo -e "${GRAY}Detected OS: $(uname -s)${NC}"
    exit 1
fi

# Check Python with alternatives
PYTHON_CMD=""
for py_cmd in python3 python3.9 python3.10 python3.11 python3.12; do
    if command_exists "$py_cmd" && test_python "$py_cmd"; then
        PYTHON_CMD="$py_cmd"
        PYTHON_VERSION=$("$py_cmd" --version 2>&1)
        print_delay "${GREEN}✓ Python found: $PYTHON_VERSION${NC}\n"
        break
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo -e "${RED}✗ Error: Functional Python 3 is required${NC}"
    echo -e "${GRAY}Please install Python 3 from https://python.org${NC}"
    echo -e "${GRAY}Or use Homebrew: brew install python3${NC}"
    exit 1
fi

# Check Claude Code installation
if check_claude_installation; then
    print_delay "${GREEN}✓ Claude Code installation found${NC}\n"

    # Check for .claude.json specifically
    CLAUDE_JSON="$HOME/.claude.json"
    if [ -f "$CLAUDE_JSON" ]; then
        SIZE=$(du -h "$CLAUDE_JSON" | cut -f1)
        print_delay "${GRAY}  Configuration file size: $SIZE${NC}\n"

        # Check if it's large and needs cleaning
        SIZE_BYTES=$(stat -f%z "$CLAUDE_JSON" 2>/dev/null || stat -c%s "$CLAUDE_JSON" 2>/dev/null || echo "0")
        if [ "$SIZE_BYTES" -gt 1048576 ]; then  # 1MB
            print_delay "${YELLOW}  ⚠ Large configuration detected - cleaning recommended!${NC}\n"
        fi
    else
        echo -e "${YELLOW}  ⚠ .claude.json not found in home directory${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠ Warning: Claude Code not detected${NC}\n"
    echo -e "${GRAY}  Claude Clear requires Claude Code to function${NC}\n"
    echo -e "${GRAY}  Install Claude Code from: https://claude.ai${NC}\n"
fi

# Check directory permissions
echo -e "${CYAN}Checking directory permissions...${NC}\n"

# Check home directory
if check_writable "$HOME"; then
    print_delay "${GREEN}✓ Home directory is writable${NC}\n"
else
    echo -e "${RED}✗ Error: Cannot write to home directory${NC}"
    exit 1
fi

# Find writable bin directory
BIN_DIR=$(find_bin_dir)
if [ -n "$BIN_DIR" ]; then
    print_delay "${GREEN}✓ Found writable bin directory: $BIN_DIR${NC}\n"
else
    echo -e "${YELLOW}⚠ Warning: No system bin directory writable${NC}\n"
    echo -e "${GRAY}  Will install to $INSTALL_DIR only${NC}\n"
    BIN_DIR=""
fi

# Check shell configuration
SHELL_CONFIG=$(detect_shell_config)
if [ -f "$SHELL_CONFIG" ]; then
    print_delay "${GREEN}✓ Shell config found: $SHELL_CONFIG${NC}\n"
else
    echo -e "${YELLOW}⚠ Warning: Shell config not found, will create: $SHELL_CONFIG${NC}\n"
fi

# Check for existing installation
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠ Claude Clear already installed${NC}\n"
    echo -e "${GRAY}  Existing installation will be updated${NC}\n"

    # Stop existing service
    if launchctl list | grep -q "$SERVICE_NAME"; then
        echo -e "${GRAY}  Stopping existing service...${NC}\n"
        launchctl unload "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" 2>/dev/null || true
    fi
fi

echo
print_delay "${BLUE}Press Enter to continue installation or Ctrl+C to cancel..."
read -r

# Installation steps
echo -e "\n${WHITE}📦 Installing Claude Clear...${NC}\n"

# Create install directory
print_delay "${GRAY}Creating installation directory... "
sleep 0.5
mkdir -p "$INSTALL_DIR/logs"
print_delay "${GREEN}✓${NC}\n"

# Copy files with error handling
print_delay "${GRAY}Copying files... "
(
    if [ -d "$SCRIPT_DIR/src" ]; then
        cp -r "$SCRIPT_DIR/src" "$INSTALL_DIR/"
    else
        echo -e "\n${RED}Error: src directory not found${NC}" >&2
        exit 1
    fi

    if [ -d "$SCRIPT_DIR/bin" ]; then
        cp -r "$SCRIPT_DIR/bin" "$INSTALL_DIR/"
    else
        echo -e "\n${RED}Error: bin directory not found${NC}" >&2
        exit 1
    fi

    if [ -d "$SCRIPT_DIR/assets" ]; then
        cp -r "$SCRIPT_DIR/assets" "$INSTALL_DIR/"
    fi

    # Make Python scripts executable
    find "$INSTALL_DIR" -name "*.py" -exec chmod +x {} \;
) &
show_spinner $! "Copying files"

# Create executable wrapper
print_delay "${GRAY}Creating executable... "
sleep 0.5
cat > "$INSTALL_DIR/claude-clear" << EOF
#!/bin/bash
INSTALL_DIR="$HOME/.claude-clear"
$PYTHON_CMD "\$INSTALL_DIR/bin/claude-clear.py" "\$@"
EOF
chmod +x "$INSTALL_DIR/claude-clear"
print_delay "${GREEN}✓${NC}\n"

# Create symlink if possible
if [ -n "$BIN_DIR" ] && check_writable "$BIN_DIR"; then
    print_delay "${GRAY}Creating command symlink... "
    ln -sf "$INSTALL_DIR/claude-clear" "$BIN_DIR/claude-clear" 2>/dev/null || true
    if [ -L "$BIN_DIR/claude-clear" ]; then
        CMD_INSTALLED=true
        print_delay "${GREEN}✓${NC}\n"
    else
        print_delay "${YELLOW}✓ Skipped (permissions)${NC}\n"
    fi
else
    print_delay "${GRAY}Skipping symlink (no writable bin directory)${NC}\n"
fi

# Update shell configuration
print_delay "${GRAY}Updating shell configuration... "
if [ -f "$SHELL_CONFIG" ]; then
    # Backup existing config
    cp "$SHELL_CONFIG" "$SHELL_CONFIG.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true

    # Remove old entries
    sed -i.bak "/export PATH=.*$INSTALL_DIR/d" "$SHELL_CONFIG" 2>/dev/null || true
    sed -i.bak "/$INSTALL_DIR/d" "$SHELL_CONFIG" 2>/dev/null || true

    # Add new entry if not in system bin
    if [ "$CMD_INSTALLED" = false ]; then
        echo "" >> "$SHELL_CONFIG"
        echo "# Claude Clear" >> "$SHELL_CONFIG"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_CONFIG"
        echo "export CLAUDE_CLEAR_DIR=\"$INSTALL_DIR\"" >> "$SHELL_CONFIG"
    fi
    print_delay "${GREEN}✓${NC}\n"
else
    # Create new shell config
    echo "# Claude Clear" > "$SHELL_CONFIG"
    echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_CONFIG"
    echo "export CLAUDE_CLEAR_DIR=\"$INSTALL_DIR\"" >> "$SHELL_CONFIG"
    print_delay "${GREEN}✓ Created new config${NC}\n"
fi

# Create LaunchAgent
print_delay "${GRAY}Creating automatic service... "
cat > "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$SERVICE_NAME</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/$PYTHON_CMD</string>
        <string>$INSTALL_DIR/src/cleaner.py</string>
    </array>
    <key>StartInterval</key>
    <integer>86400</integer>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/logs/cleanup.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/error.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF

# Load the service
launchctl load "$HOME/Library/LaunchAgents/$SERVICE_NAME.plist" 2>/dev/null || {
    echo -e "\n${YELLOW}⚠ Could not load automatic service${NC}"
    echo -e "${GRAY}  You can run manual cleanup with: claude-clear${NC}"
}
print_delay "${GREEN}✓${NC}\n"

# Test installation
print_delay "${GRAY}Testing installation... "
if "$INSTALL_DIR/claude-clear" --version >/dev/null 2>&1; then
    VERSION=$("$INSTALL_DIR/claude-clear" --version 2>/dev/null || echo "1.0.0")
    print_delay "${GREEN}✓ v$VERSION${NC}\n"
else
    echo -e "\n${YELLOW}⚠ Installation test failed${NC}"
fi

# Run initial cleanup
echo
print_delay "${WHITE}Would you like to run initial cleanup now? (Y/n): " 0.05
read -r response
if [[ "$response" != "n" && "$response" != "N" ]]; then
    echo
    print_delay "${CYAN}Running initial cleanup...${NC}\n"
    if "$INSTALL_DIR/claude-clear" --dry-run; then
        echo
        print_delay "${WHITE}Proceed with cleanup? (y/N): " 0.05
        read -r confirm
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            "$INSTALL_DIR/claude-clear"
        fi
    fi
fi

# Success message with additional info
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
    echo -e "${GRAY}  claude-clear --dry-run    # Preview cleanup${NC}"
    echo -e "${GRAY}  claude-clear --uninstall  # Remove Claude Clear${NC}"
else
    echo -e "${WHITE}Usage:${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear              # Run cleanup${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --status     # Check status${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --logs       # View logs${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --dry-run    # Preview cleanup${NC}"
    echo -e "${GRAY}  $INSTALL_DIR/claude-clear --uninstall  # Remove Claude Clear${NC}"
    echo
    echo -e "${YELLOW}Note: Restart your terminal or run:${NC}"
    echo -e "${GRAY}  source $SHELL_CONFIG${NC}"
fi

echo
echo -e "${WHITE}Automatic cleaning:${NC}"
if launchctl list | grep -q "$SERVICE_NAME"; then
    echo -e "${GRAY}  ✓ Active - Will clean every 24 hours${NC}"
else
    echo -e "${YELLOW}  ⚠ Service not loaded - Run manual cleanup${NC}"
fi

echo
echo -e "${WHITE}Files installed:${NC}"
echo -e "${GRAY}  Program: $INSTALL_DIR${NC}"
echo -e "${GRAY}  Logs: $INSTALL_DIR/logs${NC}"
echo -e "${GRAY}  Service: ~/Library/LaunchAgents/$SERVICE_NAME.plist${NC}"
echo -e "${GRAY}  System info: $SCRIPT_DIR/system-info.txt${NC}"

echo
echo -e "${PURPLE}Thank you for installing Claude Clear! 🎉${NC}"
echo -e "${GRAY}Having issues? Check TROUBLESHOOTING.md or visit:${NC}"
echo -e "${GRAY}https://github.com/yourusername/claude-clear/issues${NC}"