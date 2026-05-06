# `prst` — prestidigitate a dev env

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/)![runs on dark magic](https://img.shields.io/badge/runs%20on-dark%20magic-ff467e)

Multi-machine Nix configuration for macOS, WSL, and Linux — built on
[den](https://github.com/vic/den),
[flake-parts](https://github.com/hercules-ci/flake-parts), and
[home-manager](https://github.com/nix-community/home-manager).

## Machines

| Host | Platform | User | Purpose |
|------|----------|------|---------|
| `spellbook` | macOS (aarch64-darwin) | `conlin.durbin` | Work MacBook |
| `grimoire` | macOS (aarch64-darwin) | `wuz` | Personal MacBook |
| `tower` | NixOS/WSL (x86_64-linux) | `wuz` | Personal Linux (WSL) |

## How It Works

### Tools

**[Nix](https://nixos.org/)** — the package manager and configuration language
everything is built on.
Nix builds are reproducible:
the same flake inputs always produce the same system.

**[flake-parts](https://github.com/hercules-ci/flake-parts)** — structures the
flake into composable modules.
The entire `flake/` directory is auto-imported using
[import-tree](https://github.com/vic/import-tree), so adding a file to `flake/`
automatically wires it in.

**[den](https://github.com/vic/den)** — orchestrates the host/user matrix.
It introduces a few key concepts:

- **Hosts** — defined in `flake/hosts/<name>/`.
  Each host declares which system-level *nodes* it uses and which user programs
  to activate.
- **Aspects** — composable configuration bundles.
  A host aspect contains `darwin = { ...
  }` or `nixos = { ...
  }` OS config.
  A user aspect contains `homeManager = { ...
  }` config.
- **Namespaces** — named scopes for aspects.
  `work.*` contains program configurations shared across work machines;
  `personal.*` holds the personal user definition.
- **Forwarding classes** — den automatically routes `homeManager = { ...
  }` keys from user aspects into `home-manager.users.<name>.*`, and `user = {
  ...
  }` keys into `users.users.<name>.*`.

**[home-manager](https://github.com/nix-community/home-manager)** — manages
user-level configuration:
shell, editors, CLI tools, dotfiles, and browser.

**[sops-nix](https://github.com/Mic92/sops-nix)** — encrypts secrets with age
keys derived from SSH host keys.
Secrets live in `secrets/hosts/` and `secrets/users/`, encrypted per-host.

**[nix-darwin](https://github.com/LnL7/nix-darwin)** — applies system-level
configuration on macOS:
system defaults, Homebrew casks, launchd services, PAM.

### Structure

```
flake/
├── den.nix              # Imports den + defines global defaults (define-user battery)
├── namespaces.nix       # Registers the "nodes" namespace for system aspects
├── overlays.nix         # nixpkgs overlays (NUR, neovim-nightly, custom pkgs) + system list
├── formatter.nix        # treefmt: nixfmt, shfmt, stylua, yamlfmt, prettier
├── dev-shells.nix       # nix develop: sops, age, nixd, statix, deadnix
├── modules/             # System-level den "nodes" aspects (shared across hosts)
│   ├── nix.nix          # Nix daemon settings, substituters, GC
│   ├── system.nix       # macOS system defaults (dock, finder, keyboard)
│   ├── shell.nix        # System shells (zsh, bash)
│   ├── packages.nix     # System-wide packages (opencode, go, python, kubectl…)
│   ├── homebrew.nix     # Declarative Homebrew cask/brew management
│   ├── sops.nix         # sops-nix secret decryption (github token → nix.extraOptions)
│   ├── auto-update.nix  # Launchd/systemd timer for daily self-updates
│   └── wsl.nix          # NixOS-WSL module
├── hosts/
│   ├── spellbook/       # Work MacBook (conlin.durbin, aarch64-darwin)
│   ├── grimoire/        # Personal MacBook (wuz, aarch64-darwin)
│   └── tower/           # WSL (wuz, x86_64-linux)
├── users/
│   ├── work/            # work namespace: conlin.durbin user definition
│   └── personal/        # personal namespace: wuz user definition
└── programs/            # home-manager aspects, all under work.* namespace
    ├── git.nix          # git, lazygit, gh — identity set per-host
    ├── browser.nix      # Zen Browser with extensions, containers, Kagi search
    ├── privacy.nix      # Telemetry opt-out env vars
    ├── ssh.nix          # SSH config + GPG
    ├── email.nix        # Himalaya email client
    ├── jujutsu.nix      # Jujutsu VCS
    ├── shell/           # zsh, starship, direnv, zoxide, mcfly
    ├── editors/         # neovim (nightly), wezterm, ghostty, zed
    ├── terminal/        # bat, eza, btop, fd, ripgrep, lazydocker…
    └── languages/       # node, rust, lua, ruby, nix tools

configs/                 # Raw config files (ghostty, wezterm, starship, worktrunk)
overlays/                # Custom nixpkgs overlay (direnv fix, custom scripts)
pkgs/                    # Custom package derivations (gh-worktree, llm-tldr…)
secrets/
├── hosts/               # Per-host sops-encrypted secrets (common, spellbook, tower, aether)
└── users/               # Per-user sops-encrypted secrets
```

### How Hosts Are Wired

Each host file (`flake/hosts/<name>/default.nix`) defines two den aspects:

1. **The host aspect** (`spellbook`, `grimoire`, `tower`) — lists which system
   nodes to include and sets OS-specific config.
2. **The user aspect** (`"conlin.durbin"` or `"wuz"`) — sets the git identity,
   then lists which program aspects to activate via `includes`.

Program aspects (`work.git`, `work.neovim`, etc.) live in `flake/programs/`.
Each defines a `homeManager = { pkgs, ...
}:
{ ...
}` key that den routes into `home-manager.users.<name>.*` automatically.

Personal machines (grimoire, tower) use `personal.base` for the `wuz` user
identity and `home.homeDirectory`, then pull in `work.*` program aspects for
tooling — same tools, different identity.

## Secrets Bootstrap

On a new machine, bootstrap the sops age key from your SSH key before switching:

```bash
just bootstrap-sops
```

This derives an age key from `~/.ssh/id_ed25519` and installs it at
`/var/lib/sops-nix/key.txt`, where sops-nix expects it on macOS.

## Installing on a New Mac

### 1. Install Nix

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone the config

```bash
git clone https://github.com/wuz/prst.git ~/.config/darwin
cd ~/.config/darwin
```

### 3. Bootstrap secrets

```bash
just bootstrap-sops
```

### 4. Switch

For a work machine (spellbook):

```bash
just spellbook
```

For a personal machine (grimoire):

```bash
sudo nix run nix-darwin -- switch --flake .#grimoire
```

## Common Commands

```bash
just switch          # Auto-detect host and switch
just spellbook       # Switch spellbook (work mac)
just update          # Update all flake inputs
just fmt             # Format all Nix files
just gc              # Garbage collect (>30 days)
just secret spellbook  # Edit sops secrets for a host
just bootstrap-sops  # Bootstrap age key on new machine (run once)
```
