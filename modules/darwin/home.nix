{ lib, ... }:
{
  imports = [
    ../home.nix # Pull in all base options
  ];

  # Darwin-specific options
  options.features = {
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
}
