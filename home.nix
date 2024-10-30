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

  imports = [
     ./programs
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"
    "steam"
    "steam-unwrapped"
    "discord"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs._1password-cli
    pkgs._1password-gui
    pkgs.cliphist
    pkgs.wl-clipboard
    pkgs.discord
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.steam
    pkgs.steam-run
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
    pkgs.waybar
    pkgs.wofi
    pkgs.nemo
    pkgs.swww
    pkgs.mako
    pkgs.hypridle

    pkgs.neovim

    #(pkgs.flameshot.override { enableWlrSupport = true; })
    #pkgs.shotman
    pkgs.slurp
    pkgs.grim
    pkgs.satty

    pkgs.layan-gtk-theme
    pkgs.layan-kde
    pkgs.tela-icon-theme
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    #inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
    #inputs.nix-gaming.packages.${pkgs.system}.modrinth-app

    pkgs.xivlauncher
    #pkgs.wineWowPackages.waylandFull
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    #".config/hypr/hyprland.conf" = {
    #    source = ./config/hypr/hyprland.conf;
    #};

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
    EDITOR = "nvim";
    GTK_USE_PORTAL = 1;
  };
  

  home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine";
      size = 24;
  };
  gtk = {
      enable = true;
      theme.package = pkgs.layan-gtk-theme;
      theme.name = "Layan-Dark";
      iconTheme.package = pkgs.tela-icon-theme;
      iconTheme.name = "Tela";
      cursorTheme.package = pkgs.rose-pine-cursor;
      cursorTheme.name = "BreezeX-RosePine";
  };

  qt.enable = true;
  qt.platformTheme.name = "kde";
  qt.style.package = pkgs.layan-kde;
  qt.style.name = "Layan-Dark";



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #programs._1password.enable = true;
  #programs._1password-gui = {
  #  enable = true;
  #  polkitPolicyOwners = [ "esauder" ];
  #};

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes 2h";
    matchBlocks = {
        "github.com" = {
	    hostname = "github.com";
	    identityFile = "${config.home.homeDirectory}/.ssh/git_ed25519";
	};
    };
  };

  programs.firefox = {
      enable = true;
      package = pkgs.firefox.override {
          nativeMessagingHosts = [
	      pkgs.gnome-browser-connector
	  ];
      };
      profiles = {
          personal = {
	      id = 0;
	      name = "personal";
	      isDefault = true;
	      settings = {
	          "browser.search.defaultenginename" = "DuckDuckGo";
		  "browser.search.order.1" = "DuckDuckGo";
		  "signon.rememberSignons" = false;
		  "widget.use-xdg-desktop-portal.file-picker" = 1;
		  "browser.aboutConfig.showWarning" = false;
		  "browser.compactmode.show" = true;
		  "browser.cache.disk.enable" = false;
	      };
	      search = {
	          force = true;
		  default = "DuckDuckGo";
		  order = [ "DuckDuckGo" "Brave" "Google" ];
	      };
	  };
      };
  };

  programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
	  obs-vkcapture
	  obs-vaapi
	  obs-vintage-filter
	  obs-tuna
	  input-overlay
	  obs-backgroundremoval
      ];
  };

  programs.kitty.enable = true;
}
