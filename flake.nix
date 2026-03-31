{
  description = "Example nix-darwin + nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      wsl,
      home-manager,
      nix-homebrew,
      agenix,
      ...
    }:
    let
      username = "ooj";

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forSystems =
        f:
        builtins.listToAttrs (
          map (system: {
            name = system;
            value = f system;
          }) systems
        );

      mkScripts =
        pkgs:
        let
          mkScript =
            name: text:
            pkgs.writeShellApplication {
              inherit name text;
              runtimeInputs = with pkgs; [
                nixfmt-tree
                statix
              ];
            };
        in
        {
          format = mkScript "format" "treefmt --walk git";
          lint = mkScript "lint" "statix check --ignore result .direnv";
          check = mkScript "check" "nix flake check";
          test-all = mkScript "test-all" "check && format && lint";
          rebuild-os = mkScript "rebuild-os" ''
            case "$(uname)" in
              Darwin)
                sudo darwin-rebuild switch --flake .#${username}
                ;;
              Linux)
                sudo nixos-rebuild switch --flake .#${username}
                ;;
            esac
          '';
          rebuild = mkScript "rebuild" "test-all && rebuild-os";
        };
    in
    {
      nixosModules = {
        nots = ./modules/nixos;
        shared = ./modules/shared;
        default = self.nixosModules.nots;
      };

      darwinModules = {
        nots = ./modules/darwin;
        shared = ./modules/shared;
        default = self.darwinModules.nots;
      };

      # OS-specific configs
      nixosConfigurations.${username} = nixpkgs.lib.nixosSystem {
        specialArgs = inputs // {
          inherit username;
        };
        modules = [
          ./hosts/wsl
          wsl.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
      };

      darwinConfigurations.${username} = darwin.lib.darwinSystem {
        specialArgs = inputs // {
          inherit username;
        };
        modules = [
          ./hosts/darwin
          agenix.nixosModules.default
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };

      packages = forSystems (
        system:
        let
          scripts = mkScripts nixpkgs.legacyPackages.${system};
        in
        scripts
        // {
          default = nixpkgs.legacyPackages.${system}.symlinkJoin {
            name = "scripts";
            paths = builtins.attrValues scripts;
          };
        }
      );

      devShells = forSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          buildInputs = builtins.attrValues self.packages.${system};
        };
      });

    };
}
