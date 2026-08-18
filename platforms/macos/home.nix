{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = [ "/Applications" ];
  };
  username = specialArgs.username;
  uses = specialArgs.uses;
in
{
  nixpkgs.config.allowUnfreePredicate =
    let
      whitelist = map lib.getName [
        pkgs.firefox
        pkgs.firefox-bin
        pkgs.firefox-bin-unwrapped
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
        pkgs.mqtt-explorer
        pkgs.terraform
        pkgs.obsidian
      ];
    in
    pkg: builtins.elem (lib.getName pkg) whitelist;

  imports = [
    ../../modules
  ];

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#${username}-macos --cores 6 $argv";

  platform.darwin = {
    enable = true;
    username = username;
  };

  modules = {
    enable = true;
    uses = uses;
    username = username;
  };

  #module.shared = {
  #  enable = true;
  #  enableOnePasswordIntegrations = true;
  #  username = username;
  #};

  #module.development = {
  #  enable = true;
  #};

  #module.play = {
  #  enable = true;
  #};

  home.activation = lib.mkIf pkgs.stdenv.isDarwin {
    addApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      apps_source="${apps}/Applications"
      moniker="Nix Trampolines"
      app_target_base="$HOME/Applications"
      app_target="$app_target_base/$moniker"
      rm -f "$app_target/*"
      mkdir -p "$app_target"
      ${pkgs.rsync}/bin/rsync --archive --checksum --chmod=-w --copy-unsafe-links --delete "$apps_source/" "$app_target"
    '';
  };
}
