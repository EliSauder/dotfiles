{ config, lib, pkgs, ... }:
let
    cfg = config.prog.steam;
in {
    options = {
        prog.steam.enable = lib.mkEnableOption "Enable steam";
    };

    config = lib.mkIf cfg.enable {
        home.packages = lib.mkIf pkgs.stdenv.isLinux [
            pkgs.steam
            pkgs.steam-unwrapped
            pkgs.steam-run
        ];
    };
}
