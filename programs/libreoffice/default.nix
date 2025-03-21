{ config, lib, pkgs, ... }: 
let 
    cfg = config.prog.libreoffice;
in {
    config.prog = {
        libreoffice.enable = lib.mkEnableOption "Enable libreoffice";
    };

    options = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.libreoffice-qt6
            pkgs.hunspell
            pkgs.hunspellDicts.en_US
        ];
    };

}
