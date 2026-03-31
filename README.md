# ❄️ Nix-Based Dots

A modular, "semi-dendritic" Nix configuration designed for simplicity, extensibility, and ease-of-use that gives me everything, everywhere, all at once.

## Usage

Instead of hunting through nested folders to enable a tool, everything is controlled via a central `nots.features` block. It’s designed to be write-once, toggle-anywhere.

- Every app (Kitty, Zsh, Tmux) is its own self-contained module.
- You can enable entire suites of tools or specific configs with simple booleans or options you define.
- Shared logic lives in `modules/shared`, while platform-specific quirks are handled in `modules/darwin` or `modules/wsl`.

To define a new machine, simply import the relevant platform module and flip the switches you need in your `host` file:

```nix
{ pkgs, ... }:
{
  imports = [
    ../../modules/shared
    ../../modules/darwin
  ];

  # Choose your features
  nots.features = {
    # System & GUI Settings
    getStdCliPkgs = true;
    getStdGuiPkgs = true;

    # App Modules (Custom Configs)
    vim.enable    = true;
    tmux.enable   = true;
    zsh.enable    = true;
    kitty.enable  = true;
    vscode.enable = true;

    # One-off Additions
    extraPackages = with pkgs; [
      obsidian
      rectangle
    ];
  };
}
```

## Reuse in Other Repos

This flake exports reusable modules so other repos can consume your dotfiles like a feature library.

```nix
# consumer flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ooj-dots.url = "github:YOUR_USER/dots";
  };

  outputs = { nixpkgs, ooj-dots, ... }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ooj-dots.nixosModules.nots
        ({ pkgs, ... }: {
          nots.username = "myuser";
          nots.features = {
            getStdCliPkgs = true;
            vim.enable = true;
            tmux.enable = true;
            zsh.enable = true;
          };
        })
      ];
      specialArgs = {
        inherit (ooj-dots.inputs) nix-vscode-extensions;
      };
    };
  };
}
```

Exported module entry points:

- `nixosModules.nots`
- `darwinModules.nots`
- `nixosModules.shared`
- `darwinModules.shared`

Compatibility note: existing `features.*` assignments still work via an internal alias, but `nots.features.*` is now the preferred API.

## Installation

1. Clone this repo.
2. Define your host in the flake, copying the structure from the other ones.
3. Using the included CLI tools, you can just hit `rebuild`.
