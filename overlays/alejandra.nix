{ inputs, system, config, pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (_: _: {
      alejandra = inputs.alejandra.defaultPackage.${system};
    })
  ];
}
