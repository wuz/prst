"""Main entry point for wt CLI."""

import argparse
import sys
from pathlib import Path


def create_parser() -> argparse.ArgumentParser:
    """Create the argument parser for wt CLI.

    Returns:
        Configured ArgumentParser instance
    """
    parser = argparse.ArgumentParser(
        prog="wt",
        description="Git worktree workflow tool",
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    # init command
    init_parser = subparsers.add_parser(
        "init",
        help="Generate shell functions for bash or zsh"
    )
    init_parser.add_argument(
        "shell",
        choices=["bash", "zsh"],
        help="Shell type (bash or zsh)"
    )

    # new command
    new_parser = subparsers.add_parser(
        "new",
        help="Create a new worktree with a branch"
    )
    new_parser.add_argument(
        "branch",
        help="Branch name for the new worktree"
    )
    new_parser.add_argument(
        "--from",
        dest="from_branch",
        help="Base branch to create from (default: main/master)"
    )

    # switch command (with alias sw)
    switch_parser = subparsers.add_parser(
        "switch",
        aliases=["sw"],
        help="Switch to an existing worktree"
    )
    switch_parser.add_argument(
        "branch",
        help="Branch name to switch to"
    )

    # list command (with alias ls)
    subparsers.add_parser(
        "list",
        aliases=["ls"],
        help="List all worktrees with status"
    )

    # home command
    subparsers.add_parser(
        "home",
        help="Return to main repository directory"
    )

    # clean command
    clean_parser = subparsers.add_parser(
        "clean",
        help="Clean up stale worktrees"
    )
    clean_parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be cleaned without doing it"
    )
    clean_parser.add_argument(
        "--all",
        action="store_true",
        help="Include unmerged branches (prompts for confirmation)"
    )

    # remove command
    remove_parser = subparsers.add_parser(
        "remove",
        help="Remove a specific worktree"
    )
    remove_parser.add_argument(
        "branch",
        help="Branch name to remove"
    )

    return parser


def main():
    """Main entry point."""
    parser = create_parser()
    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    # Import commands module (will be created in next task)
    try:
        from . import commands
    except ImportError:
        print("Error: Commands module not yet implemented", file=sys.stderr)
        return 1

    # Route to appropriate command handler
    try:
        if args.command == "init":
            return commands.cmd_init(args.shell)
        elif args.command == "home":
            return commands.cmd_home()
        elif args.command in ("list", "ls"):
            return commands.cmd_list()
        elif args.command == "new":
            return commands.cmd_new(args.branch, args.from_branch)
        elif args.command in ("switch", "sw"):
            return commands.cmd_switch(args.branch)
        elif args.command == "clean":
            return commands.cmd_clean(args.dry_run, args.all)
        elif args.command == "remove":
            return commands.cmd_remove(args.branch)
        else:
            parser.print_help()
            return 1
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
