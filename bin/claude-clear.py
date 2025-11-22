#!/usr/bin/env python3
"""
Claude Clear - Main CLI Interface
Command-line interface for Claude Clear utility
"""

import os
import platform
import sys
import subprocess
import argparse
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from cleaner import Colors, clean_claude_json, print_banner

INSTALL_DIR = Path.home() / ".claude-clear"
SERVICE_NAME = "com.claude.cleanup"

def show_status():
    """Show Claude Clear status"""
    print_banner()
    print()

    # Check installation
    if not INSTALL_DIR.exists():
        print(f"{Colors.RED}❌ Claude Clear is not installed{Colors.NC}")
        return

    print(f"{Colors.GREEN}✓ Claude Clear is installed{Colors.NC}")
    print(f"{Colors.GRAY}   Location: {INSTALL_DIR}{Colors.NC}")

    # Check service
    if platform.system() == 'Darwin':
        try:
            result = subprocess.run(['launchctl', 'list'], capture_output=True, text=True)
            if SERVICE_NAME in result.stdout:
                print(f"{Colors.GREEN}✓ Automatic cleaning is active{Colors.NC}")
            else:
                print(f"{Colors.YELLOW}⚠ Automatic cleaning is not active{Colors.NC}")
        except (FileNotFoundError, subprocess.SubprocessError, OSError):
            print(f"{Colors.YELLOW}⚠ Could not check service status{Colors.NC}")

    # Check Claude file
    claude_json = Path.home() / ".claude.json"
    if claude_json.exists():
        size_mb = claude_json.stat().st_size / 1024 / 1024
        if size_mb > 1:
            print(f"{Colors.YELLOW}⚠ Configuration file is large: {size_mb:.2f} MB{Colors.NC}")
            print(f"{Colors.GRAY}   Run 'claude-clear' to clean it{Colors.NC}")
        else:
            size_kb = claude_json.stat().st_size / 1024
            print(f"{Colors.GREEN}✓ Configuration file is clean: {size_kb:.1f} KB{Colors.NC}")
    else:
        print(f"{Colors.YELLOW}⚠ Claude configuration not found{Colors.NC}")

    # Show logs
    print(f"\n{Colors.WHITE}📋 Recent logs:{Colors.NC}")
    log_file = INSTALL_DIR / "logs" / "cleanup.log"
    if log_file.exists():
        with open(log_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            for line in lines[-5:]:
                print(f"{Colors.GRAY}   {line.strip()}{Colors.NC}")
    else:
        print(f"{Colors.GRAY}   No logs found{Colors.NC}")

def show_logs():
    """Show Claude Clear logs"""
    log_file = INSTALL_DIR / "logs" / "cleanup.log"
    error_file = INSTALL_DIR / "logs" / "error.log"

    if log_file.exists():
        print(f"{Colors.WHITE}📄 Cleanup Log:{Colors.NC}")
        print("-" * 50)
        with open(log_file, 'r', encoding='utf-8') as f:
            print(f.read())
    else:
        print(f"{Colors.YELLOW}No cleanup logs found{Colors.NC}")

    if error_file.exists():
        print(f"\n{Colors.RED}📄 Error Log:{Colors.NC}")
        print("-" * 50)
        with open(error_file, 'r', encoding='utf-8') as f:
            print(f.read())

def uninstall():
    """Uninstall Claude Clear"""
    print_banner()
    print()
    print(f"{Colors.YELLOW}⚠ This will remove Claude Clear from your system{Colors.NC}")
    print()

    response = input("Are you sure? (y/N): ")
    if response.lower() != 'y':
        print(f"{Colors.GRAY}Uninstallation cancelled{Colors.NC}")
        return

    print(f"\n{Colors.WHITE}🗑️  Uninstalling Claude Clear...{Colors.NC}")

    # Stop and unload service
    if platform.system() == 'Darwin':
        try:
            plist_path = Path.home() / "Library" / "LaunchAgents" / f"{SERVICE_NAME}.plist"
            subprocess.run(['launchctl', 'unload', str(plist_path)], check=False, capture_output=True)
            print(f"{Colors.GREEN}✓ Stopped automatic service{Colors.NC}")
        except (FileNotFoundError, subprocess.SubprocessError, OSError):
            pass

    # Remove launch agent
    launch_agent = Path.home() / "Library" / "LaunchAgents" / f"{SERVICE_NAME}.plist"
    if launch_agent.exists():
        launch_agent.unlink()
        print(f"{Colors.GREEN}✓ Removed launch agent{Colors.NC}")

    # Remove installation directory
    if INSTALL_DIR.exists():
        import shutil
        shutil.rmtree(INSTALL_DIR)
        print(f"{Colors.GREEN}✓ Removed installation files{Colors.NC}")

    # Remove symlink
    symlink = Path("/usr/local/bin/claude-clear")
    if symlink.exists():
        symlink.unlink()
        print(f"{Colors.GREEN}✓ Removed command shortcut{Colors.NC}")

    # Remove from PATH in shell configs
    for rc_file in [Path.home() / ".zshrc", Path.home() / ".bash_profile"]:
        if rc_file.exists():
            content = rc_file.read_text()
            if f'export PATH="$PATH:{INSTALL_DIR}"' in content:
                content = content.replace(f'\nexport PATH="$PATH:{INSTALL_DIR}"', '')
                rc_file.write_text(content)
                print(f"{Colors.GREEN}✓ Removed from {rc_file.name}{Colors.NC}")

    print(f"\n{Colors.GREEN}✨ Claude Clear has been uninstalled{Colors.NC}")
    print(f"{Colors.GRAY}Your backup files are preserved in ~/.claude.json.backup.*{Colors.NC}")

def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(
        description='Claude Clear - Clean Claude Code configuration',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  claude-clear              # Run cleanup
  claude-clear --status     # Show status
  claude-clear --logs       # View logs
  claude-clear --dry-run    # Preview what would be cleaned
  claude-clear --uninstall  # Remove Claude Clear
        """
    )

    parser.add_argument('--status', action='store_true',
                       help='Show Claude Clear status')
    parser.add_argument('--logs', action='store_true',
                       help='View cleanup logs')
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be cleaned without making changes')
    parser.add_argument('--uninstall', action='store_true',
                       help='Uninstall Claude Clear')
    parser.add_argument('--version', action='store_true',
                       help='Show version information')

    args = parser.parse_args()

    if args.version:
        print("Claude Clear v1.0.0")
        print("© 2025 Claude Clear Contributors")
        print("MIT License")
        return

    if args.uninstall:
        uninstall()
    elif args.status:
        show_status()
    elif args.logs:
        show_logs()
    else:
        # Run cleanup
        if sys.stdin.isatty():
            print_banner()
            print()
        clean_claude_json(dry_run=args.dry_run)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Operation cancelled{Colors.NC}")
        sys.exit(1)