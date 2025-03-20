{config, pkgs, inputs, ...}: {
  imports = [
     ./hypridle.nix
     ./hyprlock.nix
     ./hyprland.nix
  ];

  home.file = {
    ".scripts/statefullock.sh".source = ./scripts/statefullock.sh;
  };

}
