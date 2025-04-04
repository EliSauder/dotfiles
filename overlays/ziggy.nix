{ config, system, pkgs, lib, ... }: {
    nixpkgs.overlays = [
        (_: _: {
            inputs.ziggy.defaultPackage.${system};
         })
    ];
}
