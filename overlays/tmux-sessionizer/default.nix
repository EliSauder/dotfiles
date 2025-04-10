{ config, pkgs, lib, ...}: 
let
    pgrepPath = if pkgs.stdenv.isDarwin then "/opt/homebrew/bin/pgrep" else 
        "${pkgs.busybox}/bin/pgrep";
in{
    nixpkgs.overlays = [
        (final: prev: {
	        tmux-sessionizer-personal = pkgs.stdenv.mkDerivation rec {
	            name = "tmux-sessionizer";

                src = ./.;
                phases = [ "installPhase" ];

                installPhase = ''
                    mkdir -p $out/bin
                    cp $src/tms $out/bin
                    chmod +x $out/bin/tms

                    sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g' $out/bin/tms
                    sed -i -e 's|tmux |${pkgs.tmux}/bin/tmux |g' $out/bin/tms
                    sed -i -e 's|basename |${pkgs.toybox}/bin/basename |g' $out/bin/tms
                    sed -i -e 's|pgrep |${pgrepPath} |g' $out/bin/tms
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
