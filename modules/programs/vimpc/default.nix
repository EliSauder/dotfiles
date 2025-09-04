{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.vimpc;
  #isUbuntu = specialArgs.distro == "ubuntu";
  #nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.prog = {
    vimpc.enable = lib.mkEnableOption "Enable remmina";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vimpc
    ];
  };
}
