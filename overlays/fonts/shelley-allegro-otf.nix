{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-allegro-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-allegro-otf";

	        src = pkgs.fetchzip {
		    url = "https://fontsgeek.com/shelley-allegro-font/download";
		    sha256 = "sha256-2Gd98nv4PVU1iTJJ1hX6dKKfC1TkxQETBSNmpXeGvJk=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/opentype/
		    install -Dm644 "$PWD/"*/*.otf -t "$out/share/fonts/opentype"
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
