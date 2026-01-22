"""Git operations wrapper."""

import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Optional


@dataclass
class Worktree:
    """Represents a git worktree."""

    path: Path
    branch: Optional[str]
    commit: str
    is_bare: bool


class GitError(Exception):
    """Exception raised for git operation failures."""

    def __init__(self, message: str, returncode: Optional[int] = None, stderr: Optional[str] = None):
        """Initialize GitError.

        Args:
            message: Error message
            returncode: Git command return code
            stderr: Git command stderr output
        """
        self.message = message
        self.returncode = returncode
        self.stderr = stderr
        super().__init__(message)


class Git:
    """Wrapper for git operations."""

    def __init__(self, repo_path: Optional[Path] = None):
        """Initialize Git wrapper.

        Args:
            repo_path: Path to git repository (defaults to current directory)
        """
        self.repo_path = repo_path or Path.cwd()

    def _run(self, *args: str, check: bool = True, capture_output: bool = True) -> subprocess.CompletedProcess:
        """Run a git command.

        Args:
            *args: Git command arguments
            check: Whether to check return code
            capture_output: Whether to capture stdout/stderr

        Returns:
            CompletedProcess instance

        Raises:
            GitError: If command fails and check=True
        """
        cmd = ["git", "-C", str(self.repo_path)] + list(args)

        try:
            result = subprocess.run(
                cmd,
                capture_output=capture_output,
                text=True,
                check=False
            )

            if check and result.returncode != 0:
                raise GitError(
                    f"Git command failed: {' '.join(args)}",
                    returncode=result.returncode,
                    stderr=result.stderr
                )

            return result

        except FileNotFoundError as e:
            raise GitError("git command not found") from e

    def get_repo_root(self) -> Path:
        """Get the root directory of the git repository.

        Returns:
            Path to repository root

        Raises:
            GitError: If not in a git repository
        """
        result = self._run("rev-parse", "--show-toplevel")
        return Path(result.stdout.strip())

    def get_current_branch(self) -> Optional[str]:
        """Get the current branch name.

        Returns:
            Current branch name, or None if in detached HEAD state

        Raises:
            GitError: If git command fails
        """
        result = self._run("branch", "--show-current")
        branch = result.stdout.strip()
        return branch if branch else None

    def branch_exists(self, branch: str) -> bool:
        """Check if a branch exists locally.

        Args:
            branch: Branch name to check

        Returns:
            True if branch exists, False otherwise
        """
        result = self._run("branch", "--list", branch, check=False)
        return bool(result.stdout.strip())

    def get_default_branch(self) -> str:
        """Get the default branch name (main or master).

        Returns:
            "main" if it exists, otherwise "master"
        """
        if self.branch_exists("main"):
            return "main"
        return "master"

    def list_worktrees(self) -> list[Worktree]:
        """List all worktrees.

        Returns:
            List of Worktree objects

        Raises:
            GitError: If git command fails
        """
        result = self._run("worktree", "list", "--porcelain")
        worktrees = []
        current_worktree = {}

        for line in result.stdout.strip().split("\n"):
            if not line:
                # Empty line separates worktrees
                if current_worktree:
                    worktrees.append(Worktree(
                        path=Path(current_worktree["worktree"]),
                        branch=current_worktree.get("branch"),
                        commit=current_worktree["HEAD"],
                        is_bare=current_worktree.get("bare", False)
                    ))
                    current_worktree = {}
                continue

            if line.startswith("worktree "):
                current_worktree["worktree"] = line[9:]
            elif line.startswith("HEAD "):
                current_worktree["HEAD"] = line[5:]
            elif line.startswith("branch "):
                # Branch format is "refs/heads/branch-name"
                branch_ref = line[7:]
                if branch_ref.startswith("refs/heads/"):
                    current_worktree["branch"] = branch_ref[11:]
            elif line == "bare":
                current_worktree["bare"] = True

        # Handle last worktree if file doesn't end with empty line
        if current_worktree:
            worktrees.append(Worktree(
                path=Path(current_worktree["worktree"]),
                branch=current_worktree.get("branch"),
                commit=current_worktree["HEAD"],
                is_bare=current_worktree.get("bare", False)
            ))

        return worktrees

    def worktree_add(self, path: Path, branch: str, create_branch: bool = False, base_branch: Optional[str] = None) -> None:
        """Add a new worktree.

        Args:
            path: Path where worktree should be created
            branch: Branch name for the worktree
            create_branch: Whether to create a new branch
            base_branch: Base branch for new branch (only used if create_branch=True)

        Raises:
            GitError: If git command fails
        """
        args = ["worktree", "add"]

        if create_branch:
            args.append("-b")
            args.append(branch)
            args.append(str(path))
            if base_branch:
                args.append(base_branch)
        else:
            args.append(str(path))
            args.append(branch)

        self._run(*args)

    def worktree_remove(self, path: Path, force: bool = False) -> None:
        """Remove a worktree.

        Args:
            path: Path to worktree to remove
            force: Whether to force removal

        Raises:
            GitError: If git command fails
        """
        args = ["worktree", "remove", str(path)]
        if force:
            args.append("--force")

        self._run(*args)

    def is_clean(self, path: Optional[Path] = None) -> bool:
        """Check if the working tree is clean (no uncommitted changes).

        Args:
            path: Path to check (defaults to repo_path)

        Returns:
            True if working tree is clean, False otherwise

        Raises:
            GitError: If git command fails
        """
        check_path = path or self.repo_path
        git = Git(check_path)
        result = git._run("status", "--porcelain")
        return not bool(result.stdout.strip())

    def stash_push(self, message: str, path: Optional[Path] = None) -> None:
        """Stash uncommitted changes.

        Args:
            message: Stash message
            path: Path to stash from (defaults to repo_path)

        Raises:
            GitError: If git command fails
        """
        check_path = path or self.repo_path
        git = Git(check_path)
        git._run("stash", "push", "-m", message)

    def is_merged(self, branch: str, into: str) -> bool:
        """Check if a branch has been merged into another branch.

        Args:
            branch: Branch to check
            into: Base branch to check against

        Returns:
            True if branch is merged into base, False otherwise

        Raises:
            GitError: If git command fails
        """
        result = self._run("branch", "--merged", into, check=False)
        merged_branches = [line.strip().lstrip("* ") for line in result.stdout.split("\n") if line.strip()]
        return branch in merged_branches

    def get_tracking_counts(self, path: Optional[Path] = None) -> tuple[int, int]:
        """Get ahead/behind counts relative to upstream branch.

        Args:
            path: Path to check (defaults to repo_path)

        Returns:
            Tuple of (ahead_count, behind_count)
            Returns (0, 0) if no upstream branch is set

        Raises:
            GitError: If git command fails (other than no upstream)
        """
        check_path = path or self.repo_path
        git = Git(check_path)

        # Check if upstream exists
        result = git._run("rev-parse", "--abbrev-ref", "@{u}", check=False)
        if result.returncode != 0:
            # No upstream branch
            return (0, 0)

        # Get ahead count
        result_ahead = git._run("rev-list", "--count", "@{u}..", check=False)
        ahead = int(result_ahead.stdout.strip()) if result_ahead.returncode == 0 else 0

        # Get behind count
        result_behind = git._run("rev-list", "--count", "..@{u}", check=False)
        behind = int(result_behind.stdout.strip()) if result_behind.returncode == 0 else 0

        return (ahead, behind)

    def remote_branch_exists(self, branch: str, remote: str = "origin") -> bool:
        """Check if a branch exists on the remote.

        Args:
            branch: Branch name to check
            remote: Remote name (defaults to "origin")

        Returns:
            True if remote branch exists, False otherwise
        """
        result = self._run("ls-remote", "--heads", remote, f"refs/heads/{branch}", check=False)
        return bool(result.stdout.strip())

    def fetch_remote_branch(self, branch: str, remote: str = "origin") -> None:
        """Fetch a remote branch and create a local tracking branch.

        Args:
            branch: Branch name to fetch
            remote: Remote name (defaults to "origin")

        Raises:
            GitError: If git command fails
        """
        # Fetch the remote branch
        self._run("fetch", remote, branch)
        # Create local branch tracking the remote
        self._run("branch", "--track", branch, f"{remote}/{branch}")
