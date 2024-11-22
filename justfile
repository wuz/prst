all:
  nix run nix-darwin -- switch --flake ~/.config/darwin#prst

verbose:
  nix run nix-darwin -- switch --flake ~/.config/darwin#prst -vvv
