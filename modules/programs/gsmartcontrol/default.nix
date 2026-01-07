{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.gsmartcontrol;
in
{
  options.prog = {
    gsmartcontrol.enable = lib.mkEnableOption "Enable gsmartcontrol";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gsmartcontrol
      pkgs.smartmontools
    ];
  };
}
