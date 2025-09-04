{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.ncmpcpp;
  #isUbuntu = specialArgs.distro == "ubuntu";
  #nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.prog = {
    ncmpcpp.enable = lib.mkEnableOption "Enable remmina";
  };

  config = lib.mkIf cfg.enable {
    programs.ncmpcpp = {
      enable = true;
      mpdMusicDir = config.services.mpd.musicDirectory;
    };
  };
}
