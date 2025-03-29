{ config, pkgs, lib, ... }: 
let
    cfg = config.prog.starship;
in {
    options.prog = {
        starship.enable = lib.mkEnableOption "Enable starship";
    };

    config = lib.mkIf cfg.enable {

        programs.fish.initeractiveShellInit = ''
            starship init fish | source
        '';

        program.starship = {
            enable = true;
            enableFishIntegration = true;
            enableBashIntegration = true;
            enableZshIntegration = true;

            settings = {
                format = "$container$username$hostname$localip$directory$kubernetes$helm$docker$cmake$dotnet$golang$lua$rust$zig$nix_shell$fill$git_branch$git_state$git_metrics$git_status$sudo$cmd_duration$newline$status$character";

                character = {
                    success_symbol = "[➜](bold green) ";
                    error_symbol = "[✗](bold red) ";
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
                    style = "blue";
                    read_only = "";
                    truncation_symbol = "…/";
                };

                docker_context.symbol = " ";

                fill.symbol = " ";

                git_branch.symbol = " ";

                git_status = {
                    windows_starship = "/mnt/c/Program\ Files/";
                    ahead = "⇡${count}";
                    diverged = "⇕⇡${ahead_count}⇣${behind_count}";
                    behind = "⇣${count}";
                };

                golang.symbol = " ";

                hostname = {
                    trim_at = "";
                    ssh_symbol = " "
                };

                lua.symbol = " ";

                nix_shell.symbol = " ";

                rust.symbol = "󱘗 ";

                status = {
                    disabled = false;
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
