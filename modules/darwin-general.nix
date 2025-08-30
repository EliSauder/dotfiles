{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.module.darwin-general;
in
{
  imports = [
    ./programs
    ./ui
  ];

  options.module = {
    darwin-general.enable = lib.mkEnableOption "Enable development module";
  };

  config = lib.mkIf cfg.enable {
    prog.inkscape.enable = true;
    prog.libreoffice.enable = true;
    prog.obs.enable = true;

    xdg = {
      enable = true;
      autostart.enable = true;
    };
  };
}
