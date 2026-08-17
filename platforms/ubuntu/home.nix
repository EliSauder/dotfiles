# getent passwd <username> may need to be called
# or maybe installing nscd
{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
let
  nixGLStart = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ";
  username = specialArgs.username;
  uses = specialArgs.uses;
in
{
  nixpkgs.config.allowUnfreePredicate =
    let
      whitelist = map lib.getName [
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

  programs.fish.functions.homebuild = "home-manager switch --flake \"${config.home.homeDirectory}/.dotfiles#${username}-ubuntu\" --cores 6 --impure $argv";

  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    GST_PLUGIN_PATH = "$HOME/.nix-profile/lib/gstreamer-1.0/";
    #LD_LIBRARY_PATH = "/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu";
  };

  home.sessionVariables = {
    GST_PLUGIN_PATH = "$HOME/.nix-profile/lib/gstreamer-1.0/";
  };

  platform.linux = {
    enable = true;
    useNvidia = true;
    commandPrefix = nixGLStart;
    username = username;
  };

  modules = {
    enable = true;
    uses = uses;
    username = username;
    commandPrefix = nixGLStart;
  };

  #module.shared = {
  #  enable = true;
  #  enableOnePasswordIntegrations = false;
  #  commandPrefix = nixGLStart;
  #  username = username;
  #};

  #module.linux-general = {
  #  enable = true;
  #  useNvidia = true;
  #  commandPrefix = nixGLStart;
  #  username = username;
  #};

  #module.development = {
  #  enable = true;
  #};

  #module.play = {
  #  enable = false;
  #};

  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.nixgl.auto.nixGLDefault
  ];
}
