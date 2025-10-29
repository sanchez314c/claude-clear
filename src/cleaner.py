#!/usr/bin/env python3
"""
Claude Clear - Cleaner Module
Cleans Claude Code's bloated configuration file
"""

import json
import os
import sys
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any

# Colors for terminal output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    WHITE = '\033[1;37m'
    GRAY = '\033[0;37m'
    NC = '\033[0m'  # No Color

def print_banner():
    """Print Claude Clear banner"""
    banner = """╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ████████╗ █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ███████╗ █████╗        ║
║    ╚══██╔══╝██╔══██╗████╗  ██║██║ ██╔╝    ██╔══██╗██╔════╝██╔══██╗       ║
║       ██║   ███████║██╔██╗ ██║█████╔╝     ██████╔╝█████╗  ███████║       ║
║       ██║   ██╔══██║██║╚██╗██║██╔═██╗     ██╔══██╗██╔══╝  ██╔══██║       ║
║       ██║   ██║  ██║██║ ╚████║██║  ██╗    ██║  ██║███████╗██║  ██║       ║
║       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝       ║
║                                                                              ║
║                          🧹  Claude Clear  v1.0.0                          ║
║                Clean Claude Code's bloated configuration file                 ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝"""
    print(f"{Colors.PURPLE}{banner}{Colors.NC}")

def clean_claude_json(dry_run: bool = False) -> bool:
    """Clean the Claude JSON file by removing history"""

    claude_json_path = Path.home() / '.claude.json'

    if not claude_json_path.exists():
        print(f"{Colors.RED}❌ ~/.claude.json not found{Colors.NC}")
        print(f"{Colors.GRAY}Claude Code might not be installed or has not been run yet.{Colors.NC}")
        return False

    # Get original file size
    original_size = claude_json_path.stat().st_size
    print(f"{Colors.WHITE}📁 Current file size: {original_size / 1024 / 1024:.2f} MB{Colors.NC}")

    if original_size < 1024 * 100:  # Less than 100 KB
        print(f"{Colors.YELLOW}⚠ File is already small ({original_size / 1024:.1f} KB){Colors.NC}")
        if not dry_run:
            response = input("Clean anyway? (y/N): ")
            if response.lower() != 'y':
                return False

    if dry_run:
        print(f"{Colors.CYAN}🔍 Dry run mode - no changes will be made{Colors.NC}")

    # Create backup
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = claude_json_path.with_suffix(f'.json.backup.{timestamp}')

    if not dry_run:
        print(f"{Colors.BLUE}💾 Creating backup: {backup_path.name}{Colors.NC}")

        try:
            # Read the file
            print(f"{Colors.GRAY}📖 Reading file...{Colors.NC}")
            with open(claude_json_path, 'r') as f:
                data = json.load(f)

            # Backup original
            with open(backup_path, 'w') as f:
                json.dump(data, f, indent=2)

        except json.JSONDecodeError as e:
            print(f"{Colors.RED}❌ Error: Invalid JSON in ~/.claude.json{Colors.NC}")
            print(f"{Colors.GRAY}   {e}{Colors.NC}")
            return False
    else:
        try:
            with open(claude_json_path, 'r') as f:
                data = json.load(f)
        except json.JSONDecodeError as e:
            print(f"{Colors.RED}❌ Error: Invalid JSON in ~/.claude.json{Colors.NC}")
            return False

    # Count items to clean
    history_count = 0
    history_size_total = 0
    projects_cleaned = 0

    # Clear project histories
    if 'projects' in data and isinstance(data['projects'], dict):
        for proj_id, project in data['projects'].items():
            if not isinstance(project, dict):
                continue

            cleaned_project = False

            # Clear history
            if 'history' in project and project['history']:
                history_count += 1
                projects_cleaned += 1
                hist_size = len(json.dumps(project['history']))
                history_size_total += hist_size

                if hist_size > 1024 * 1024:  # > 1MB
                    print(f"  {Colors.YELLOW}🧹 Large history: {proj_id[:30]}... ({hist_size / 1024 / 1024:.2f} MB){Colors.NC}")
                else:
                    print(f"  {Colors.GRAY}🧹 History: {proj_id[:30]}... ({len(project['history'])} entries){Colors.NC}")

                if not dry_run:
                    project['history'] = []

            # Clear other chat fields
            chat_fields = [
                'conversation', 'messages', 'chat', 'conversations',
                'messageHistory', 'chatHistory', 'contextCache'
            ]

            for field in chat_fields:
                if field in project and project[field]:
                    field_size = len(json.dumps(project[field]))
                    if field_size > 0:
                        history_size_total += field_size
                        print(f"  {Colors.GRAY}🧹 {field}: {proj_id[:30]}...{Colors.NC}")
                        if not dry_run:
                            if isinstance(project[field], list):
                                project[field] = []
                            elif isinstance(project[field], dict):
                                project[field] = {}
                            else:
                                del project[field]

    # Clear top-level chat data
    top_fields = [
        'globalHistory', 'globalMessages', 'conversations',
        'recentConversations', 'conversationCache', 'chatCache'
    ]

    top_cleared = 0
    for field in top_fields:
        if field in data and data[field]:
            field_size = len(json.dumps(data[field]))
            if field_size > 0:
                history_size_total += field_size
                top_cleared += 1
                print(f"  {Colors.GRAY}🧹 {field}{Colors.NC}")
                if not dry_run:
                    if isinstance(data[field], list):
                        data[field] = []
                    elif isinstance(data[field], dict):
                        data[field] = {}
                    else:
                        del data[field]

    # Summary
    print(f"\n{Colors.WHITE}📊 Summary:{Colors.NC}")
    print(f"   {Colors.CYAN}- {projects_cleaned} project histories cleared{Colors.NC}")
    if top_cleared > 0:
        print(f"   {Colors.CYAN}- {top_cleared} top-level chat fields cleared{Colors.NC}")
    print(f"   {Colors.CYAN}- Total chat data: {history_size_total / 1024 / 1024:.2f} MB{Colors.NC}")

    if dry_run:
        print(f"\n{Colors.YELLOW}💡 Dry run complete. Run without --dry-run to actually clean.{Colors.NC}")
        return True

    # Save cleaned data
    print(f"{Colors.GRAY}✍️  Writing cleaned file...{Colors.NC}")
    with open(claude_json_path, 'w') as f:
        json.dump(data, f, indent=2)

    # Calculate reduction
    new_size = claude_json_path.stat().st_size
    reduction_mb = (original_size - new_size) / 1024 / 1024
    reduction_pct = ((original_size - new_size) / original_size) * 100

    print(f"\n{Colors.GREEN}✨ Success!{Colors.NC}")
    print(f"   {Colors.WHITE}Original: {original_size / 1024 / 1024:.2f} MB{Colors.NC}")
    print(f"   {Colors.WHITE}New size: {new_size / 1024:.2f} KB{Colors.NC}")
    print(f"   {Colors.GREEN}Reduced by: {reduction_pct:.1f}% ({reduction_mb:.2f} MB){Colors.NC}")
    print(f"\n{Colors.BLUE}💡 Backup saved to: {backup_path.name}{Colors.NC}")

    return True

def show_version():
    """Show version information"""
    print("Claude Clear v1.0.0")
    print("© 2025 Claude Clear Contributors")
    print("MIT License")

def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Clean Claude Code configuration file',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python cleaner.py           # Run cleanup
  python cleaner.py --dry-run # Preview changes
  python cleaner.py --version # Show version
        """
    )
    parser.add_argument('--dry-run', action='store_true',
                       help='Show what would be cleaned without making changes')
    parser.add_argument('--version', action='store_true',
                       help='Show version information')
    parser.add_argument('--debug', action='store_true',
                       help='Enable debug output')

    args = parser.parse_args()

    if args.version:
        show_version()
        return True

    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)
        logging.debug("Debug mode enabled")
        logging.debug(f"Config path: {CLAUDE_JSON_PATH}")

    # Check if configuration exists
    if not CLAUDE_JSON_PATH.exists():
        print(f"{Colors.RED}Error: Claude configuration not found at {CLAUDE_JSON_PATH}{Colors.NC}")
        print(f"{Colors.YELLOW}Please run Claude Code at least once to create the configuration.{Colors.NC}")
        return False

    # Check if configuration is readable
    try:
        with open(CLAUDE_JSON_PATH, 'r') as f:
            json.load(f)
    except json.JSONDecodeError as e:
        print(f"{Colors.RED}Error: Configuration file is corrupted or invalid JSON{Colors.NC}")
        print(f"{Colors.YELLOW}Details: {str(e)}{Colors.NC}")
        return False
    except Exception as e:
        print(f"{Colors.RED}Error: Cannot read configuration file{Colors.NC}")
        print(f"{Colors.YELLOW}Details: {str(e)}{Colors.NC}")
        return False

    # Check if running from command line
    if sys.stdin.isatty():
        print_banner()
        print()

    return clean_claude_json(dry_run=args.dry_run)

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)