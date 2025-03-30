{config, pkgs, lib, ...}:
let
    cfg = config.prog.tmux;
in {
    options.prog = {
        tmux.enable = lib.mkEnableOption "Enable tmux";
    };

    config = lib.mkIf cfg.enable {
        home.packages = [
            pkgs.fzf
            pkgs.tput
            pkgs.awk
            pkgs.tmux-harpoon
        ];

        programs.tmux = {
            enable = true;
            clock24 = true;
            #baseIndex = 1;
            #escapeTime = 0;
            historyLimit = 10000;

            plugins = [ 
                pkgs.tmuxPlugins.vim-tmux-navigator
                pkgs.tmuxPlugins.tmux-fzf
                {
                    plugin = pkgs.tmuxPlugins.catppuccin;
                    extraConfig = ''
                        set -g @catppuccin_flavor "mocha"
                        set -g @catppuccin_window_status_style "basic"
                    '';
                }
            ];

            extraConfig = ''

            '';
            # bind -n M-b run 'harpoon -a'
#bind -n .   run 'harpoon -A'
#bind -n M-v run 'harpoon -l'
#bind -n M-i run 'harpoon -e'
#bind -n M-q run 'harpoon -s 1'  # jump to bookmark at index 1
#bind    M-q run 'harpoon -r 1'  # replace entry at index 1 with current session
#bind -n M-w run 'harpoon -s 2'  # jump to bookmark at index 2
#bind    M-w run 'harpoon -R 2'  # replace entry at index 2 with current pane within session
#bind -n M-e run 'harpoon -s 3'
#bind -n M-r run 'harpoon -s 4'
#
## Note: When replcaing, if there is no entry at the given index, it is appended to the list instead.
        };
    };
}
