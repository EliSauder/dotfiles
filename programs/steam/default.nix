{ config, lib, pkgs, ... }:
let
    cfg = config.prog.steam;
in {
    options = {
        prog.steam.enable = lib.mkEnableOption "Enable steam";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            "steam"
            "steam-original"
            "steam-unwrapped"
            "steam-run"
        ];
    };
}
