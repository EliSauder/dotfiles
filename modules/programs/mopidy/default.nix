{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    generators
    mkIf
    mkOption
    types
    ;

  cfg = config.prog.mopidy;

  toMopidyConf = generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString =
        v:
        if lib.isList v then
          "\n " + lib.concatStringsSep "\n " v
        else
          generators.mkValueStringDefault { } v;
    } " = ";
  };

  mopidyEnv = pkgs.buildEnv {
    name = "mopidy-with-extensions-${pkgs.mopidy.version}";
    paths = lib.closePropagation extensionPackages;
    buildInputs = [
      #pkgs.gst_all_1.gst-plugins-rs
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gstreamer

      pkgs.gst-plugins-spotify
      #pkgs.gst-plugin-spotify
    ];
    pathsToLink = [ "/${pkgs.mopidyPackages.python.sitePackages}" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    ignoreCollisions = true;
    postBuild = ''
      makeWrapper ${pkgs.mopidy}/bin/mopidy $out/bin/mopidy \
        --prefix PYTHONPATH : $out/${pkgs.mopidyPackages.python.sitePackages}
    '';
  };

  mopidyConfFormat =
    { }:
    {
      type =
        with types;
        let
          valueType =
            nullOr (oneOf [
              bool
              float
              int
              str
              (listOf valueType)
            ])
            // {
              description = "Mopidy config value";
            };
        in
        attrsOf (attrsOf valueType);
      generate = name: value: pkgs.writeText name (toMopidyConf value);
    };

  settingsFormat = mopidyConfFormat { };
  extraConfigFiles = [ ];

  configFilePaths = lib.concatStringsSep ":" (
    [ "${config.xdg.configHome}/mopidy/mopidy.conf" ] ++ extraConfigFiles
  );

  extensionPackages = [
    (pkgs.mopidy-spotify.overrideAttrs (
      final: prev: {
        buildInputs = [
          #pkgs.gst_all_1.gst-plugins-rs
          #pkgs.gst-plugin-spotify
          pkgs.gst-plugins-spotify
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gstreamer
        ];
      }
    ))
    pkgs.mopidy-mpd
    pkgs.mopidy-mpris
    pkgs.mopidy-local
    pkgs.mopidy-notify
    pkgs.mopidy-podcast
  ];

  settings = {
    core = {
      cache_dir = "$XDG_CACHE_DIR/mopidy";
      config_dir = "$XDG_CONFIG_DIR/mopidy";
      data_dir = "$XDG_DATA_DIR/mopidy";
    };
    audio = {
      output = "autoaudiosink";
    };
    logging = {
      verbosity = 2;
    };
    spotify = {
      enabled = true;
      allow_cache = true;
      allow_network = true;
      search_album_count = 20;
      search_artist_count = 10;
      search_track_count = 50;
      timeout = 10;
    };
    mpd = {
      enabled = true;
      hostname = cfg.network.listenAddress;
      port = cfg.network.port;
      connection_timeout = 60;
    };
  };
in
{
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
    mopidy.commandPrefix = lib.mkOption {
      default = "";
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

    home.packages = [
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-plugins-good
      #pkgs.gst_all_1.gst-plugins-rs
      pkgs.gst_all_1.gst-devtools
      #pkgs.gst_all_1.gst-rtsp-server
      #pkgs.gst_all_1.gst-libav
      #pkgs.gst_all_1.gst-editing-services
      pkgs.gst-plugins-spotify
      #pkgs.gst-plugin-spotify
    ];

    xdg.configFile."mopidy/mopidy.conf".source =
      settingsFormat.generate "mopidy-${config.home.username}" settings;

    systemd.user.services.mopidy = {
      Unit = {
        Description = "mopidy music player daemon";
        Documentation = [ "https://mopidy.com/" ];
        After = [
          "network.target"
          "sound.target"
          "sops-nix.service"
        ];
        X-Restart-Triggers = lib.mkIf (settings != { }) [
          "${config.xdg.configFile."mopidy/mopidy.conf".source}"
        ];
      };
      Install.WantedBy = [ "default.target" ];
      Service = {
        Environment = [
          "GST_PLUGIN_SYSTEM_PATH_1_0=${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst-plugins-spotify}/lib/gstreamer-1.0"
          "GST_PLUGIN_SYSTEM_PATH=${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst-plugins-spotify}/lib/gstreamer-1.0"
        ];
        Restart = "on-failure";
        ExecStart = lib.mkForce "${pkgs.writeShellScriptBin "startmopidy.sh" ''
          #!/bin/bash

          export GST_PLUGIN_SYSTEM_PATH_1_0="${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst-plugins-spotify}/lib/gstreamer-1.0"
          export GST_PLUGIN_SYSTEM_PATH="${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst-plugins-spotify}/lib/gstreamer-1.0"

          gst-inspect-1.0 spotifyaudiosrc | grep Version | awk '{print $2}'

          ${cfg.commandPrefix}${mopidyEnv}/bin/mopidy --config ${configFilePaths} --option spotify/client_id="$(cat "${
            config.sops.secrets."apps/spotify/client_id".path
          }")" --option spotify/client_secret="$(cat "${
            config.sops.secrets."apps/spotify/client_secret".path
          }")"


        ''}/bin/startmopidy.sh";
      };
    };

    systemd.user.services.mopidy-scan = {
      Unit = {
        Description = "mopidy local files scanner";
        Documentation = [ "https://mopidy.com/" ];
        After = [
          "network.target"
          "sound.target"
        ];
      };
      Service = {
        ExecStart = "${cfg.commandPrefix}${mopidyEnv}/bin/mopidy --config ${configFilePaths} local scan";
        Type = "oneshot";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
