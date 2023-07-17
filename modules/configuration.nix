{ pkgs, lib, ... }: {
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings.substituters = [ "https://cache.nixos.org/" ];
  nix.settings.trusted-public-keys =
    [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  nix.settings.trusted-users = [ "@admin" ];
  nix.configureBuildUsers = true;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  environment.etc = {
    "davmail.properties" = {
      enable = true;
      source = ../config/davmail/davmail.properties;
    };
  };
  environment.launchAgents = {
    "com.nixos.davmail.plist" = {
      enable = true;
      text = ''
              [<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>davmail</string>
            <key>RunAtLoad</key>
            <true/>
            <key>ProgramArguments</key>
            <array>
                <string>/etc/profiles/per-user/wuz/bin/davmail</string>
                <string>/etc/davmail.properties</string>
            </array>
        </dict>
        </plist>
      '';
    };
    "com.nixos.offlineimap.plist" = {
      enable = true;
      text = ''
              [<?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>offlineimap</string>
            <key>RunAtLoad</key>
            <true/>
            <key>ProgramArguments</key>
            <array>
                <string>/etc/profiles/per-user/wuz/bin/offlineimap</string>
            </array>
        </dict>
        </plist>
      '';
    };
  };

  environment.shells = [ pkgs.zsh ];

  environment.systemPackages = with pkgs; [
    gcc
    msgpack
    libiconv
    coreutils-full
    findutils
    diffutils
    moreutils
    libuv
    gnupg
    zsh
    spotify
    discord
    pinentry_mac
    nodejs_20
    shellcheck
    shellharden
    shfmt
    yarn
    rustc
    rustfmt
    cargo
    go
    ruby_3_0
    rubocop
  ];

  users.users."conlin.durbin" = {
    name = "conlin.durbin";
    home = "/Users/conlin.durbin";
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
  environment.variables = { OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES"; };
  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
}
