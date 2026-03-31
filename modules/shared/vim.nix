{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.nots.features.vim;
  dotUsername = config.nots.username;
  hasHomeManager = options ? home-manager;
  notsLib = import ../../lib/nots.nix { inherit lib; };
in
{
  options.nots.features.vim.enable = lib.mkEnableOption "Enable custom Vim configuration.";

  config = lib.mkIf cfg.enable (
    notsLib.mkProgramConfig {
      inherit hasHomeManager dotUsername;
      program = "vim";
      attrs = {
        enable = true;

        plugins = with pkgs.vimPlugins; [
          catppuccin-vim
          vim-commentary
        ];

        settings = {
          number = true;
          relativenumber = true;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          ignorecase = true;
          smartcase = true;
          mouse = "a";
          copyindent = true;
          background = "dark";
        };

        extraConfig = ''
          " UI
          set nocompatible
          set title
          set encoding=utf-8
          set showcmd
          set cursorline
          set textwidth=80
          set laststatus=2
          set wildignorecase
          set nowrap
          set ttyfast
          set termguicolors

          " Searching
          set hlsearch
          set incsearch
          set gdefault

          " Indenting
          set smartindent
          set smarttab

          " Misc
          set scrolloff=4
          set backspace=indent,eol,start
          set diffopt=iwhite
          set tabpagemax=100
          set whichwrap=bs<>[]
          set hidden
          set history=1000

          " Leader key
          let mapleader = " "

          " Enable syntax + filetypes
          syntax enable
          filetype plugin indent on

          " Netrw
          let g:netrw_banner = 0

          " Theme
          colorscheme catppuccin_mocha
        '';
      };
    }
  );
}
