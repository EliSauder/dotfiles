# getent passwd <username> may need to be called
# or maybe installing nscd
{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  specialArgs,
  ...
}:
let
  nixGLStart = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ";
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "flagfox"
      "languagetool"
      "reaper"
      "1password"
      "1password-cli"
      "onepassword-password-manager"
      "winbox"
      "mqtt-explorer"
      "terraform"
      "obsidian"
    ];

  imports = [
    ../../modules
  ];

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#esauder-ubuntu --impure $argv";

  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
    GST_PLUGIN_PATH = "$HOME/.nix-profile/lib/gstreamer-1.0/";
  };

  home.sessionVariables = {
    GST_PLUGIN_PATH = "$HOME/.nix-profile/lib/gstreamer-1.0/";
  };

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = false;
    commandPrefix = nixGLStart;
  };

  module.linux-general = {
    enable = true;
    useNvidia = true;
    commandPrefix = nixGLStart;
  };

  module.development = {
    enable = true;
  };

  module.play = {
    enable = false;
  };

  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.nixgl.auto.nixGLDefault
  ];
}
