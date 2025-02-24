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
  ] ++ (import ../../modules/darwin);
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;
  users.knownUsers = [ user.username ];
  users.users.${user.username} = {
    name = user.username;
    description = user.name;
    home = "/Users/${user.username}";
    shell = pkgs.${user.shell};
    uid = uid;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  environment.systemPackages = with pkgs; [
    switchaudio-osx
    audio-switcher-d
    gcc
    curl
    gnugrep
    gnupg
    gnused
    gawk
    msgpack
    libiconvReal
    coreutils-full
    findutils
    diffutils
    moreutils
    libuv
    gnupg
    zsh
    pinentry_mac
    # ccmenu
    # deskpad
    nur.repos.rycee.mozilla-addons-to-nix
  ];

  environment.pathsToLink = [
    "/share/zsh"
  ];

  programs.nix-index.enable = true;

  system = {
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

  security.pam.enableSudoTouchIdAuth = true;
  documentation.enable = false;

  nix.enable = false;

  services.ollama = {
    enable = true;
  };

  services.audioswitcher = {
    enable = true;
  };

  homebrew = {
    apps = {
      ghostty = false;
    };
  };
}
