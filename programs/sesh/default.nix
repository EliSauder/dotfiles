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

        home.file = {
            ".config/sesh/sesh.toml".source = (pkgs.formats.toml {}).generate "config" {
                session = [
                    {
                        name = "default";
                        path = "~";
                        disable_startup_command = true;
                    }
                ];
            };
        };
    };
}
