{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.personal;
in
{
  imports = [
    ../programs
    ../ui
  ];

  options.module = {
    personal.enable = lib.mkEnableOption "Enable personal module";
    personal.commandPrefix = lib.mkOption {
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    prog.reaper.enable = true;
    prog.discord.enable = true;
    prog.syncthing.enable = true;
    home.packages = [
      pkgs.prismlauncher
      pkgs.qbittorrent
    ];

    prog.mopidy = {
      enableDiscordRpc = true;
    };

    prog.obsidian.enable = true;

    prog.rmpc.enable = true;
    prog.ncmpcpp.enable = true;
    prog.vimpc.enable = true;
    prog.mpc.enable = true;
    prog.mopidy = {
      enable = true;
      commandPrefix = cfg.commandPrefix;
    };
  };
}
