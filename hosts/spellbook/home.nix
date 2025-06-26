{
  user,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nur.modules.homeManager.default
    inputs.pkgs-wuz.darwinModules.hm-zen-browser
    ../../modules/home-manager
  ];
  home.sessionVariables = {
    USER = user.username;
    PATH = "/opt/homebrew/bin:/etc/profiles/per-user/conlin.durbin/bin:$PATH";
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
  programs.firefox = {
    enable = true;
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
