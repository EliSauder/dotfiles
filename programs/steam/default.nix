{ config, lib, pkgs, ... }:
let
    cfg = config.prog.steam;
in {
    config.prog = {
        steam.enable = lib.mkEnableOption "Enable steam";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            "steam"
            "steam-original"
            "steam-unwrapped"
            "steam-run"
        ];
    };
}
