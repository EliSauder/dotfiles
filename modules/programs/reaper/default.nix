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
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      pkgs.winetricks
      pkgs.wineWow64Packages.yabridge
    ];
  };
}
