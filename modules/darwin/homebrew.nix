{
  config,
  username,
  homebrew-core,
  homebrew-cask,
  homebrew-bundle,
  ...
}:
let
  # Access the user-level features from the system-level config
  hmFeatures = config.home-manager.users.${username}.features;
in
{
  # Declarative installation of homebrew
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;

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
    casks = hmFeatures.extraCasks;
    brews = hmFeatures.extraBrews;
    taps = builtins.attrNames config.nix-homebrew.taps; # Align tap config with nix-homebrew
    onActivation.cleanup = "zap"; # Run `brew uninstall --zap` for all formulae not in brewfile
  };
}
