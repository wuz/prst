{
  user,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nur.modules.homeManager.default
    # inputs.pkgs-wuz.darwinModules.hm-zen-browser
    inputs.zen-browser.homeModules.beta
    ../../modules/home-manager
  ];
  home.sessionVariables = {
    USER = user.username;
    PATH = "/opt/homebrew/bin:/etc/profiles/per-user/conlin.durbin/bin:$HOME/.local/bin:$PATH";
  };
  programs.ssh = {
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
  programs.firefox = {
    enable = false;
    policies = {
      AppAutoUpdate = false;
      DisableAppUpdate = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      # DisplayMenuBar = "default-off";
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      HardwareAcceleration = true;
    };
  };
  browser.enable = true;
  direnv.enable = true;
  zoxide.enable = true;
  mcfly.enable = true;
  programs.gpg.enable = true;
  programs.himalaya.enable = true;
  programs.tiny.enable = true;
  programs.xplr.enable = true;
  bat.enable = true;
  optout.enable = true;
  git = {
    enable = true;
    user = {
      inherit (user) name key;
      email = "conlin.durbin@whatnot.com";
    };
  };
}
