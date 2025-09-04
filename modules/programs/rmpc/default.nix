{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.rmpc;
  #isUbuntu = specialArgs.distro == "ubuntu";
  #nixGLStart = if isUbuntu then "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL " else "";
in
{
  options.prog = {
    rmpc.enable = lib.mkEnableOption "Enable remmina";
    rmpc.mpd.address = lib.mkOption {
      default = "127.0.0.1";
    };
    rmpc.mpd.port = lib.mkOption {
      default = 6600;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rmpc = {
      enable = true;
      config =
        builtins.replaceStrings
          [ "address: \"127.0.0.1:6600\"" ]
          [
            "address: \"${cfg.mpd.address}:${builtins.toString cfg.mpd.port}\""
          ]
          (builtins.readFile ./config.ron);
    };
  };
}
