{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (_: _: {
      ziggy = inputs.ziggy.packages.${pkgs.stdenv.hostPlatform.system}.ziggy.overrideAttrs (oldAttrs: {
        buildPhase = (oldAttrs.buildPhase or "") + ''
          export ZIG_GLOBAL_CACHE_DIR="$PWD/zig-cache"
        '';
      });
    })
  ];
}
