{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/darwin
  ];

  # Choose features
  nots.features = {
    # System settings
    useTouchIdSudo = true;
    useSaneSystemSettings = true;

    # Shared packages
    getStdCliPkgs = true;
    getStdGuiPkgs = true;

    # Custom packages
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    kitty.enable = true;
    vscode.enable = true;

    # Darwin-specific packages
    extraPackages = with pkgs; [
      obsidian
      rectangle
      alt-tab-macos
    ];

    # Darwin-only options (Now valid!)
    extraCasks = [
      "alfred"
    ];
  };
}
