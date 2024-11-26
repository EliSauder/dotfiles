{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-allegro-bt-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-allegro-bt-otf";

	        src = pkgs.fetchzip {
		    url = "https://www.cufonfonts.com/get/font/download/5144780b954ad3c578b73876eadc703f";
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
		    description = "Shelley Allegro BT";
		    homepage = "https://fontsgeek.com/";
		    platforms = platforms.all;
		    license = {
			fullName = "free for personal use";
			free = false;
		    };
		};
	    };
	})
    ];
}
