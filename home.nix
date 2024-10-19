{ config, lib, pkgs, inputs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.homeDirectory = if pkgs.stdenv.isLinux then "/home/esauder" else "/Users/esauder";
  home.username = "esauder";

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password-gui"
    "1password"
    "1password-cli"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs._1password
    pkgs._1password-gui
    pkgs.clipboard-jh
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config" = {
        source = ./config;
        recursive = true;
    };
    ".config/hypr/hyprland.conf" = {
        source = ./config/hypr/hyprland.conf;
    };

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/esauder/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #programs._1password.enable = true;
  #programs._1password-gui = {
  #  enable = true;
  #  polkitPolicyOwners = [ "esauder" ];
  #};

  programs.git = {
    enable = true;
    userName = "EliSauder";
    userEmail = "24995216+EliSauder@users.noreply.github.com";
    lfs.enable = true;
    aliases = {
      s = "status";
    };
  };

  programs.kitty.enable = true;

  wayland.windowManager.hyprland = {
    enable = false;
    #settings = {
    #  "$mod" = "SUPER";
    #  bind = [
    #    "$mod, Q, exec, kitty"
    #    "$mod, C, killactive,"
    #    "$mod, F, exec, firefox"
    #    "$mod, M, exit,"
    #    "$mod, V, togglefloating,"
    #    "$mod, m, movefocus, l"
    #    "$mod, code:2f, movefocus, r"
    #    "$mod, code:2e, movefocus, u"
    #    "$mod, code:2c, movefocus, d"
    #  ] ++ (
    #    builtins.concatLists (builtins.genList(i:
    #      let ws = i + 1;
    #      in [
    #        "$mod, code:1${toString i}, workspace, ${toString ws}"
    #        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
    #      ]
    #    )
    #    9)
    #  );
    #};
  };
}
