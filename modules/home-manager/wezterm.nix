{ ... }: {
  programs.wezterm = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };
  xdg.configFile."wezterm" = {
    recursive = true;
    source = ../../configs/wezterm;
  };
}
