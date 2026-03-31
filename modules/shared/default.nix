{
  config,
  lib,
  options,
  pkgs,
  username ? null,
  nix-vscode-extensions ? null,
  ...
}:
let
  cfg = config.nots.features;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
in
{
  imports = [
    (lib.mkAliasOptionModule [ "features" ] [ "nots" "features" ])
    ./kitty.nix
    ./tmux.nix
    ./vim.nix
    ./vscode.nix
    ./zsh.nix
  ];

  options.nots = {
    username = lib.mkOption {
      type = lib.types.str;
      default = if username != null then username else "ooj";
      description = "Username to configure for host and Home Manager scopes.";
    };

    features = {
      getStdCliPkgs = lib.mkEnableOption "Enable standard helpful CLI packages.";
      getStdGuiPkgs = lib.mkEnableOption "Enable standard helpful GUI packages.";
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Additional packages to install for this specific machine.";
      };
    };
  };

  config = {
    # Shared nixpkgs config
    nixpkgs = {
      config.allowUnfree = true;
      overlays = lib.optional (nix-vscode-extensions != null) nix-vscode-extensions.overlays.default;
    };

    # Shared nix config
    nix = {
      enable = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
      settings = {
        experimental-features = "nix-command flakes";
        warn-dirty = false; # usually is anyways
      };
      # Old, prefer flakes
      channel.enable = false;
    };

    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];

    # Install Zsh system-wide
    programs.zsh.enable = true;

    home-manager = lib.mkIf hasHomeManager {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        username = dotUsername;
      };
      backupFileExtension = "bak";

      users.${dotUsername} = {
        home = {
          username = dotUsername;
          stateVersion = "25.11";

          packages = lib.flatten [
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
                nixfmt
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
        };

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

        xdg.enable = true;
      };
    };
  };
}
