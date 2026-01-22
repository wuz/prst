"""Command implementations for wt CLI."""

import shutil
import sys
from pathlib import Path
from typing import Optional

from .git import Git, GitError, Worktree
from .shell import get_shell_functions


def cmd_init(shell: str) -> int:
    """Initialize wt by generating shell functions.

    Args:
        shell: Shell type ("bash" or "zsh")

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        functions = get_shell_functions(shell)
        print(functions)
        return 0
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


def cmd_home() -> int:
    """Return to the main repository directory.

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()

        # Auto-cleanup before navigating
        _auto_cleanup(git, repo_root, None)

        # Output the path for shell function to cd into
        print(repo_root)
        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        return 1


def cmd_list() -> int:
    """List all worktrees with status.

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()
        worktrees = git.list_worktrees()
        current_path = Path.cwd()

        if not worktrees:
            print("No worktrees found.")
            return 0

        for worktree in worktrees:
            # Determine if this is the current worktree
            is_current = current_path.resolve() == worktree.path.resolve()
            prefix = "* " if is_current else "  "

            # Get branch name or show detached HEAD
            branch_name = worktree.branch or f"HEAD detached at {worktree.commit[:7]}"

            # Build status indicators
            status_parts = []

            # Check if clean or dirty
            wt_git = Git(worktree.path)
            if wt_git.is_clean():
                status_parts.append("clean")
            else:
                # Count uncommitted changes
                result = wt_git._run("status", "--porcelain")
                changes = len([l for l in result.stdout.strip().split("\n") if l])
                status_parts.append(f"{changes} uncommitted")

            # Check ahead/behind if branch has upstream
            if worktree.branch:
                ahead, behind = wt_git.get_tracking_counts()
                if ahead > 0 and behind > 0:
                    status_parts.append(f"{ahead} ahead, {behind} behind")
                elif ahead > 0:
                    status_parts.append(f"{ahead} ahead")
                elif behind > 0:
                    status_parts.append(f"{behind} behind")
                elif ahead == 0 and behind == 0:
                    # Has upstream and is up to date
                    status_parts.append("up to date")

            # Check if this is the main repo (home)
            is_home = worktree.path.resolve() == repo_root.resolve()
            if is_home:
                suffix = " [home]"
            else:
                suffix = ""

            status_str = ", ".join(status_parts) if status_parts else "no status"
            print(f"{prefix}{branch_name} ({status_str}){suffix}")

        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        return 1


def cmd_new(branch: str, from_branch: Optional[str] = None) -> int:
    """Create a new worktree with a branch.

    Args:
        branch: Branch name for the new worktree
        from_branch: Base branch to create from (defaults to main/master)

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()

        # Determine base branch if not specified
        if from_branch is None:
            from_branch = git.get_default_branch()

        # Worktree path is .worktrees/<branch-name>
        worktree_path = repo_root / ".worktrees" / branch

        # Check if worktree already exists
        if worktree_path.exists():
            # Check if it's a valid worktree
            worktrees = git.list_worktrees()
            existing = next((w for w in worktrees if w.path.resolve() == worktree_path.resolve()), None)

            if existing:
                # Valid worktree exists
                print(f"Branch '{branch}' already has a worktree at {worktree_path}", file=sys.stderr)
                print("Would you like to:", file=sys.stderr)
                print("  1. Switch to it", file=sys.stderr)
                print("  2. Remove it and create new worktree", file=sys.stderr)
                print("  3. Cancel", file=sys.stderr)
                choice = input("Choice [1]: ").strip()

                if choice in ("", "1"):
                    # Switch to existing worktree
                    print(f"Switching to existing worktree '{branch}'", file=sys.stderr)
                    print(worktree_path)
                    return 0
                elif choice == "2":
                    # Remove and recreate
                    # Check for uncommitted changes first
                    wt_git = Git(worktree_path)
                    if not wt_git.is_clean():
                        print("Error: Worktree has uncommitted changes. Commit or stash them first.", file=sys.stderr)
                        return 1
                    print(f"Removing existing worktree '{branch}'...", file=sys.stderr)
                    git.worktree_remove(worktree_path)
                    # Continue to create new worktree (don't return here)
                else:
                    print("Cancelled.", file=sys.stderr)
                    return 1
            else:
                # Directory exists but isn't a valid worktree
                print(f"Directory {worktree_path} exists but isn't a valid worktree.", file=sys.stderr)
                print("This might be leftover from a failed operation.", file=sys.stderr)
                print("Would you like to:", file=sys.stderr)
                print("  1. Remove the directory and continue", file=sys.stderr)
                print("  2. Cancel", file=sys.stderr)
                choice = input("Choice [1]: ").strip()

                if choice in ("", "1"):
                    shutil.rmtree(worktree_path)
                    print(f"Removed {worktree_path}", file=sys.stderr)
                    # Continue to create new worktree
                else:
                    print("Cancelled.", file=sys.stderr)
                    return 1

        # Check if branch exists
        branch_exists = git.branch_exists(branch)

        if branch_exists:
            # Branch exists locally, check out existing branch
            print(f"Creating worktree for existing branch '{branch}'", file=sys.stderr)
            git.worktree_add(worktree_path, branch, create_branch=False)
            print(worktree_path)
        else:
            # Branch doesn't exist locally, check if it exists on remote
            remote_exists = git.remote_branch_exists(branch)

            if remote_exists:
                print(f"Branch '{branch}' exists on remote but not locally.", file=sys.stderr)
                print("Would you like to:", file=sys.stderr)
                print("  1. Create worktree tracking the remote branch", file=sys.stderr)
                print("  2. Create new local branch (will diverge from remote)", file=sys.stderr)
                print("  3. Cancel", file=sys.stderr)
                choice = input("Choice [1]: ").strip()

                if choice in ("", "1"):
                    # Fetch and track remote branch
                    print(f"Fetching remote branch '{branch}'...", file=sys.stderr)
                    git.fetch_remote_branch(branch)
                    print(f"Creating worktree for remote branch '{branch}'", file=sys.stderr)
                    git.worktree_add(worktree_path, branch, create_branch=False)
                    print(worktree_path)
                elif choice == "2":
                    # Create new local branch
                    print(f"Creating worktree for new branch '{branch}' from '{from_branch}'", file=sys.stderr)
                    git.worktree_add(worktree_path, branch, create_branch=True, base_branch=from_branch)
                    print(worktree_path)
                else:
                    print("Cancelled.", file=sys.stderr)
                    return 1
            else:
                # Branch doesn't exist anywhere, create new branch from base
                print(f"Creating worktree for new branch '{branch}' from '{from_branch}'", file=sys.stderr)
                git.worktree_add(worktree_path, branch, create_branch=True, base_branch=from_branch)
                print(worktree_path)

        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        if e.stderr:
            print(f"Git error: {e.stderr}", file=sys.stderr)
        return 1


def cmd_switch(branch: str) -> int:
    """Switch to an existing worktree.

    Args:
        branch: Branch name to switch to

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()
        current_path = Path.cwd()

        # Find the worktree for this branch
        worktrees = git.list_worktrees()
        target_worktree = next((w for w in worktrees if w.branch == branch), None)

        if not target_worktree:
            print(f"Error: No worktree found for branch '{branch}'", file=sys.stderr)
            print(f"Use 'wt new {branch}' to create one.", file=sys.stderr)
            return 1

        # Check if we need to stash changes in current worktree
        # (only if current directory is within a worktree)
        for worktree in worktrees:
            try:
                # Check if current path is within this worktree
                current_path.resolve().relative_to(worktree.path.resolve())
                # We're in this worktree, check if it's clean
                wt_git = Git(worktree.path)
                if not wt_git.is_clean():
                    print(f"Stashing uncommitted changes in '{worktree.branch}'...", file=sys.stderr)
                    wt_git.stash_push(f"Auto-stash from wt switch to {branch}")
                    print("Stashed uncommitted changes", file=sys.stderr)
                break
            except ValueError:
                # Not relative to this worktree, continue
                continue

        # Auto-cleanup before switching (exclude target worktree)
        _auto_cleanup(git, repo_root, target_worktree.path)

        # Output target path for shell to cd
        print(target_worktree.path)
        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        if e.stderr:
            print(f"Git error: {e.stderr}", file=sys.stderr)
        return 1


def _find_stale_worktrees(git: Git, repo_root: Path, exclude_path: Optional[Path] = None) -> list[Worktree]:
    """Find stale worktrees that can be cleaned up.

    A worktree is stale if:
    - Its branch has been merged into the default branch
    - The worktree has no uncommitted changes

    Args:
        git: Git instance
        repo_root: Repository root path
        exclude_path: Path to exclude from cleanup (typically current/target worktree)

    Returns:
        List of stale worktrees
    """
    worktrees = git.list_worktrees()
    default_branch = git.get_default_branch()
    stale = []

    for worktree in worktrees:
        # Skip if no branch (detached HEAD)
        if not worktree.branch:
            continue

        # Skip the default branch worktree
        if worktree.branch == default_branch:
            continue

        # Skip the home directory
        if worktree.path.resolve() == repo_root.resolve():
            continue

        # Skip excluded path
        if exclude_path and worktree.path.resolve() == exclude_path.resolve():
            continue

        # Check if worktree is clean
        wt_git = Git(worktree.path)
        if not wt_git.is_clean():
            continue

        # Check if branch is merged
        if git.is_merged(worktree.branch, default_branch):
            stale.append(worktree)

    return stale


def _auto_cleanup(git: Git, repo_root: Path, exclude_path: Optional[Path] = None) -> None:
    """Automatically clean up stale worktrees.

    Args:
        git: Git instance
        repo_root: Repository root path
        exclude_path: Path to exclude from cleanup
    """
    try:
        stale = _find_stale_worktrees(git, repo_root, exclude_path)
        if stale:
            cleaned = []
            for worktree in stale:
                try:
                    git.worktree_remove(worktree.path)
                    cleaned.append(worktree.branch)
                except GitError:
                    # Silently skip if removal fails
                    pass

            if cleaned:
                branches = ", ".join(cleaned)
                count = len(cleaned)
                print(f"Cleaned up {count} merged worktree{'s' if count > 1 else ''}: {branches}", file=sys.stderr)
    except GitError:
        # Silently fail on auto-cleanup errors
        pass


def cmd_clean(dry_run: bool = False, clean_all: bool = False) -> int:
    """Clean up stale worktrees.

    Args:
        dry_run: Show what would be cleaned without doing it
        clean_all: Include unmerged branches (prompts for confirmation)

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()

        if clean_all:
            print("Warning: --all flag will clean ALL worktrees except the current one.", file=sys.stderr)
            response = input("Are you sure? [y/N]: ").strip().lower()
            if response not in ("y", "yes"):
                print("Cancelled.", file=sys.stderr)
                return 0

            # Get all worktrees except home
            worktrees = git.list_worktrees()
            current_path = Path.cwd()
            to_clean = [
                w for w in worktrees
                if w.path.resolve() != repo_root.resolve()
                and w.path.resolve() != current_path.resolve()
            ]
        else:
            to_clean = _find_stale_worktrees(git, repo_root)

        if not to_clean:
            print("No stale worktrees to clean.")
            return 0

        if dry_run:
            print("Would clean the following worktrees:", file=sys.stderr)
            for worktree in to_clean:
                status = "(merged)" if git.is_merged(worktree.branch, git.get_default_branch()) else "(unmerged)"
                print(f"  - {worktree.branch} {status}")
            return 0

        # Clean worktrees
        cleaned = []
        failed = []
        for worktree in to_clean:
            try:
                # Check if it has uncommitted changes
                wt_git = Git(worktree.path)
                if not wt_git.is_clean():
                    print(f"Skipping '{worktree.branch}': has uncommitted changes", file=sys.stderr)
                    continue

                git.worktree_remove(worktree.path)
                cleaned.append(worktree.branch)
            except GitError as e:
                failed.append((worktree.branch, str(e)))

        # Report results
        if cleaned:
            branches = ", ".join(cleaned)
            count = len(cleaned)
            print(f"Cleaned up {count} worktree{'s' if count > 1 else ''}: {branches}")

        if failed:
            print("\nFailed to clean:", file=sys.stderr)
            for branch, error in failed:
                print(f"  - {branch}: {error}", file=sys.stderr)

        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        return 1


def cmd_remove(branch: str) -> int:
    """Remove a specific worktree.

    Args:
        branch: Branch name to remove

    Returns:
        Exit code (0 for success, non-zero for error)
    """
    try:
        git = Git()
        repo_root = git.get_repo_root()

        # Find the worktree
        worktrees = git.list_worktrees()
        target = next((w for w in worktrees if w.branch == branch), None)

        if not target:
            print(f"Error: No worktree found for branch '{branch}'", file=sys.stderr)
            return 1

        # Don't allow removing the home directory
        if target.path.resolve() == repo_root.resolve():
            print(f"Error: Cannot remove the main repository directory", file=sys.stderr)
            return 1

        # Check if merged
        default_branch = git.get_default_branch()
        is_merged = git.is_merged(branch, default_branch)

        if not is_merged:
            print(f"Warning: Branch '{branch}' has not been merged into '{default_branch}'.", file=sys.stderr)
            response = input("Are you sure you want to remove it? [y/N]: ").strip().lower()
            if response not in ("y", "yes"):
                print("Cancelled.", file=sys.stderr)
                return 0

        # Check for uncommitted changes
        wt_git = Git(target.path)
        if not wt_git.is_clean():
            print(f"Error: Worktree has uncommitted changes. Commit or stash them first.", file=sys.stderr)
            return 1

        # Remove the worktree
        git.worktree_remove(target.path)
        print(f"Removed worktree for branch '{branch}'")
        return 0
    except GitError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        if e.stderr:
            print(f"Git error: {e.stderr}", file=sys.stderr)
        return 1
