{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.nemo;
in
{
  options.prog = {
    nemo.enable = lib.mkEnableOption "Enable libreoffice";
    nemo.package = lib.mkPackageOption pkgs "nemo-with-extensions" { example = "nemo"; };
    nemo.default = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.nemo = {
      name = "Nemo";
      exec = "${cfg.package}/bin/nemo";
    };
    xdg.mimeApps = lib.mkIf cfg.default {
      defaultApplications = {
        "inode/directory" = [ "${cfg.package}/share/applications/nemo.desktop" ];
        "application/x-gnome-saved-search" = [
          "${cfg.package}/share/applications/nemo.desktop"
        ];
      };
    };
    home.packages = [
      cfg.package
      pkgs.nemo-python
      pkgs.nemo-emblems
    ];
  };

}
