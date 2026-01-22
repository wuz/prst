"""Configuration management for wt."""

import json
from pathlib import Path
from typing import Any, Optional


class Config:
    """Configuration manager for wt tool."""

    def __init__(self, config_path: Optional[Path] = None):
        """Initialize Config manager.

        Args:
            config_path: Path to config file (defaults to ~/.config/wt/config.json)
        """
        if config_path is None:
            config_path = Path.home() / ".config" / "wt" / "config.json"
        self.config_path = config_path
        self._data = self._load()

    def _load(self) -> dict:
        """Load configuration from file.

        Returns:
            Configuration dictionary
        """
        if not self.config_path.exists():
            return {}

        try:
            with open(self.config_path, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return {}

    def _save(self) -> None:
        """Save configuration to file."""
        # Create parent directory if it doesn't exist
        self.config_path.parent.mkdir(parents=True, exist_ok=True)

        with open(self.config_path, "w") as f:
            json.dump(self._data, f, indent=2)

    def get(self, key: str, default: Any = None) -> Any:
        """Get a configuration value using dot notation.

        Args:
            key: Configuration key (supports dot notation like "repo.default_branch")
            default: Default value if key doesn't exist

        Returns:
            Configuration value or default
        """
        keys = key.split(".")
        value = self._data

        for k in keys:
            if isinstance(value, dict) and k in value:
                value = value[k]
            else:
                return default

        return value

    def set(self, key: str, value: Any) -> None:
        """Set a configuration value using dot notation.

        Args:
            key: Configuration key (supports dot notation like "repo.default_branch")
            value: Value to set
        """
        keys = key.split(".")
        data = self._data

        # Navigate to the parent of the target key
        for k in keys[:-1]:
            if k not in data or not isinstance(data[k], dict):
                data[k] = {}
            data = data[k]

        # Set the value
        data[keys[-1]] = value
        self._save()

    def get_repo_config(self, repo_path: Path) -> dict:
        """Get configuration for a specific repository.

        Args:
            repo_path: Path to repository

        Returns:
            Repository configuration dictionary
        """
        repo_key = str(repo_path.resolve())
        repos = self.get("repos", {})
        return repos.get(repo_key, {})

    def set_repo_config(self, repo_path: Path, config: dict) -> None:
        """Set configuration for a specific repository.

        Args:
            repo_path: Path to repository
            config: Configuration dictionary to set
        """
        repo_key = str(repo_path.resolve())
        repos = self.get("repos", {})
        repos[repo_key] = config
        self.set("repos", repos)
