{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    party-let-plain-ttf = pkgs.stdenv.mkDerivation {
	        pname = "party-let-plain-ttf";
		version = "1.0";
	        src = pkgs.fetchurl {
		    url = "https://www.fontsplace.com/free/fonts/p/party_let_plain1.0.ttf";
		    hash = lib.fakeSha256;
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/truetype/
		    install -Dm644 *.ttf -t "$out/share/fonts/truetype"
		'';

		meta = with lib; {
		    description = "Party LET Plain";
		    homepage = "https://www.fontsplace.com";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
