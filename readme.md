# prst - prestidigitate a dev env

[![uses nix](https://img.shields.io/badge/uses-nix-%237EBAE4)](https://nixos.org/) ![runs on dark magic](https://img.shields.io/badge/runs%20on-dark%20magic-ff467e)

## install

### install and configure nix

```bash
# install in one command
curl -L https://nixos.org/nix/install | sh

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
nix build .\#darwinConfigurations.prst.system --extra-experimental-features nix-command --extra-experimental-features flakes --impure

./result/sw/bin/darwin-rebuild switch --flake . --impure
```
