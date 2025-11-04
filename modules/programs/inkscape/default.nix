{
  config,
  pkgs,
  pkgs-stable,
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
      pkgs-stable.inkscape-with-extensions
      pkgs-stable.inkscape-extensions.inkcut
      pkgs-stable.inkscape-extensions.hexmap
      pkgs-stable.inkscape-extensions.textext
      pkgs-stable.inkscape-extensions.applytransforms
    ];
  };
}
