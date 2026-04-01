{ ... }:
{
  # Compatibility with NixOS
  home.stateVersion = "24.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Setup XDG directories and environment variables
  xdg.enable = true;
  imports = [
    ./accounts.nix
    ./git.nix
    # Languages
    ./languages/nix.nix
    ./languages/node.nix
    ./languages/rust.nix
    # Apps
    ./apps/browser.nix
    ./apps/neovim.nix
    ./apps/wezterm.nix
    ./apps/ghostty.nix
    # Terminal
    ./terminal/zsh.nix
    ./terminal/starship.nix
    ./terminal/bat.nix
    ./terminal/worktrunk.nix
    ./terminal/zoxide.nix
    ./terminal/mcfly.nix
    ./terminal/bin.nix
    ./terminal/tui.nix
    ./terminal/direnv.nix
    ./terminal/himalaya.nix
    # Other
    ./other/optout.nix
  ];
}
