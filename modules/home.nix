{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }:
let
  inherit (pkgs) fetchFromGithub;
  inherit (pkgs.stdenv) isDarwin;
in {
  home-manager.users."conlin.durbin" = {
    home = {
      stateVersion = "23.11";
	    sessionPath = [
	      "$HOME/github/whatnot/scripts"
	    ];
    };
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
    programs.mcfly = {
      enable = true;
      enableBashIntegration = true;
      keyScheme = "vim";
    };
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
      colorSchemes = {
        tokyonight_night = {
          foreground = "#c0caf5";
          background = "#1a1b26";
          cursor_bg = "#c0caf5";
          cursor_border = "#c0caf5";
          cursor_fg = "#1a1b26";
          selection_bg = "#33467C";
          selection_fg = "#c0caf5";
          ansi = [
            "#15161E" "#f7768e" "#9ece6a" "#e0af68"
            "#7aa2f7"  "#bb9af7" "#7dcfff" "#a9b1d6"
          ];
          brights = [
            "#414868" "#f7768e" "#9ece6a" "#e0af68"
            "#7aa2f7" "#bb9af7" "#7dcfff" "#c0caf5"
          ];
        };
      };
      extraConfig = ''
      local color_scheme = "tokyonight_night"
      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end
      config.color_scheme = color_scheme
      local padding_h = 10
      local padding_v = 10
      local drag_area = 10
      local tab_max_width = 50
      -- tabbar
      config.use_fancy_tab_bar = false
      config.show_tab_index_in_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      config.tab_bar_at_bottom = true
      config.inactive_pane_hsb = {
        brightness = 0.5,
      }
      wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
        local zoomed = ""
        if tab.active_pane.is_zoomed then
          zoomed = "[Z] "
        end

        local index = ""

        return zoomed .. index .. tab.active_pane.title
      end)
      config.default_cursor_style = "BlinkingBar"
      -- fonts
      config.font = wezterm.font_with_fallback({ "Cartograph CF", "RecMonoLinear Nerd Font" })
      config.font_size = 13.5
      config.line_height = 0.8
      config.tab_max_width = tab_max_width
      config.window_padding = {
        left = padding_h,
        right = padding_h,
        top = padding_v + drag_area,
        bottom = padding_v,
      }
      config.window_decorations = "RESIZE"
      -- keys
      config.keys = {
        { key = "r", mods = "SUPER|SHIFT", action = "ReloadConfiguration" },
        {
          key = "d",
          mods = "SUPER",
          action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
        },
        {
          key = "d",
          mods = "SUPER|SHIFT",
          action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
        },
        { key = "w", mods = "SUPER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
        { key = "LeftArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "RightArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
        { key = "UpArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "DownArrow", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "h", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "l", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
        { key = "k", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "j", mods = "SUPER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "z", mods = "SUPER", action = "TogglePaneZoomState" },
      }
      return config
      '';
    };
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
