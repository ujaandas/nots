{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nots.features.zsh;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
  notsLib = import ../../lib/nots.nix { inherit lib; };
in
{
  options.nots.features.zsh.enable = lib.mkEnableOption "Enable custom zsh configuration.";

  config = lib.mkIf cfg.enable (
    notsLib.mkProgramConfig {
      inherit hasHomeManager dotUsername;
      program = "zsh";
      attrs = {
        enable = true;

        # basic stuff
        autocd = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        # history
        history = {
          size = 10000;
          save = 10000;
          share = true;
          ignoreDups = true;
          ignoreSpace = true;
          extended = true;
        };

        # aliases
        shellAliases = {
          ls = "eza --icons=always $@";
          ll = "eza -l";
          la = "eza -la";
          lso = "ls";

          bat = "bat --paging=never";

          top = "btop";
          topo = "top";

          cd = "z";
          cdo = "cd";
        };

        # init extra
        initContent = lib.mkBefore ''
          export EDITOR=vim
          export FZF_DEFAULT_COMMAND="fd --type f"
          eval "$(zoxide init zsh)"
          eval "$(direnv hook zsh)"
          source ${./p10k.zsh}
        '';

        # plugins
        plugins = [
          {
            name = pkgs.zsh-powerlevel10k.pname;
            inherit (pkgs.zsh-powerlevel10k) src;
            file = "powerlevel10k.zsh-theme";
          }
        ];
      };
    }
  );
}
