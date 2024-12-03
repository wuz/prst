inputs: {
  # Compatibility with NixOS
  home.stateVersion = "24.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Setup XDG directories and environment variables
  xdg.enable = true;
  # Individual imports
  imports = [
    ./packages.nix
    ./jj.nix
    ./git.nix
    # Languages
    ./languages/nix.nix
    ./languages/lua.nix
    ./languages/node.nix
    ./languages/rust.nix
    # ./languages/ruby.nix
    ./languages/linters.nix
    # Apps
    ./apps/floorp.nix
    ./apps/neovim.nix
    ./apps/wezterm.nix
    ./apps/gui.nix
    # Terminal
    ./terminal/starship.nix
    ./terminal/bat.nix
    ./terminal/zoxide.nix
    ./terminal/mcfly.nix
    ./terminal/zoxide.nix
    ./terminal/bin.nix
    ./terminal/tui.nix
    ./terminal/direnv.nix
    # Other
    ./other/optout.nix
  ];
}
