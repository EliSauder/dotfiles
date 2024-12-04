{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-allegro-bt-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-allegro-bt-otf";

	        src = pkgs.fetchurl {
		    url = "https://www.cufonfonts.com/get/font/download/5144780b954ad3c578b73876eadc703f";
		    sha256 = "sha256-3c6TOzo3JJ8LyQYPIe00bmr3MWr25f6CUuB23Q8QODA=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		nativeBuildInputs = [
		    pkgs.unzip
		];

		unpackPhase = ''
		    ls -la
		    unzip shelley-allegro-bt-otf -d out
		'';

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
