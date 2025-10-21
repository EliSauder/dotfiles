{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.prog.nmtui;
in
{
  options.prog = {
    nmtui.enable = lib.mkEnableOption "Enable git";
    nmtui.package = lib.mkPackageOption pkgs "networkmanager" { example = "networkmanager"; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
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
