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
    dolphin.package = lib.mkPackageOption pkgs.kdePackages "dolphin" { example = "dolphin"; };
    dolphin.default = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    #xdg.desktopEntries.dolphin = {
    #  name = "Dolphin";
    #  exec = "${cfg.package}/bin/dolphin";
    #};
    xdg.mimeApps = lib.mkIf cfg.default {
      defaultApplications = {
        "inode/directory" = [ "${cfg.package}/share/applications/dolphin.desktop" ];
        "application/x-gnome-saved-search" = [
          "${cfg.package}/share/applications/dolphin.desktop"
        ];
      };
    };
    home.packages = [
      cfg.package
      pkgs.kdePackages.dolphin-plugins
      pkgs.kdePackages.kdesu
      pkgs.kdePackages.kservice
      pkgs.kdePackages.kio
      pkgs.kdePackages.kio-fuse
      pkgs.kdePackages.kio-extras
      pkgs.kdePackages.plasma-workspace
    ];
  };

}
