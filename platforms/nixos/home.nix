{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  username = specialArgs.username;
  uses = specialArgs.uses;
in
{
  nixpkgs.config.allowUnfreePredicate =
    let
      whitelist = map lib.getName [
        pkgs.firefox-bin
        pkgs.vimPlugins.cmp-vimwiki-tags
        pkgs.vimPlugins.transparent-nvim
        pkgs.vimPlugins.git-conflict-nvim
        pkgs.discord
        pkgs.nur.repos.rycee.firefox-addons.flagfox
        pkgs.nur.repos.rycee.firefox-addons.languagetool
        pkgs.reaper
        pkgs._1password-gui
        pkgs._1password-cli
        pkgs.nur.repos.rycee.firefox-addons.onepassword-password-manager
        pkgs.winbox
        pkgs.terraform
        pkgs.obsidian
      ];
    in
    pkg: builtins.elem (lib.getName pkg) whitelist;

  imports = [
    ../../modules
  ];

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#${username}-nixos --cores 6 $argv";

  platform.linux = {
    enable = true;
    useNvidia = true;
    username = username;
  };

  modules = {
    enable = true;
    uses = uses;
    username = username;
  };

  targets.genericLinux.enable = true;
}
