{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.nots.features.kitty;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
  notsLib = import ../../lib/nots.nix { inherit lib; };
in
{
  options.nots.features.kitty.enable = lib.mkEnableOption "Enable custom Kitty configuration.";

  config = lib.mkIf cfg.enable (
    notsLib.mkProgramConfig {
      inherit hasHomeManager dotUsername;
      program = "kitty";
      attrs = {
        enable = true;
        enableGitIntegration = true;

        font = {
          name = "JetBrainsMono Nerd Font";
          size = 14;
        };

        themeFile = "Catppuccin-Macchiato";

        shellIntegration = {
          enableZshIntegration = true;
          mode = "no-cursor";
        };

        keybindings = {
          "ctrl+shift+t" = "new_tab";
          "ctrl+shift+w" = "close_tab";
          "ctrl+shift+f" = "search";
          "ctrl+shift+n" = "new_window";
          "ctrl+shift+up" = "scroll_line_up";
          "ctrl+shift+down" = "scroll_line_down";
          "ctrl+shift+left" = "previous_tab";
          "ctrl+shift+right" = "next_tab";
        };

        actionAliases = {
          "launch_tab" = "launch --cwd=current --type=tab";
          "launch_window" = "launch --cwd=current --type=os-window";
        };

        settings = {
          scrollback_lines = 10000;
          enable_audio_bell = false;
          update_check_interval = 0;
          confirm_os_window_close = 1;
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          window_border_width = 2;
        };
      };
    }
  );
}
