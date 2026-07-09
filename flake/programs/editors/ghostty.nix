{ ... }:
{
  work.ghostty = {
    homeManager =
      { pkgs, config, lib, ... }:
      let
        scriptDir = ../../../configs/ghostty/scripts;
        scripts = [ "ghostty-lazygit" "ghostty-ide" ];
      in
      {
        programs.ghostty = {
          enable = false; # ghostty on nixpkgs darwin is currently broken
          enableZshIntegration = true;
        };

        # Ghostty config — symlinked as an out-of-store link so edits are live
        # Both Ghostty and cmux read ~/.config/ghostty/config for terminal rendering
        xdg.configFile."ghostty" = {
          recursive = true;
          source = config.lib.file.mkOutOfStoreSymlink ../../../configs/ghostty;
        };

        # cmux config — symlinked so edits are live (reload: Cmd+Shift+,)
        xdg.configFile."cmux/cmux.json" = {
          source = config.lib.file.mkOutOfStoreSymlink ../../../configs/cmux/cmux.json;
        };

        # cmux dock — global dock panels (feed, git, docker, resources, opencode)
        xdg.configFile."cmux/dock.json" = {
          source = config.lib.file.mkOutOfStoreSymlink ../../../configs/cmux/dock.json;
        };

        # zmx — session persistence (macOS only); cmux installed via homebrew cask for latest version
        home.packages = pkgs.lib.optional pkgs.stdenv.isDarwin pkgs.zmx;

        # Scripts — symlink each into ~/.local/bin so they're on PATH
        home.file = lib.listToAttrs (map (name: {
          name = ".local/bin/${name}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${scriptDir}/${name}";
            executable = true;
          };
        }) scripts);
      };
  };
}
