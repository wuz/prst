{
  pkgs,
  user,
  inputs,
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

  nixpkgs = {
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

  system = {
    primaryUser = user.username;
    defaults = {
      CustomSystemPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = false;
      };
      screencapture = {
        location = "/tmp";
        type = "png";
      };
      dock = {
        autohide = true;
        mru-spaces = false;
        orientation = "bottom";
        showhidden = true;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
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
      obsidian = true;
      notion = true;
      notion-calendar = true;
      notion-mail = true;
      notion-enhanced = true;
      container = true;

      crystalfetch = true;
      keybase = true;
      betterdisplay = true;
      muzzle = true;
      karabiner-elements = true;
      peninsula = true;
      music-presence = true;
      utm = true;
      docker-desktop = true;
      affinity-designer = true;
      affinity-photo = true;
      affinity-publisher = true;
      figma = true;
      brilliant = true;
      slack = true;
      discord = true;

      rockboxutility = false;
      tiny-shield = false;
      inkscape = false;
      inkstitch = false;

      raindropio = true;
      spotify = true;
      deezer = true;
      lastfm = true;
    };
  };
}
