{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  specialArgs,
  ...
}:
{
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
