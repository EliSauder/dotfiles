{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.mopidy;
in
{
  options.prog = {
    mopidy.enable = lib.mkEnableOption "Enable mopidy";
    mopidy.package = lib.mkPackageOption pkgs "mopidy" { example = "mopidy"; };
  };

  import = [
    ../mpd
  ];

  config = lib.mkIf cfg.enable {

    prog.mpd.enable = true;

    services.mopidy = {
      enable = true;
      package = cfg.package;
      extensionPackages = [
        pkgs.mopidy-spotify
        pkgs.mopidy-mpd
        pkgs.mopidy-mpris
        pkgs.mopidy-local
        pkgs.mopidy-notify
        pkgs.mopidy-podcast
      ];
      settings = {
      };
    };
  };
}
