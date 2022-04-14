{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  nix.binaryCaches = [
    "https://cache.nixos.org/"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.trustedUsers = [
    "@admin"
  ];
  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.shells = [ pkgs.zsh ];

    environment.systemPackages = with pkgs; [ zsh ];

    users.users.wuz = {
      name = "wuz";
      home = "/Users/wuz";
      shell = pkgs.zsh;
    };

    nixpkgs = { config = { allowUnfree = true; }; };
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
	system = aarch64-darwin
	max-jobs = auto
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    };


  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
  };
  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
}
