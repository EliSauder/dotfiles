{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    waybar_now_playing = pkgs.stdenv.mkDerivation {
	        name = "waybar_now_playing";
		version = "1.0";
		src = fetchFromGitHub {
		    owner = "cybergaz";
		    repo = "waybar_now_playing";
		    rev = "45f859f8656c01f1a3e8864636a648038f555acf";
		    sha256 = lib.fakeSha256;
		};
		buildInputs = [
		    pkgs.playerctl
		    pkgs.cargo
		];

		buildPhase = ''
		    mkdir build-out
		    cargo build --release --target-dir build-out
		'';
		installPhase = ''
		    mkdir -p "$out/bin"
		    cp build-out/* "$out/bin"
		'';
	    };
	})
    ];
}
