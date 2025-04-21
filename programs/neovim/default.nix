{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.neovim;
in
{
  options.prog = {
    neovim.enable = lib.mkEnableOption "Enable neovim";
  };

  imports = [
    ./keybinds
    ./plugins
    ./colorscheme.nix
    ./options.nix
    ./ftsetup
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libclang
      pkgs.codespell
      pkgs.commitlint-rs
      pkgs.bash-language-server
      pkgs.cmake-language-server
      pkgs.omnisharp-roslyn
      pkgs.vscode-langservers-extracted
      pkgs.lua-language-server
      pkgs.lemminx
      pkgs.yaml-language-server
      pkgs.rust-analyzer
      #pkgs.rustfmt
      pkgs.taplo
      pkgs.gopls
      pkgs.zls
      pkgs.ziggy
      pkgs.superhtml
      pkgs.ripgrep
      pkgs.fd
      pkgs.nixfmt-rfc-style
      pkgs.gnused
      pkgs.alejandra
    ];

    programs.nixvim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
      vimdiffAlias = true;

      nixpkgs.useGlobalPackages = true;
    };

    #home.sessionVariables = {
    #  "EDITOR" = "${config.programs.nixvim.package}/bin/nvim";
    #};
  };
}
