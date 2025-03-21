{ config, pkgs, lib, ... }:
let
    cfg = config.prog.reaper;
in {
    config.prog = {
        reaper.enable = lib.mkEnableOption "Enable reaper";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.reaper
        ];
    };
}
