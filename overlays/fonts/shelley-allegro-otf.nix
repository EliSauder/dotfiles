{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-allegro-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-allegro-otf";

	        src = pkgs.fetchzip {
		    url = "https://media.fontsgeek.com/download/zip/s/h/shelley-allegro_zuRYK.zip";
		    sha256 = "sha256-fFob+82bC/b3CWhr3O+ksGMF9g/s3SkMHCeC3jFVkjI=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/opentype/
		    install -Dm644 "$src/*.otf" -t "$out/share/fonts/opentype"
		'';

		meta = with lib; {
		    description = "Shelley Allegro";
		    homepage = "https://fontsgeek.com/";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
