{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    ruthie-ttf = pkgs.stdenv.mkDerivation {
	        name = "ruthie-ttf";

	        src = pkgs.fetchurl {
		    url = "https://www.1001fonts.com/download/font/ruthie.regular.ttf";
		    sha256 = "sha256-fFob+82bC/b3CWhr3O+ksGMF9g/s3SkMHCeC3jFVkjI=";
		};

		phases = [ "installPhase" ];


		installPhase = ''
		    mkdir -p $out/share/fonts/truetype/
		    install -Dm644 "$src" -t "$out/share/fonts/truetype"
		'';

		meta = with lib; {
		    description = "Ruthie";
		    homepage = "https://www.1001fonts.com/";
		    platforms = platforms.all;
		    license = lib.licenses.ofl;
		};
	    };
	})
    ];
}
