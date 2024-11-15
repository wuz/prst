{ lib, ... }: {
  options.zoxide = lib.mkEnableOption "zoxide";
  config = {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
  };
}

