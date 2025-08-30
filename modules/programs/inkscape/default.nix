{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.inkscape;
in
{
  options.prog = {
    inkscape.enable = lib.mkEnableOption "Enable inkscape";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      #pkgs.inkscape
      pkgs.inkscape-with-extensions
      pkgs.inkscape-extensions.inkcut
      pkgs.inkscape-extensions.hexmap
      pkgs.inkscape-extensions.textext
      pkgs.inkscape-extensions.applytransforms
    ];
  };
}
