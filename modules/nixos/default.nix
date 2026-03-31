{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../shared # Pull in all base options
  ];

  config = {
    # NixOS-specific Nix settings
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.05";

    # Install git system-wide
    programs.git.enable = true;

    # Configure userspace
    users.users.${config.nots.username} = {
      name = config.nots.username;
      isNormalUser = true;
      home = "/home/${config.nots.username}";
      shell = pkgs.zsh;
      uid = lib.mkForce 1001;
    };
  };
}
