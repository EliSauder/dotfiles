{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-andante-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-andante-otf";

	        src = pkgs.fetchzip {
		    url = "https://media.fontsgeek.com/download/zip/s/h/shelley-andante_RzoD7.zip";
		    sha256 = "sha256-pZpkmts9hXbLNQCRvUnDGYXLusfDVcrdM50da0++feg=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/opentype/
		    install -Dm644 "$PWD/"*/*.otf -t "$out/share/fonts/opentype"
		'';

		meta = with lib; {
		    description = "Shelley Andante";
		    homepage = "https://fontsgeek.com/";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
