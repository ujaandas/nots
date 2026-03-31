{
  lib,
  config,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}:
let
  cfg = config.nots.features;
  dotUsername = config.nots.username;
in
{
  options.nots.features = {
    extraCasks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Use Homebrew casks (GUI) if something is unavailable/broken in nixpkgs.";
    };
    extraBrews = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Use Homebrew brews (CLI/tools) if something is unavailable/broken in nixpkgs.";
    };
  };

  config = {
    # Declarative installation of homebrew
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = dotUsername;

      taps = {
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
        "homebrew/homebrew-bundle" = homebrew-bundle;
      };

      mutableTaps = false; # Declaratively manage taps
    };

    homebrew = {
      enable = true;
      # Only use if nixpkgs is broken!
      casks = cfg.extraCasks;
      brews = cfg.extraBrews;
      taps = builtins.attrNames config.nix-homebrew.taps; # Align tap config with nix-homebrew
      onActivation.cleanup = "zap"; # Run `brew uninstall --zap` for all formulae not in brewfile
    };
  };
}
