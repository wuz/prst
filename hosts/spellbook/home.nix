{
  user,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.direnv-instant.homeModules.direnv-instant
    ../../modules/home-manager
  ];
  home.sessionVariables = {
    USER = user.username;
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
  zen.enable = true;
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
