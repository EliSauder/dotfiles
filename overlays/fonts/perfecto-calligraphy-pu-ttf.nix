{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    perfecto-calligraphy-pu-ttf = pkgs.stdenv.mkDerivation {
	        name = "perfecto-calligraphy-pu-ttf";

	        src = pkgs.fetchurl {
		    url = "https://www.1001fonts.com/download/font/perfecto-calligraphy-personal-use.regular.ttf";
		    sha256 = "sha256-hZBWvPW1LAVehJHjmMvWxCLL/88kEA6bm8fzifDNmHo=";
		};

		phases = [ "installPhase" ];


		installPhase = ''
		    mkdir -p $out/share/fonts/truetype/
		    install -Dm644 "$src" -t "$out/share/fonts/truetype"
		'';

		meta = with lib; {
		    description = "Perfecto Calligraphy - Personal Use";
		    homepage = "https://www.1001fonts.com/";
		    platforms = platforms.all;
		    license = {
		        url = "https://st.1001fonts.net/license/perfecto-calligraphy-personal-use/READ%20ME.txt";
			fullName = "Perfecto Calligraphy Non-Commercial";
			free = false;
		    };
		};
	    };
	})
    ];
}
