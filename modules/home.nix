{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.features;
in
{
  imports = [
    ./features/kitty.nix
    ./features/tmux.nix
    ./features/vim.nix
    ./features/vscode.nix
    ./features/zsh.nix
  ];

  options.features = {
    getStdCliPkgs = lib.mkEnableOption "Enable standard helpful CLI packages.";
    getStdGuiPkgs = lib.mkEnableOption "Enable standard helpful GUI packages.";
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to install for this specific machine.";
    };
  };

  config = {
    home.username = username;
    home.stateVersion = "25.11";

    xdg.enable = true;

    home.packages = lib.flatten [
      # Essential CLI tools
      (with pkgs; [
        zsh
        eza
        bat
        btop
        ripgrep
        fd
      ])

      # Extra CLI suite
      (lib.optionals cfg.getStdCliPkgs (
        with pkgs;
        [
          nixd
          nixfmt-rfc-style
          wget
          cowsay
        ]
      ))

      # Extra GUI suite
      (lib.optionals cfg.getStdGuiPkgs (
        with pkgs;
        [
          firefox-unwrapped
          discord
          zoom-us
        ]
      ))

      # Extension hook
      cfg.extraPackages
    ];

    programs = {
      home-manager.enable = true;

      # Standard CLI suite
      eza.enable = true;
      bat.enable = true;
      btop.enable = true;
      ripgrep.enable = true;

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
