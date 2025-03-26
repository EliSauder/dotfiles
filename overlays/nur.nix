{ config, pkgs, lib, nur, ...}: {
    nixpkgs.overlays = [
        nur.overlay
    ];
}
