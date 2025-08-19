{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.remmina;
in
{
  options.prog = {
    remmina.enable = lib.mkEnableOption "Enable remmina";
  };

  config = lib.mkIf cfg.enable {
    services.remmina = {
      enable = true;
      systemdService.enable = true;
      addRdpMimeTypeAssoc = true;
    };
  };
}
