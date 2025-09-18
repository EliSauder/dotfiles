{
  description = "Home manager flake for esauder system";
  nixConfig = {
    extra-substituters = [
      "https://ghostty.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems = {
      url = "github:nix-systems/default";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ziggy = {
      url = "github:kristoff-it/ziggy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
    };
  };

  outputs =
    inputs@{
      self,
      nixvim,
      nixgl,
      gen-luarc,
      ziggy,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      systems,
      hyprland,
      nur,
      sops-nix,
      catppuccin,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (system: {
        home-manager.useGlobalPkgs = false;
        home-manager.useUserPackages = true;
        homeConfigurations."esauder-macos" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs system;
            distro = "darwin";
            uses = [
              "personal"
            ];
            pkgs-stable = import inputs.nixpkgs-stable {
              system = system;
            };
          };
          pkgs = import nixpkgs {
            system = system;
          };
          modules = [
            ./platforms/macos/home.nix
            (import ./overlays)
            inputs.nixvim.homeModules.nixvim
            catppuccin.homeModules.catppuccin
            sops-nix.homeManagerModules.sops
          ];
        };
        homeConfigurations."esauder-nixos" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs system;
            distro = "nixos";
            uses = [
              "personal"
            ];
            pkgs-stable = import inputs.nixpkgs-stable {
              system = system;
            };
          };
          pkgs = import nixpkgs {
            system = system;
          };
          modules = [
            ./platforms/nixos/home.nix
            (import ./overlays)
            inputs.nixvim.homeModules.nixvim
            sops-nix.homeManagerModules.sops
            catppuccin.homeModules.catppuccin
          ];
        };
        homeConfigurations."esauder-ubuntu" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs system;
            distro = "ubuntu";
            uses = [
              "work"
            ];
            pkgs-stable = import inputs.nixpkgs-stable {
              system = system;
              overlays = [ nixgl.overlay ];
            };
          };
          pkgs = import nixpkgs {
            system = system;
            overlays = [ nixgl.overlay ];
          };
          modules = [
            ./platforms/ubuntu/home.nix
            (import ./overlays)
            inputs.nixvim.homeModules.nixvim
            sops-nix.homeManagerModules.sops
            catppuccin.homeModules.catppuccin
          ];
        };
      });
    };
}
