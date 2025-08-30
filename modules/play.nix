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
  imports = [
    ./programs
    ./ui
  ];

  options.module = {
    play.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    prog.discord.enable = true;
    home.packages = [
      pkgs.prismlauncher
    ];
  };
}
