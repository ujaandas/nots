# ❄️ Everything Everywhere All At Once Dots

A modular, "semi-dendritic" Nix configuration designed for simplicity, extensibility, and ease-of-use that gives me everything, everywhere, all at once.

## Usage

Instead of hunting through nested folders to enable a tool, everything is controlled via a central `features` block. It’s designed to be write-once, toggle-anywhere.

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
  features = {
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

## Installation

1. Clone this repo.
2. Define your host in the flake, copying the structure from the other ones.
3. Using the included CLI tools, you can just hit `rebuild`.
