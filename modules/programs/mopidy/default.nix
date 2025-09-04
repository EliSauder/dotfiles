{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.mopidy;

  mopidyEnv = pkgs.buildEnv {
    name = "mopidy-with-extensions-${pkgs.mopidy.version}";
    paths = lib.closePropagation config.services.mopidy.extensionPackages;
    pathsToLink = [ "/${pkgs.mopidyPackages.python.sitePackages}" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    ignoreCollisions = true;
    postBuild = ''
      makeWrapper ${pkgs.mopidy}/bin/mopidy $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${pkgs.mopidyPackages.python.sitePackages}
    '';
  };
in
{
  imports = [
    ../mpd
  ];

  options.prog = {
    mopidy.enable = lib.mkEnableOption "Enable mopidy";
    mopidy.enableDiscordRpc = lib.mkOption {
      default = false;
    };
    mopidy.network.listenAddress = lib.mkOption {
      default = "127.0.0.1";
    };
    mopidy.network.port = lib.mkOption {
      default = 6600;
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.prog.mpd.enable;
        message = "mopidy conflicts with mpd";
      }
      {
        assertion = !config.services.mpd.enable;
        message = "mopidy conflicts with mpd";
      }
    ];

    services.mpd-discord-rpc = {
      enable = cfg.enableDiscordRpc;
    };

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
        mpd = {
          enabled = true;
          hostname = cfg.network.listenAddress;
          port = cfg.network.port;
        };
        spotify = {
          enabled = true;
        };
      };
    };

    systemd.user.services.mopidy = {
      Unit.After = [
        "sops-nix.service"
      ];
      Service.ExecStart = lib.mkForce "${pkgs.writeShellScriptBin "startmopidy.sh" ''
        #!/bin/bash

        ${mopidyEnv}/bin/mopidy --config ${
          lib.concatStringsSep ":" (
            [ "${config.xdg.configHome}/mopidy/mopidy.conf" ] ++ config.services.mopidy.extraConfigFiles
          )
        } --option spotify/client_id="$(cat "${
          config.sops.secrets."apps/spotify/client_id".path
        }")" --option spotify/client_secret="$(cat "${
          config.sops.secrets."apps/spotify/client_secret".path
        }")"


      ''}/bin/startmopidy.sh";
    };
  };
}
