{ config, pkgs, ... }:

{
  system.activationScripts.extraUserActivation.text = ''
    # Increase sound quality for Bluetooth headphones/headsets
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
    # Automatically quit printer app once the print jobs complete
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
    # Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

    # Sleep the display after 15 minutes
    sudo pmset -a displaysleep 15

    # Disable machine sleep while charging
    sudo pmset -c sleep 0

    # Set machine sleep to 5 minutes on battery
    sudo pmset -b sleep 5
    # Set standby delay to 24 hours (default is 1 hour)
    sudo pmset -a standbydelay 86400
  '';
  system.defaults = {
    LaunchServices.LSQuarantine = false;
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      NSTableViewDefaultSizeMode = 2;
      NSUseAnimatedFocusRing = false;
      AppleShowScrollBars = "WhenScrolling";
      NSWindowResizeTime = "0.001";
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSTextShowsControlCharacters = true;
      NSDisableAutomaticTermination = true;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      AppleFontSmoothing = 1;
    };
    alf = {
      globalstate = 2;
      loggingenabled = 0;
      stealthenabled = 1;
    };
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    dock = {
      autohide = true;
      orientation = "bottom";
      showhidden = true;
      mineffect = "genie";
      launchanim = true;
      show-process-indicators = true;
      tilesize = 48;
      static-only = true;
      mru-spaces = false;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      Dragging = true;
    };
  };
}
