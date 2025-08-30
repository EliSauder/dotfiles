{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  specialArgs,
  ...
}:
let
  nixGLStart = "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ";
in
{
  imports = [
    ../../modules
  ];

  module.shared = {
    enable = true;
    enableOnePasswordIntegrations = false;
  };

  module.linux-general = {
    enable = true;
    useNvidia = true;
    commandPrefix = nixGLStart;
  };

  module.development = {
    enable = true;
  };

  module.play = {
    enable = true;
  };

  targets.genericLinux.enable = true;

  home.packages = [
    pkgs.nixgl.auto.nixGLDefault
  ];
}
