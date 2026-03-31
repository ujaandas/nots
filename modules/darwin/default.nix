{ lib, config, ... }:
{
  imports = [
    ../shared # Pull in all base options
    ./system.nix # Get system settings
    ./homebrew.nix # Get Homebrew stuff
  ];

  config = {
    # Darwin-specific Nix settings
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Darwin-specific HM settings
    home-manager = {
      sharedModules = [
        { targets.darwin.linkApps.enable = false; }
      ];
      users.${config.nots.username}.home.homeDirectory = lib.mkForce "/Users/${config.nots.username}";
    };

    # Configure userspace
    users.users.${config.nots.username} = {
      name = config.nots.username;
      home = "/Users/${config.nots.username}";
      isHidden = false;
    };
  };
}
