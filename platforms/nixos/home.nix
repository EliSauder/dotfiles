{
  config,
  lib,
  specialArgs,
  ...
}:
let
  username = specialArgs.username;
in
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "flagfox"
      "languagetool"
      "cmp-vimwiki-tags"
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

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#${username}-nixos $argv";

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = false;
    username = username;
  };

  module.linux-general = {
    enable = true;
    useNvidia = false;
    username = username;
  };

  module.development = {
    enable = true;
  };

  module.play = {
    enable = true;
  };

  targets.genericLinux.enable = false;
}
