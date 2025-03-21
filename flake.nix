{
    description = "Home manager flake for esauder system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.follows = "nixpkgs";

	    systems.url = "github:nix-systems/default";
        systems.follows = "nixpkgs";

	    hyprland.url = "github:hyprwm/Hyprland";
        hyprland.follows = "nixpkgs";

	    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
        rose-pine-hyprcursor.follows = "nixpkgs";

	    nix-gaming.url = "github:fufexan/nix-gaming";
	    nix-gaming.follows = "nixpkgs";

        nur.url = "github:nix-community/NUR";
        nur.follows = "nixpkgs";
    };

    outputs = inputs@{self, nixpkgs, home-manager, systems, hyprland, nur, ... }:
    let
       eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
	packages = eachSystem (system: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    homeConfigurations."esauder" = home-manager.lib.homeManagerConfiguration {
                extraSpecialArgs = {inherit inputs;};
		pkgs = nixpkgs.legacyPackages.${system};
		modules = [ 
		    ./home.nix 
		    (import ./overlays)
		];
	    };
	});
    };
}
