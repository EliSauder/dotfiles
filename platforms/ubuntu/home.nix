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

  systemd.user.sessionVariables = {
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = false;
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
