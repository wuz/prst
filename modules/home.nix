inputs@{ pkgs, lib, config, home-manager, nix-darwin, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
in {
  home-manager.users."conlin.durbin" = {
    home = {
      stateVersion = "23.11";
      sessionPath = [ "$HOME/github/whatnot/scripts" ];
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
    programs.mcfly = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
      keyScheme = "vim";
    };
    programs.zoxide = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = true;
    };
    programs.helix = { enable = true; };
    programs.neovim = {
      package = pkgs.neovim;
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
    programs.zellij = {
      enable = true;
      # enableZshIntegration = true;
      settings = {
        theme = "sakura";
        layout = {
          default_tab_template = {
            "tab name=\"editor\" focus=true" = { "pane" = "borderless true"; };
          };
        };
        themes = {
          sakura = {
            fg = "#c5a3a9";
            bg = "#1c1a1c";
            black = "#222436";
            red = "#eb6f92";
            green = "#9ccfd8";
            yellow = "#f6c177";
            blue = "#3e8fb0";
            magenta = "#c4a7e7";
            cyan = "#e0def4";
            white = "#ecdcdd";
            orange = "#ea9a97";
          };
          tokyonight_moon = {
            fg = "#c8d3f5";
            bg = "#2f334d";
            black = "#222436";
            red = "#ff757f";
            green = "#c3e88d";
            yellow = "#ffc777";
            blue = "#82aaff";
            magenta = "#c099ff";
            cyan = "#86e1fc";
            white = "#828bb8";
            orange = "#ff966c";
          };
        };
      };
    };
    xdg.configFile."zellij/layouts/default.kdl".text = ''
      layout {
         default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }
        pane
      }'';
    # xdg.configFile."zellij/plugins/cb"
    xdg.configFile."zellij/layouts/neovim.kdl".text = ''
      layout {
         default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }

        tab name="editor" focus=true {
            pane borderless=true {
              close_on_exit true
            }
        }

        tab name="terminal" {
            pane
            pane size="20%"
        }
      }'';
    programs.gpg = { enable = true; };
    programs.bat = {
      enable = true;
      config = {
        theme = "DankNeon";
        italic-text = "always";
        style = "numbers,changes";
      };
      themes = {
        DankNeon = {
          src = pkgs.fetchFromGitHub {
            owner = "DankNeon";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "31dd0216c33225cde3968f882dca0ad1375bc4e3";
            sha256 = "1xla6qln6fj123q92si59va90syn3fjkn4ynps42fvawyx1n4rld";
          };
          file = "Dank_Neon.tmTheme";
        };
      };
    };
  };
}
