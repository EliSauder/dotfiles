{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.teams;
  pkg = config.prog.teams.package.overrideAttrs (
    fin: old: {
      desktopEntries = [ ];
    }
  );
in
{

  options.prog.teams = {
    enable = lib.mkEnableOption "Enable teams";
    package = lib.mkPackageOption pkgs "teams-for-linux" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkg
    ];

    xdg.desktopEntries.teams = {
      name = "Microsoft Teams for Linux";
      icon = "teams-for-linux";
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      genericName = "Microsoft Teams";
      comment = pkg.meta.description;
      exec = "${pkg}/bin/${pkg.meta.mainProgram} %U --no-sandbox";
      mimeType = [ "x-scheme-handler/msteams" ];
    };
  };
}
