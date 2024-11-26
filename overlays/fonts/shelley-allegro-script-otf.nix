{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-allegro-script-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-allegro-script-otf";

	        src = pkgs.fetchzip {
		    url = "https://www.freefontdownload.org/download-font-otf/shelley-allegro-script-regular";
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
		    description = "Shelley Allegro Script";
		    homepage = "https://www.freefontdownload.org";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
