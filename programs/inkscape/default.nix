{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.inkscape;
in {
    options.prog = {
        inkscape.enable = lib.mkEnableOption "Enable inkscape";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.inkscape-with-extensions
            pkgs.inkscape-with-extensions.inkcut
            pkgs.inkscape-with-extensions.hexmap
            pkgs.inkscape-with-extensions.textext
            pkgs.inkscape-with-extensions.silhouette
            pkgs.inkscape-with-extensions.applytransforms
        ];
    };
}
