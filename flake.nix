{
    description = "Home manager flake for esauder system";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = {self, nixpktd, home-manager, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system: 
    let 
        pkgs = import nixpkgs { 
            inherit system; 
        };
        homeManager = pkgs.home-manager;
        defaultPackages = home-manager.defaultPackage.system;
        homeDir = if pkgs.stdenv.isLinux 
            then "/home/esauder" 
            else "/Users/esauder";
    in {
        defaultPackage.system = defaultPackages;

        homeConfigurations = {
            "esauder" = homeManager.lib.homeManagerConfiguration {
                pkgs = pkgs;
                modules = [ ./home.nix ];
                homeDirectory = homeDir;
                username = "esauder";
            };
        };
    });
}
