{config, ...}: {
    imports = [ 
        ./waybar
	    ./hyprland
        ./wofi
    ];

  home.packages = [
    pkgs.layan-gtk-theme
    pkgs.layan-kde
    pkgs.tela-icon-theme
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    inputs.nix-gaming.packages.${pkgs.system}.wine-discord-ipc-bridge
  ];

  home.sessionVariables = {
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
}
