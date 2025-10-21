{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.grc;
in
{
  options.prog = {
    grc.enable = lib.mkEnableOption "Enable git";
    grc.package = lib.mkPackageOption pkgs "grc" { example = "grc"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.networkmanager
    ];

    xdg.configFile."nmtui/palette".text = ''
      root=lavender,crust
      border=sapphire,base
      window=overlay0,base
      title=rosewater,crust
      button=surface2,lavender
      button_active=crust,maroon
    '';
  };
}
