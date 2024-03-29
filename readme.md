# prst - prestidigitate a dev env

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/) ![runs on dark magic](https://img.shields.io/badge/runs%20on-dark%20magic-ff467e)

## install

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
git clone https://github.com/wuz/prst.git ~/.config/nixpkgs
```

### install tools

```bash
# change the name of the system configuration from `prst` to your hostname in flake.nix

nix build .\#darwinConfigurations.$(hostname).system --extra-experimental-features nix-command --extra-experimental-features flakes --impure

./result/sw/bin/darwin-rebuild switch --flake . --impure
```
