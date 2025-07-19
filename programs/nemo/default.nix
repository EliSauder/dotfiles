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
    nemo.package = lib.mkOption
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries.nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "${pkgs.nemo-with-extensions}/share/applications/nemo.desktop" ];
        "application/x-gnome-saved-search" = [
          "${pkgs.nemo-with-extensions}/share/applications/nemo.desktop"
        ];
      };
    };
    home.packages = [
      pkgs.nemo-with-extensions
      pkgs.nemo-python
      pkgs.nemo-emblems
    ];
  };

}
