{ ... }:
{
  nodes.system = {
    darwin = {
      system.defaults = {
        CustomSystemPreferences = {
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            _FXSortFoldersFirst = true;
            FXDefaultSearchScope = "SCcf";
          };
          "com.apple.desktopservices" = {
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
  };
}
