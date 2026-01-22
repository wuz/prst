# wt - Git Worktree Workflow Tool

A Python CLI tool that streamlines git worktree workflows with automatic directory navigation through shell function integration. The tool makes it easy to start new feature work, switch between worktrees, and automatically clean up merged branches.

## Features

- Create and manage git worktrees with a single command
- Automatic directory navigation (shell function integration)
- Auto-cleanup of merged branches
- Interactive error recovery for common scenarios
- Smart handling of remote branches
- Minimal dependencies (Python stdlib only)

## Installation

### Via Nix

Add to your Nix configuration:

```nix
environment.systemPackages = with pkgs; [
  wt
];
```

Or build directly:

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./pkgs/wt.nix {}'
```

### One-time Setup

After installation, add the shell functions to your shell configuration:

```bash
# For Bash
wt init bash >> ~/.bashrc
source ~/.bashrc

# For Zsh
wt init zsh >> ~/.zshrc
source ~/.zshrc
```

## Usage

### Basic Workflow

```bash
# Create a new worktree for a feature branch
wt new feature-auth

# Do your work in the new worktree (you're automatically cd'd there)
git add .
git commit -m "Add authentication"

# Switch to another worktree
wt switch feature-login

# Return to main repository
wt home

# List all worktrees with status
wt list

# Clean up merged worktrees
wt clean
```

### Commands

#### `wt new <branch-name> [--from <base-branch>]`

Creates a new worktree with smart branch handling:

- If branch doesn't exist: creates new branch from base (default: main)
- If branch exists locally: checks out existing branch
- If branch exists on remote: prompts to track remote or create new local branch
- Creates worktree in `.worktrees/<branch-name>`
- Automatically cd's into the new worktree

**Examples:**

```bash
wt new feature-auth          # Creates from main
wt new hotfix --from develop # Creates from develop branch
```

**Interactive prompts:**

When branch exists on remote but not locally:
```
Branch 'feature-auth' exists on remote but not locally.
Would you like to:
  1. Create worktree tracking the remote branch
  2. Create new local branch (will diverge from remote)
  3. Cancel
Choice [1]:
```

When worktree already exists:
```
Branch 'feature-auth' already has a worktree at .worktrees/feature-auth
Would you like to:
  1. Switch to it
  2. Remove it and create new worktree
  3. Cancel
Choice [1]:
```

#### `wt switch <branch-name>` (alias: `wt sw`)

Switches to an existing worktree:

- Auto-stashes uncommitted changes in current worktree
- Navigates to target worktree
- Triggers auto-cleanup of merged branches

**Example:**

```bash
wt switch feature-auth
wt sw bugfix-login
```

#### `wt list` (alias: `wt ls`)

Displays all worktrees with git status:

**Output format:**

```
* main (clean, up to date) [home]
  feature-auth (2 uncommitted, 3 ahead)
  bugfix-login (clean, 1 behind)
```

The `*` indicates current location.

#### `wt home`

Returns to the original repository directory (main clone, not necessarily main branch worktree).

**Example:**

```bash
wt home  # cd to ~/code/myproject
```

#### `wt clean [--dry-run] [--all]`

Manually trigger cleanup of stale worktrees.

**Options:**

- `--dry-run`: Show what would be cleaned without doing it
- `--all`: Include all worktrees (prompts for confirmation)

**Example:**

```bash
wt clean --dry-run  # Preview cleanup
wt clean            # Clean merged branches
```

#### `wt remove <branch-name>`

Manually remove a specific worktree (prompts if unmerged).

**Example:**

```bash
wt remove old-feature
```

## Worktree Organization

All worktrees are stored under `.worktrees/` in the main repository:

```
~/code/myproject/              # Main repo (home)
├── .git/
├── .worktrees/
│   ├── feature-auth/          # Worktree for feature-auth branch
│   ├── bugfix-login/          # Worktree for bugfix-login branch
│   └── refactor-api/          # Worktree for refactor-api branch
└── src/
```

## Auto-Cleanup Behavior

### When Cleanup Runs

- Automatically after `wt switch` or `wt home`
- Manually with `wt clean`
- Checks all worktrees except current destination

### What Gets Cleaned

A worktree is "stale" and removed if:

1. Its branch has been merged into the base branch (usually `main`)
2. The worktree has no uncommitted changes

### Safety Checks

- Never removes worktrees with uncommitted changes
- Shows summary: `Cleaned up 2 merged worktrees: feature-auth, bugfix-login`
- Removes both worktree directory and git worktree reference

## Command Aliases

The shell functions provide both full command names and shortened aliases:

- `wt new` = `wt-new`
- `wt switch` = `wt-switch` or `wt sw` or `wt-sw`
- `wt list` = `wt-list` or `wt ls` or `wt-ls`
- `wt home` = `wt-home`
- `wt clean` = `wt-clean`
- `wt remove` = `wt-remove`

## Development

### Run from source

```bash
python3 -m wt
```

### Project Structure

```
pkgs/wt-src/
├── setup.py          # Python package metadata
├── wt/
│   ├── __init__.py
│   ├── __main__.py   # Entry point
│   ├── commands.py   # Command implementations
│   ├── git.py        # Git operations wrapper
│   ├── shell.py      # Shell function generation
│   └── config.py     # Config management
└── README.md
```

## Requirements

- Python 3.8 or later
- Git 2.5 or later (for worktree support)
- Bash or Zsh shell

## License

MIT
