{
    description = "Home manager flake for esauder system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	systems.url = "github:nix-systems/default";
    };

    outputs = {self, nixpkgs, home-manager, systems }:
    let
       eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
	packages = eachSystem (system: {
 	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    homeConfigurations."esauder" = home-manager.lib.homeManagerConfiguration {
		pkgs = nixpkgs.legacyPackages.${system};
		modules = [ ./home.nix ];
	    };
	});
    };
}
