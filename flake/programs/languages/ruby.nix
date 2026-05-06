{ ... }:
{
  prst.ruby = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ruby_3_3
          rubocop
        ];
      };
  };
}
