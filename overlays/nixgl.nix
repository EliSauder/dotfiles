{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.nixgl.overlay
  ];
}
