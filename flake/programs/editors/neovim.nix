{ inputs, ... }: {
  work.neovim = {
    homeManager = { pkgs, config, ... }: {
      home.shellAliases.vim = "nvim";

      programs.neovim = {
        package = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default;
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
      };

      xdg.configFile = {
        "nvim/init.lua".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/darwin/configs/nvim/init.lua";
        "nvim/lua/plugins.lua".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/darwin/configs/nvim/lua/plugins.lua";
        "nvim/lua/snippets/typescriptreact.lua".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/darwin/configs/nvim/lua/snippets/typescriptreact.lua";
        "nvim/snippets/package.json".source =
          config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/darwin/configs/nvim/snippets/package.json";
      };
    };
  };
}
