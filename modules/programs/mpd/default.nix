{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.prog.mpd;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options.prog = {
    mpd.enable = lib.mkEnableOption "Enable mpd";
    mpd.package = lib.mkPackageOption pkgs "mpd" { example = "mpd"; };
    mpd.enableDiscordRpc = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      package = cfg.package;
    };

    services.mpd-discord-rpc = lib.mkIf (!isDarwin) {
      enable = cfg.enableDiscordRpc;
    };
  };

}
