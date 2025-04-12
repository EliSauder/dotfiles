{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.prog.tmux;
  homeDir = config.home.homeDirectory;
in
{
  options.prog = {
    tmux.enable = lib.mkEnableOption "Enable tmux";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gum
      pkgs.fzf
      pkgs.tmux-harpoon
      pkgs.reattach-to-user-namespace
    ];

    # tmux config

    programs.tmux = {
      enable = true;
      clock24 = true;

      escapeTime = 0;
      historyLimit = 10000;

      plugins = [
        pkgs.tmuxPlugins.prefix-highlight
        {
          plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
          extraConfig = ''
            is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
            bind-key -n 'C-h' if-shell "$is_vim" { send-keys C-h } { if-shell -F '#{pane_at_left}'   {} { select-pane -L } }
            bind-key -n 'C-j' if-shell "$is_vim" { send-keys C-j } { if-shell -F '#{pane_at_bottom}' {} { select-pane -D } }
            bind-key -n 'C-k' if-shell "$is_vim" { send-keys C-k } { if-shell -F '#{pane_at_top}'    {} { select-pane -U } }
            bind-key -n 'C-l' if-shell "$is_vim" { send-keys C-l } { if-shell -F '#{pane_at_right}'  {} { select-pane -R } }

            bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   {} { select-pane -L }
            bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' {} { select-pane -D }
            bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    {} { select-pane -U }
            bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  {} { select-pane -R }
          '';
        }
        {
          plugin = pkgs.tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "basic"
          '';
        }
      ];

      extraConfig = ''
        ${
          if pkgs.stdenv.isDarwin then
            "set-option -g default-command '${pkgs.reattach-to-user-namespace}/bin/reattach-to-user-namespace -l $SHELL'"
          else
            ""
        }
        set -g default-terminal "screen-256color"
        set -g remain-on-exit off
        set -gs copy-command "${pkgs.clipboard-jh}/bin/cb copy"

        unbind C-b
        set-option -g prefix C-a
        bind-key C-a send-prefix

        set -g mouse off
        set-window-option -g mode-keys vi
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection

        bind k display-popup -E -w 40% "sesh connect \"$(sesh list --icons - i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡' --no-strip-ansi)\""

        unbind '"'
        unbind %
        bind h split-window -h
        bind v split-window -v

        unbind r
        bind r source-file ~/.config/tmux/tmux.conf

        bind a run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -a'
        bind A run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -A'
        bind m run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -e'
        bind n run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -s 1'
        bind t run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -s 2'
        bind f run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -s 3'
        bind s run '${pkgs.tmux-harpoon}/bin/tmux-harpoon -s 4'
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
