{ lib, ... }: {
  options.mcfly = lib.mkEnableOption "mcfly";
  config = {
    programs.mcfly = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
  };
}
