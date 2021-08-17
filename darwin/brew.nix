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
      "wez/wezterm"
    ];

    brews = [ "pam-u2f" "signal-cli" ];

    casks = [
      "insomnia"
      "alfred"
      "monitorcontrol"
      "ubersicht"
      "cleanshot"
      "muzzle"
      "owncloud"
      "waterfox"
      "brave-browser"
      "itsycal"
      "notion"
      "obsidian"
      "appcleaner"
      "yubico-yubikey-manager"
      "bitwarden"
      "1password"

      "affinity-designer"
      "affinity-photo"

      "visual-studio-code"
      "keybase"
      "bartender"
      "tunnelblick"
      "rectangle"
      "karabiner-elements"
      "iterm2-nightly"
      "wezterm"

      "discord"
      "slack"
      "zoom"
      "signal"
      "pulse-sms"

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
