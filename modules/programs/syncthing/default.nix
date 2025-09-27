{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.prog.syncthing;
in
{
  options.prog = {
    syncthing.enable = lib.mkEnableOption "Enable syncthing";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
