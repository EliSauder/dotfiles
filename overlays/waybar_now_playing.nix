{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    waybar_now_playing = pkgs.rustPlatform.buildRustPackage rec {
	        pname = "waybar_now_playing";
		version = "1.0";
	        src = pkgs.fetchFromGitHub {
	            owner = "cybergaz";
	            repo = pname;
	            rev = "45f859f8656c01f1a3e8864636a648038f555acf";
	            sha256 = "sha256-8jiGbk13Vy5wBEtudbpv0okOv7gVTwGKtL85sDs78Lc=";
	        };

                cargoHash = "sha256-LU1eaH7XZFOvZtHJhsBptQKckXK5xc9rbiWdGvampTE=";
	    };
	})
    ];
}
