{ ... }:
{
  prst.worktrunk = {
    homeManager = {
      xdg.configFile."worktrunk" = {
        recursive = true;
        source = ../../../configs/worktrunk;
      };
    };
  };
}
