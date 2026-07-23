{ ... }: {
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

      # nix-darwin master (a1fa429) uses --toc-depth which nixpkgs nixos-render-docs removed.
      # Both the HTML manual and the darwin-uninstaller (which builds its own minimal nix-darwin
      # config with documentation enabled) fail until nix-darwin fixes their manual builder.
      # simplification: workaround, remove once nix-darwin/nix-darwin is fixed
      documentation.doc.enable = false;
      system.tools.darwin-uninstaller.enable = false;
    };
  };
}
