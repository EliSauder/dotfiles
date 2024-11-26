{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	    shelley-volante-otf = pkgs.stdenv.mkDerivation {
	        name = "shelley-volante-otf";

	        src = pkgs.fetchzip {
		    url = "https://fontsgeek.com/shelley-volante-font/download";
		    sha256 = "sha256-fxbgEc35xZogktuhkeFDazYCaOMQQTOFtvDhnGB9IdQ=";
		    nativeBuildInputs = [
		        pkgs.unzip
		    ];
		};

		installPhase = ''
		    mkdir -p $out/share/fonts/opentype/
		    install -Dm644 "$PWD/"*/*.otf -t "$out/share/fonts/opentype"
		'';

		meta = with lib; {
		    description = "Shelley Volante";
		    homepage = "https://fontsgeek.com/";
		    platforms = platforms.all;
		};
	    };
	})
    ];
}
