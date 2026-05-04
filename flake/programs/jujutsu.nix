{ ... }:
{
  conlin.jj = {
    homeManager = { ... }: {
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "Conlin Durbin";
            email = "c@wuz.sh";
          };
          git.push-bookmark-prefix = "wuz/push-";
          signing = {
            key = "CAA69BFC5EF24C40";
            signAll = true;
          };
        };
      };
    };
  };
}
