{
  pkgs,
  user,
  inputs,
  system-overlays,
  ...
}:
let
  uid = 502;
in
{
  ids.gids.nixbld = 350;
  imports = [
  ]
  ++ (import ../../modules/darwin)
  ++ (import ../../modules/shared);
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;
  users = {
    knownUsers = [ user.username ];
    users.${user.username} = {
      name = user.username;
      description = user.name;
      home = "/Users/${user.username}";
      shell = pkgs.${user.shell};
      uid = uid;
    };
  };

  nix-homebrew = {
    enable = false;
    enableRosetta = true;
    user = user.username;
    autoMigrate = true;
  };

  nixpkgs = {
    overlays = system-overlays "aarch64-darwin";
    config = {
      allowUnfree = true;
      allowBroken = true;
      permittedInsecurePackages = [
        "python3.13-ecdsa-0.19.1"
      ];
    };
  };

  environment.pathsToLink = [
    "/share/zsh"
  ];

  programs.nix-index.enable = true;

  system = {
    primaryUser = user.username;
    activationScripts.extraActivation.text = ''
      # Reload macOS settings without requiring logout/login
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  documentation.enable = false;

  homebrew = {
    apps = {
      ghostty = true;
      fruit-screensaver = true;
      raycast = true;
      notchnook = true;
      lm-studio = true;
      obsidian = true;
      notion = true;
      notion-calendar = true;
      notion-mail = true;
      # container = true;

      crystalfetch = true;
      keybase = true;
      betterdisplay = true;
      karabiner-elements = true;
      music-presence = true;
      utm = true;
      docker-desktop = false;
      figma = true;
      slack = true;
      discord = true;

      rockboxutility = false;
      tiny-shield = false;
      inkscape = false;
      inkstitch = false;

      raindropio = true;
      spotify = true;
    };
  };
}
