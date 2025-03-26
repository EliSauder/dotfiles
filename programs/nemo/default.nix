{ config, lib, pkgs, ... }: 
let 
    cfg = config.prog.nemo;
in {
    options.prog = {
        nemo.enable = lib.mkEnableOption "Enable libreoffice";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.nemo-with-extensions
            pkgs.nemo-python
            pkgs.nemo-emblems
        ];
    };

}
