{ lib, ... }: {
  options.direnv = lib.mkEnableOption "direnv";
  config = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
  };
}
