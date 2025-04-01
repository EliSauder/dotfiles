{ config, pkgs, lib, ... }:
let
    cfg = config.prog.sesh;
in {
    options.prog = {
        sesh.enable = lib.mkEnableOption "Enable Sesh";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.sesh
        ];
    };
}
