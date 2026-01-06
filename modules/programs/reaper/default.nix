{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.reaper;
in
{
  options.prog = {
    reaper.enable = lib.mkEnableOption "Enable reaper";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.reaper
      pkgs.winetricks
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.wineWowPackages.yabridge
    ];
  };
}
