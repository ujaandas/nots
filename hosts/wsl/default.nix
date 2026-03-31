{
  ...
}:
{
  imports = [
    ../../modules/nixos
  ];

  wsl.enable = true;
  wsl.defaultUser = "ooj";

  programs.nix-ld.enable = true;

  boot.enableContainers = true;
  virtualisation.containers.enable = true;

  # Choose features
  nots.features = {
    # Shared packages
    getStdCliPkgs = true;
    getStdGuiPkgs = false;

    # Custom packages
    vim.enable = true;
    tmux.enable = true;
    zsh.enable = true;
    vscode.enable = true;
  };
}
