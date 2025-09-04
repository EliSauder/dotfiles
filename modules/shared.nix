{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.shared;
in
{
  imports = [
    ./programs
    ./ui
    ./sops.nix
  ];

  options.module = {
    shared.enable = lib.mkEnableOption "Enable development module";
    shared.enableOnePasswordIntegrations = lib.mkOption {
      default = false;
    };
    shared.commandPrefix = lib.mkOption {
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    home.username = "esauder";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "24.05"; # Please read the comment before changing.

    programs.fish.functions.homeupdate = "cd ${config.home.homeDirectory}/.dotfiles && nix flake update";

    prog.inkscape.enable = true;
    prog.libreoffice.enable = true;

    prog.firefox = {
      enable = true;
      setdefault = true;
    };

    prog.reaper.enable = true;
    prog.remmina.enable = true;

    prog.onepassword = {
      enable = true;
      gitIntegration = cfg.enableOnePasswordIntegrations;
      sshIntegration = cfg.enableOnePasswordIntegrations;
    };

    prog.obsidian.enable = true;

    prog.rmpc.enable = true;
    prog.ncmpcpp.enable = true;
    prog.vimpc.enable = true;
    prog.mpc.enable = true;
    prog.mopidy = {
      enable = true;
      enableDiscordRpc = true;
      commandPrefix = cfg.commandPrefix;
    };

    home.packages = [
      pkgs.freerdp
    ];

    programs.home-manager.enable = true;

  };

}
