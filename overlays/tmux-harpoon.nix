{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	        tmux-harpoon = pkgs.stdenv.mkDerivation rec {
	            name = "tmux-harpoon";
	            src = pkgs.fetchFromGitHub {
	                owner = "Chaitanyabsprip";
	                repo = name;
	                rev = "6c4a2db955a28d093835f9eff832ef4c6ae1e942";
                    sha256 = "sha256-Xep5JWFWmq2bOPiJhXK7FVG1wS6lmzajCOxm1uJV6I0=";
	            };

                phases = [ "installPhase" ];

                installPhase = ''
                    mkdir -p $out/bin
                    cp $src/harpoon $out/bin
                    mv $out/bin/harpoon $out/bin/tmux-harpoon

                    sed -i -e 's|awk |${pkgs.gawk}/bin/awk |g' $out/bin/tmux-harpoon
                    sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g' $out/bin/tmux-harpoon
                    sed -i -e 's|tmux |${pkgs.tmux}/bin/tmux |g' $out/bin/tmux-harpoon
                '';

                buildInputs = [
                    pkgs.gawk
                    pkgs.fzf
                    pkgs.ncurses
                    pkgs.tmux
                ];
	        };
	    })
    ];
}
