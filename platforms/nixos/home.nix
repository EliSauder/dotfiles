{
  config,
  lib,
  pkgs,
  inputs,
  specialArgs,
  ...
}:
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

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#esauder-nixos $argv";

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = false;
  };

  module.linux-general = {
    enable = true;
    useNvidia = false;
  };

  module.development = {
    enable = true;
  };

  module.play = {
    enable = true;
  };

  targets.genericLinux.enable = false;
}
