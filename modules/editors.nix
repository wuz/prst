{ pkgs, lib, home-manager, ... }: {
  home-manager.users."conlin.durbin".xdg.configFile."nvim/parser/lua.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-lua}/parser";
  home-manager.users."conlin.durbin".xdg.configFile."nvim/parser/nix.so".source =
    "${pkgs.tree-sitter.builtGrammars.tree-sitter-nix}/parser";
}
