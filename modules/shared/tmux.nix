{ pkgs, ... }:
{
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
    set -ga terminal-overrides ",tmux-256color:RGB"
  '';
}
