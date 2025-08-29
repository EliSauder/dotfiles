{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.ui.hypridle;
in
{
  options.ui = {
    wallpaper.enable = lib.mkEnableOption "Enable hypridle";
  };

  config = lib.mkIf cfg.enable {
    services.swww = {
      enable = true;
    };

    programs.mpvpaper = {
      enable = true;
      pauseList = ''
        "steam"
      '';
    };

    home.packages = [
      pkgs.waypaper
    ];
  };
}
