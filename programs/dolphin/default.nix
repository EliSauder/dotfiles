{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.dolphin;
in
{
  options.prog = {
    dolphin.enable = lib.mkEnableOption "Enable libreoffice";
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.nemo = {
      name = "Dolphin";
      exec = "${pkgs.dolphin}/bin/dolphin";
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "${pkgs.dolphin}/share/applications/dolphin.desktop" ];
        "application/x-gnome-saved-search" = [
          "${pkgs.dolphin}/share/applications/dolphin.desktop"
        ];
      };
    };
    home.packages = [
      pkgs.kdePackages.dolphin
      pkgs.kdePackages.dolphin-plugins
    ];
  };

}
