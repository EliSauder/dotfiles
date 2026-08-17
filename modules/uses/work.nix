{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.work;
in
{
  imports = [
    ../programs
    ../ui
  ];

  options.module = {
    work.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    prog.remmina.enable = true;

    home.packages = [
      pkgs.freerdp
      pkgs.poppler-utils
      pkgs.imagemagick
    ];

    prog.teams.enable = true;
  };
}
