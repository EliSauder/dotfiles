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
  imports = [
    ../mpd
  ];

  options.prog = {
    mopidy.enable = lib.mkEnableOption "Enable mopidy";
    mopidy.package = lib.mkPackageOption pkgs "mopidy" { example = "mopidy"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
    ];

    prog.mpd.enable = true;

    services.mopidy = {
      enable = true;
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

    systemd.user.services.mopidy = {
      Unit.After = [
        "sops-nix.service"
      ];
      Service.ExecStart = "${pkgs.writeShellScriptBin "startmopidy.sh" ''
        #!/bin/bash

        mopidy --config ${
          lib.concatStringsSep ":" (
            [ "${config.xdg.configHome}/mopidy/mopidy.conf" ] ++ config.services.mopidy.extraConfigFiles
          )
        } --option spotify/client_id="$(cat "${
          config.sops.secrets."app/spotify/client_id".path
        }")" --option spotify/client_secret="$(cat "${
          config.sops.secrets."app/spotify/client_secret".path
        }")"


      ''}/bin/startmopidy.sh";
    };
  };
}
