{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nots.features.vscode;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
  notsLib = import ../../lib/nots.nix { inherit lib; };
in
{
  options.nots.features.vscode.enable = lib.mkEnableOption "Enable custom VSCode configuration.";

  config = lib.mkIf cfg.enable (
    notsLib.mkProgramConfig {
      inherit hasHomeManager dotUsername;
      program = "vscode";
      attrs = {
        enable = true;
        package = pkgs.vscodium;

        profiles.default = {
          extensions =
            let
              marketplaceExt = with pkgs.vscode-marketplace; [
                catppuccin.catppuccin-vsc
                jnoortheen.nix-ide
                eamodio.gitlens
                usernamehw.errorlens
                golang.go
                bradlc.vscode-tailwindcss
                charliermarsh.ruff
                esbenp.prettier-vscode
                dbaeumer.vscode-eslint
                # james-yu.latex-workshop
                llvm-vs-code-extensions.vscode-clangd
              ];
              openVsxExt = with pkgs.open-vsx; [
                jeanp413.open-remote-ssh
                ms-toolsai.jupyter # bugged out version; downgrade?
              ];
            in
            marketplaceExt ++ openVsxExt;

          userSettings = {
            # ui pref
            "workbench.colorTheme" = "Catppuccin Mocha";
            # "workbench.iconTheme" = "vscode-icons";
            "workbench.sideBar.location" = "right";
            # "window.menuBarVisibility" = "classic";
            "breadcrumbs.enabled" = false;
            "editor.overviewRulerBorder" = false;
            "workbench.layoutControl.enabled" = false;
            "explorer.autoReveal" = false;
            "editor.minimap.enabled" = false;
            "workbench.tree.indent" = 12;
            "workbench.tree.renderIndentGuides" = "none";
            "workbench.editor.tabActionCloseVisibility" = false;
            "editor.padding.bottom" = 14;
            "editor.padding.top" = 14;
            "editor.scrollbar.horizontal" = "hidden";
            "editor.matchBrackets" = "never";
            "editor.guides.highlightActiveBracketPair" = false;
            "editor.smoothScrolling" = true;
            "explorer.compactFolders" = false;
            "zenMode.fullScreen" = false;
            "zenMode.centerLayout" = true;
            "zenMode.showTabs" = false;

            # editor prefs
            "extensions.autoCheckUpdates" = false;
            "extensions.autoUpdate" = false;
            "update.mode" = "none";
            "workbench.editorAssociations" = {
              "*.pdf" = "latex-workshop-pdf-hook";
            };

            # ssh
            "remote.SSH.showLoginTerminal" = true;
            "remote.SSH.useLocalServer" = false;

            # font
            "editor.fontFamily" = "JetBrainsMono Nerd Font";
            "editor.fontLigatures" = true;
            "editor.fontSize" = 14;

            # fmt/linting
            "editor.formatOnSave" = true;
            "files.associations" = {
              "*.css" = "tailwindcss";
            };

            # intellisense
            "editor.quickSuggestions" = {
              "other" = true;
              "comments" = false;
              "strings" = true;
            };
            "clangd.arguments" = [
              "--compile-commands-dir=build"
            ];

            # shell
            "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
            "terminal.integrated.defaultProfile.linux" = "zsh";
            "terminal.integrated.profiles.linux.zsh.path" = "/etc/profiles/per-user/ooj/bin/zsh";

            # gitlens
            "gitlens.currentLine.enabled" = true;
            "gitlens.hovers.enabled" = true;

            # language specific
            "nix" = {
              "serverPath" = "nixd";
              "enableLanguageServer" = true;
              "serverSettings.nixd.formatting.command" = "nixfmt";
            };
            "tailwindCSS.includeLanguages" = {
              "html" = "html";
              "javascript" = "javascript";
              "css" = "css";
            };
            "[json]" = {
              "editor.defaultFormatter" = "vscode.json-language-features";
            };
            "[javascript]" = {
              "editor.defaultFormatter" = "vscode.typescript-language-features";
            };
            "[typescript]" = {
              "editor.defaultFormatter" = "vscode.typescript-language-features";
            };
            "[typescriptreact]" = {
              "editor.defaultFormatter" = "vscode.typescript-language-features";
            };
            "svelte.enable-ts-plugin" = true;
          };
        };
      };
    }
  );
}
