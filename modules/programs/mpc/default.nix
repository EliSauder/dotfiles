{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.mpc;
  #isUbuntu = specialArgs.distro == "ubuntu";
  #nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.prog = {
    mpc.enable = lib.mkEnableOption "Enable remmina";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mpc
    ];
  };
}
