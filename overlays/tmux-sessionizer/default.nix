{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	        tmux-sessionizer-personal = pkgs.stdenv.mkDerivation rec {
	            name = "tmux-sessionizer";

                src = "./tms"
                phases = [ "installPhase" ];

                installPhase = ''
                    mkdir -p $out/bin
                    cp $src $out/bin

                    sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g' $out/bin/tms
                    sed -i -e 's|tmux |${pkgs.tmux}/bin/tmux |g' $out/bin/tms
                    sed -i -e 's|pgrep |${pkgs.toybox}/bin/pgrep |g' $out/bin/tms
                    sed -i -e 's|basename |${pkgs.toybox}/bin/basename |g' $out/bin/tms
                '';

                buildInputs = [
                    pkgs.fzf
                    pkgs.tmux
                    pkgs.toybox
                ];
	        };
	    })
    ];
}
