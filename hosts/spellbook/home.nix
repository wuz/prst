{ user, inputs, ... }: {
  imports = [
    inputs.firefox-darwin.darwinModules.home-manager
    ../../modules/home-manager
  ];
  firefox.enable = true;
  direnv.enable = true;
  zoxide.enable = true;
  mcfly.enable = true;
  programs.gpg.enable = true;
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
  # kitty.enable = true;
  # node.enable = true;
  # python.enable = true;
  # shell = {
  #   bash.enable = true;
  #   zsh.enable = true;
  #   fish.enable = true;
  # };
  # tools.enable = true;
  # wget.enable = true;
}
