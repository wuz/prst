# `prst` - prestidigitate a dev env

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/) ![runs on dark magic](https://img.shields.io/badge/runs%20on-dark%20magic-ff467e)

Magical system and home configuration using Nix.

## `configs/`
Any configuration files that are easier to write in another language or that
can't be easily configured in Nix.

## `hosts/`
Host machines, by name.

- `spellbook` - MacBook Pro, mostly for work

## `modules/`
Modules for Nix configurations

- `home-manager/` - all the modules that are managed by home-manager
- `darwin/` - all the modules that require special configuration for Nix Darwin
- `nixos/` - all the modules that require special configuration for NixOS
- `shared/` - all the modules that are shared between configurations

## `pkgs-wuz/`
Overlay for specific packages I use. In need of heavily modification, going to
be migrating to [`pog`](https://pog.gemologic.dev/) soon for scripts.

## installing on Darwin

### install and configure nix

First, [install nix](https://nixos.org/download#nix-install-macos)

Then:

```bash
# warlock's first nix config
mkdir -p ~/.config/nix/
echo -e 'max-jobs = auto\ntarball-ttl = 0\nexperimental-features = nix-command flakes' >>~/.config/nix/nix.conf

# add current user as trusted 
echo "trusted-users = root $USER" | sudo tee -a /etc/nix/nix.conf && sudo pkill nix-daemon
```

### git this

```bash
git clone https://github.com/wuz/prst.git ~/.config/darwin
```

### install tools

```bash
# change the name of the system configuration from `prst` to your hostname in flake.nix

cd ~/.config/darwin
nix run nix-darwin -- switch --flake ~/.config/darwin
```
