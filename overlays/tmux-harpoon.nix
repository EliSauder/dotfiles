{ config, pkgs, lib, ...}: {
    nixpkgs.overlays = [
        (final: prev: {
	        tmux-harpoon = pkgs.stdenv.mkDerivation rec {
	            pname = "tmux-harpoon";
	            src = pkgs.fetchFromGitHub {
	                owner = "Chaitanyabsprip";
	                repo = name;
	                rev = "6c4a2db955a28d093835f9eff832ef4c6ae1e942";
	                sha256 = lib.fakeHash;
	            };

                phases = [ "preInstall" "installPhase" ];

                preInstall = ''
                    sed -i -e 's|awk |${pkgs.gawk}/bin/awk |g' harpoon
                    sed -i -e 's|fzf |${pkgs.fzf}/bin/fzf |g' harpoon
                    sed -i -e 's|tmux |${pkgs.tmux}/bin/tmux |g' harpoon
                '';

                installPhase = ''
                    mkdir -p $out
                    cp harpoon $out/tmux-harpoon
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
