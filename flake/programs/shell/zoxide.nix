{ ... }:
{
  prst.zoxide = {
    homeManager = {
      programs.zoxide = {
        enable = true;
        enableBashIntegration = false;
        enableZshIntegration = true;
      };
    };
  };
}
