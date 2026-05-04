{ ... }:
{
  conlin.mcfly = {
    homeManager = {
      programs.mcfly = {
        enable = true;
        enableBashIntegration = false;
        enableZshIntegration = true;
        keyScheme = "vim";
      };
    };
  };
}
