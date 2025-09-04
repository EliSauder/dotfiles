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
  };

  config = lib.mkIf cfg.enable {
    programs.rmpc = {
      enable = true;
      config =
        builtins.replaceStrings
          [ "address: \"127.0.0.1:6600\"" ]
          [ "${config.services.mpd.network.listenAddress}:${config.services.mpd.network.port}" ]
          (builtins.readFile ./config.ron);
    };
  };
}
