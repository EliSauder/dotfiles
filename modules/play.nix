{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.play;
in
{
  options.module = {
    play.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
        "discord"
        "reaper"
      ];
    prog.discord.enable = false;
    prog.steam.enable = true;
    home.packages = [
      pkgs.prismlauncher
    ];
  };
}
