{
  config,
  lib,
  pkgs,
  inputs,
  specialArgs,
  ...
}:
let
  apps = pkgs.buildEnv {
    name = "home-manager-applications";
    paths = config.home.packages;
    pathsToLink = [ "/Applications" ];
  };
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

  home.packages = [
    pkgs.qbittorrent
  ];

  programs.fish.functions.homebuild = "home-manager switch --flake ${config.home.homeDirectory}/.dotfiles#esauder-macos $argv";

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = true;
  };

  module.darwin-general = {
    enable = true;
  };

  module.development = {
    enable = true;
  };

  module.play = {
    enable = true;
  };

  home.homeDirectory = "/Users/esauder";

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
