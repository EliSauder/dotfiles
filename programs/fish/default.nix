{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.prog.fish;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  options.prog = {
    fish.enable = lib.mkEnableOption "Enable fish";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.grc
      pkgs.fzf
      pkgs.fd
      pkgs.bat
    ];

    xdg.configFile."fish/themes/Catppuccin Mocha.theme".text = ''
      # name: 'Catppuccin Mocha'
      # url: 'https://github.com/catppuccin/fish'

      fish_color_normal cdd6f4
      fish_color_command 89b4fa
      fish_color_param f2cdcd
      fish_color_keyword f38ba8
      fish_color_quote a6e3a1
      fish_color_redirection f5c2e7
      fish_color_end fab387
      fish_color_comment 7f849c
      fish_color_error f38ba8
      fish_color_gray 6c7086
      fish_color_selection --background=313244
      fish_color_search_match --background=313244
      fish_color_option a6e3a1
      fish_color_operator f5c2e7
      fish_color_escape eba0ac
      fish_color_autosuggestion 6c7086
      fish_color_cancel f38ba8
      fish_color_cwd f9e2af
      fish_color_user 94e2d5
      fish_color_host 89b4fa
      fish_color_host_remote a6e3a1
      fish_color_status f38ba8
      fish_pager_color_progress 6c7086
      fish_pager_color_prefix f5c2e7
      fish_pager_color_completion cdd6f4
      fish_pager_color_description 6c7086
    '';

    xdg.configFile."fish/conf.d/plugin-nix-env.fish".text = lib.mkIf (specialArgs.distro != "nixos") ''
      # Setup Nix

      # We need to distinguish between single-user and multi-user installs.
      # This is difficult because there's no official way to do this.
      # We could look for the presence of /nix/var/nix/daemon-socket/socket but this will fail if the
      # daemon hasn't started yet. /nix/var/nix/daemon-socket will exist if the daemon has ever run, but
      # I don't think there's any protection against accidentally running `nix-daemon` as a user.
      # We also can't just look for /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh because
      # older single-user installs used the default profile instead of a per-user profile.
      # We can still check for it first, because all multi-user installs should have it, and so if it's
      # not present that's a pretty big indicator that this is a single-user install. If it does exist,
      # we still need to verify the install type. To that end we'll look for a root owner and sticky bit
      # on /nix/store. Multi-user installs set both, single-user installs don't. It's certainly possible
      # someone could do a single-user install as root and then manually set the sticky bit but that
      # would be extremely unusual.

      set -l nix_profile_path /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      set -l single_user_profile_path ~/.nix-profile/etc/profile.d/nix.sh
      if test -e $nix_profile_path
        # The path exists. Double-check that this is a multi-user install.
        # We can't just check for ~/.nix-profile/… because this may be a single-user install running as
        # the wrong user.

        # stat is not portable. Splitting the output of ls -nd is reliable on most platforms.
        set -l owner (string split -n ' ' (command ls -nd /nix/store 2>/dev/null))[3]
        if not test -k /nix/store -a $owner -eq 0
          # /nix/store is either not owned by root or not sticky. Assume single-user.
          set nix_profile_path $single_user_profile_path
        end
      else
        # The path doesn't exist. Assume single-user
        set nix_profile_path $single_user_profile_path
      end

      if test -e $nix_profile_path
        # Source the nix setup script
        # We're going to run the regular Nix profile under bash and then print out a few variables
        for line in (command env -u BASH_ENV bash -c '. "$0"; for name in PATH "''${!NIX_@}"; do printf "%s=%s\0" "$name" "''${!name}"; done' $nix_profile_path | string split0)
          set -xg (string split -m 1 = $line)
        end

        # Insert Nix's fish share directories into fish's special variables.
        # nixpkgs-installed fish tries to set these up already if NIX_PROFILES is defined, which won't
        # be the case when sourcing $__fish_data_dir/share/config.fish normally, but might be for a
        # recursive invocation. To guard against that, we'll only insert paths that don't already exit.
        # Furthermore, for the vendor_conf.d sourcing, we'll use the pre-existing presence of a path in
        # $fish_function_path to determine whether we want to source the relevant vendor_conf.d folder.

        # To start, let's locally define NIX_PROFILES if it doesn't already exist.
        set -al NIX_PROFILES
        if test (count $NIX_PROFILES) -eq 0
          set -a NIX_PROFILES $HOME/.nix-profile
        end
        # Replicate the logic from nixpkgs version of $__fish_data_dir/__fish_build_paths.fish.
        set -l __nix_profile_paths (string split ' ' -- $NIX_PROFILES)[-1..1]
        set -l __extra_completionsdir \
          $__nix_profile_paths/etc/fish/completions \
          $__nix_profile_paths/share/fish/vendor_completions.d
        set -l __extra_functionsdir \
          $__nix_profile_paths/etc/fish/functions \
          $__nix_profile_paths/share/fish/vendor_functions.d
        set -l __extra_confdir \
          $__nix_profile_paths/etc/fish/conf.d \
          $__nix_profile_paths/share/fish/vendor_conf.d \

        ### Configure fish_function_path ###
        # Remove any of our extra paths that may already exist.
        # Record the equivalent __extra_confdir path for any function path that exists.
        set -l existing_conf_paths
        for path in $__extra_functionsdir
          if set -l idx (contains --index -- $path $fish_function_path)
            set -e fish_function_path[$idx]
            set -a existing_conf_paths $__extra_confdir[(contains --index -- $path $__extra_functionsdir)]
          end
        end
        # Insert the paths before $__fish_data_dir.
        if set -l idx (contains --index -- $__fish_data_dir/functions $fish_function_path)
          # Fish has no way to simply insert into the middle of an array.
          set -l new_path $fish_function_path[1..$idx]
          set -e new_path[$idx]
          set -a new_path $__extra_functionsdir
          set fish_function_path $new_path $fish_function_path[$idx..-1]
        else
          set -a fish_function_path $__extra_functionsdir
        end

        ### Configure fish_complete_path ###
        # Remove any of our extra paths that may already exist.
        for path in $__extra_completionsdir
          if set -l idx (contains --index -- $path $fish_complete_path)
            set -e fish_complete_path[$idx]
          end
        end
        # Insert the paths before $__fish_data_dir.
        if set -l idx (contains --index -- $__fish_data_dir/completions $fish_complete_path)
          set -l new_path $fish_complete_path[1..$idx]
          set -e new_path[$idx]
          set -a new_path $__extra_completionsdir
          set fish_complete_path $new_path $fish_complete_path[$idx..-1]
        else
          set -a fish_complete_path $__extra_completionsdir
        end

        ### Source conf directories ###
        # The built-in directories were already sourced during shell initialization.
        # Any __extra_confdir that came from $__fish_data_dir/__fish_build_paths.fish was also sourced.
        # As explained above, we're using the presence of pre-existing paths in $fish_function_path as a
        # signal that the corresponding conf dir has also already been sourced.
        # In order to simulate this, we'll run through the same algorithm as found in
        # $__fish_data_dir/config.fish except we'll avoid sourcing the file if it comes from an
        # already-sourced location.
        # Caveats:
        # * Files will be sourced in a different order than we'd ideally do (because we're coming in
        #   after the fact to source them).
        # * If there are existing extra conf paths, files in them may have been sourced that should have
        #   been suppressed by paths we're inserting in front.
        # * Similarly any files in $__fish_data_dir/vendor_conf.d that should have been suppressed won't
        #   have been.
        set -l sourcelist
        for file in $__fish_config_dir/conf.d/*.fish $__fish_sysconf_dir/conf.d/*.fish
          # We know these paths were sourced already. Just record them.
          set -l basename (string replace -r '^.*/' ''' -- $file)
          contains -- $basename $sourcelist
          or set -a sourcelist $basename
        end
        for root in $__extra_confdir
          for file in $root/*.fish
            set -l basename (string replace -r '^.*/' ''' -- $file)
            contains -- $basename $sourcelist
            and continue
            set -a sourcelist $basename
            contains -- $root $existing_conf_paths
            and continue # this is a pre-existing path, it will have been sourced already
            [ -f $file -a -r $file ]
            and source $file
          end
        end
      end
    '';

    xdg.configFile."fish/functions/fish_ssh_agent.fish".text =
      if isDarwin then
        ''
          function __ssh_agent_is_started -d "check if ssh agent is already started"
             if begin; test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"; end
                source $SSH_ENV > /dev/null
             end

             if test -z "$SSH_AGENT_PID"
                return 1
             end

             ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep -q ssh-agent
             #pgrep ssh-agent
             return $status
          end


          function __ssh_agent_start -d "start a new ssh agent"
             ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
             chmod 600 $SSH_ENV
             source $SSH_ENV > /dev/null
             true  # suppress errors from setenv, i.e. set -gx
          end


          function fish_ssh_agent --description "Start ssh-agent if not started yet, or uses already started ssh-agent."
             if test -z "$SSH_ENV"
                set -xg SSH_ENV $HOME/.ssh/environment
             end

             if not __ssh_agent_is_started
                __ssh_agent_start
             end
          end
        ''
      else
        "";

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting

        set sponge_allow_previously_successful true
        set sponge_purge_only_on_exit true

        fish_vi_key_bindings

        fish_config theme choose 'Catppuccin Mocha'

        function fish_user_key_bindings
          fish_vi_key_bindings

          bind --user -M visual -m default y "fish_clipboard_copy; commandline -f end-selection repaint-mode"
        end

        ${if isDarwin then "fish_ssh_agent" else ""}
      '';
      shellInit = '''';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "puffer";
          src = pkgs.fishPlugins.puffer.src;
        }
        {
          name = "sponge";
          src = pkgs.fishPlugins.sponge.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages;
        }
      ];
    };
  };
}
