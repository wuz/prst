{ user, inputs, ... }:
{
  imports = [
    # inputs.floorp-darwin.darwinModules.home-manager
    ../../modules/home-manager
  ];
  home.sessionVariables = {
    USER = user.username;
    PATH = "/opt/homebrew/bin:/etc/profiles/per-user/conlin.durbin/bin:$PATH";
  };
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    extraConfig = ''
      IgnoreUnknown UseKeychain
      UseKeychain yes

      Host linux-builder
        User builder
        Hostname localhost
        HostKeyAlias linux-builder
        IdentityFile /etc/nix/builder_ed25519
        Port 31022
    '';
  };
  floorp.enable = true;
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
}
