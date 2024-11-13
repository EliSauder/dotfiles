{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-andante-script-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-andante-script-otf";

	        src = pkgs.fetchzip {
		    url = "https://media.fontsgeek.com/download/zip/s/h/shelley-andante-script_kN7rf.zip";
		    sha256 = "sha256-KAieZzSAlD/2/YAlvzAZWMghjzdib9/1Z60Lmsu8rAg=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/opentype/
		    install -Dm644 "$PWD/"*/*.otf -t "$out/share/fonts/opentype"
		'';

		meta = with lib; {
		    description = "Shelley Andante Script";
		    homepage = "https://fontsgeek.com/";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
