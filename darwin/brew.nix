{ config, ... }:

{
  homebrew = {
    enable = true;
    autoUpdate = true;
    cleanup = "zap";

    taps = [
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

    brews = [ ];

    casks = [
      "insomnia"
      "alfred"
      "monitorcontrol"
      "ubersicht"
      "cleanshot"
      "muzzle"
      "owncloud"

      "affinity-designer"
      "affinity-photo"

      "visual-studio-code"
      "keybase"
      "bartender"
      "tunnelblick"
      "rectangle"
      "karabiner-elements"

      "qlcolorcode"
      "qlstephen"
      "qlmarkdown"
      "quicklook-json"
      "quicklook-csv"

      "slack"
      "zoom"

      "audio-hijack"
      "spotify"

      "radicle-upstream"
    ];

    masApps = {
      Pages = 409201541;
      WebcamSettings = 533696630;
      Contrast = 1254981365;
      NextMeeting = 1017470484;
      Displays = 1107272470;
    };

    extraConfig = "";
  };

  system.activationScripts.extraUserActivation.text = ''
    ${config.system.activationScripts.homebrew.text}
  '';

}
