{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nots.features.tmux;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
  notsLib = import ../../lib/nots.nix { inherit lib; };
in
{
  options.nots.features.tmux.enable = lib.mkEnableOption "Enable custom tmux configuration.";

  config = lib.mkIf cfg.enable (
    notsLib.mkProgramConfig {
      inherit hasHomeManager dotUsername;
      program = "tmux";
      attrs = {
        enable = true;
        terminal = "tmux-256color";

        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour "mocha"
              set -g @catppuccin_window_tabs_enabled on
              set -g @catppuccin_date_time "%H:%M"
            '';
          }
          tmuxPlugins.better-mouse-mode
          tmuxPlugins.tmux-which-key
        ];

        extraConfig = ''
          set -ga terminal-overrides ",*:RGB"
        '';
      };
    }
  );
}
