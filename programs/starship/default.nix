{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.starship;
in {
    options.prog = {
        starship.enable = lib.mkEnableOption "Enable starship";
    };

    config = lib.mkIf cfg.enable {

        programs.fish.interactiveShellInit = ''
            ${pkgs.starship}/bin/starship init fish | source
        '';

        programs.starship = {
            enable = true;
            enableFishIntegration = true;
            enableBashIntegration = true;
            enableZshIntegration = true;

            settings = {
                format = lib.concatStrings [ 
                    "$container"
                    "$username"
                    "$hostname"
                    "$localip"
                    "$directory"
                    "$kubernetes"
                    "$helm"
                    "$docker"
                    "$cmake"
                    "$dotnet"
                    "$golang"
                    "$lua"
                    "$rust"
                    "$zig"
                    "$nix_shell"
                    "$fill"
                    "$git_branch"
                    "$git_state"
                    "$git_metrics"
                    "$git_status"
                    "$sudo"
                    "$cmd_duration"
                    "\n$status"
                    "$character"
                ];
                add_newline = false;

                character = {
                    success_symbol = "[➜](bold green) ";
                    error_symbol = "[➜](bold green) ";
                    vimcmd_symbol = "[V](bold green) ";
                };

                cmake.symbol = " ";

                cmd_duration = {
                    show_milliseconds = true;
                };

                container = {
                    format = "[$symbol \\[$name\\]]($style)$newline";
                };

                directory = {
                    truncation_length = 5;
                    read_only = "";
                    truncate_to_repo = false;
                    repo_root_style = "underline cyan";
                };

                docker_context.symbol = " ";

                fill.symbol = " ";

                git_branch.symbol = " ";

                git_status = {
                    windows_starship = "/mnt/c/Program\ Files/";
                    ahead = "⇡\${count}";
                    diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
                    behind = "⇣\${count}";
                };

                golang.symbol = " ";

                hostname = {
                    trim_at = "";
                    ssh_symbol = " ";
                };

                lua.symbol = " ";

                nix_shell.symbol = " ";

                rust.symbol = "󱘗 ";

                status = {
                    disabled = false;
                    symbol = "✗ ";
                };

                sudo = {
                    disabled = false;
                };

                username = {
                    show_always = true;
                };

                zig.symbol = " ";
            };
        };
    };
}
