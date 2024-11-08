inputs: {
  # Compatibility with NixOS
  home.stateVersion = "24.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Setup XDG directories and environment variables
  xdg.enable = true;
  # Individual imports
  imports = [
    ./starship.nix
    ./wezterm.nix
    ./git.nix
    ./neovim.nix
    ./firefox.nix
    ./bat.nix
    ./direnv.nix
    ./zoxide.nix
    ./mcfly.nix
    ./packages.nix
    ./optout.nix
  ];
}
