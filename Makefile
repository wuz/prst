.PHONY: nix-build
nix-build:
	sudo nix build ~/.config/nixpkgs\#darwinConfigurations.prst.system --extra-experimental-features nix-command --extra-experimental-features flakes --impure --fallback

.PHONY: darwin-switch
darwin-switch:
	sudo ./result/sw/bin/darwin-rebuild switch --flake ~/.config/nixpkgs --impure

.PHONY: all
all: nix-build darwin-switch
