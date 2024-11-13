{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    alex-brush-ttf = pkgs.stdenv.mkDerivation {
	        name = "alex-brush-ttf";

	        src = pkgs.fetchurl {
		    url = "https://www.1001fonts.com/download/font/alex-brush.regular.ttf";
		    sha256 = "sha256-iBcv7+rqhcUj0djD7IIC76jul4zJvNdnSaoYb6ZC2R4=";
		};

		phases = [ "installPhase" ];

		installPhase = ''
		    mkdir -p $out/share/fonts/truetype/
		    install -Dm644 "$src" -t "$out/share/fonts/truetype"
		'';

		meta = with lib; {
		    description = "Alex Brush";
		    homepage = "https://www.1001fonts.com/";
		    platforms = platforms.all;
		    license = lib.licenses.ofl;
		};
	    };
	})
    ];
}
