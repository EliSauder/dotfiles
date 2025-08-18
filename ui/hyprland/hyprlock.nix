{
  config,
  pkgs,
  inputs,
  lib,
  specialArgs,
  ...
}:
let
  cfg = config.ui.hyprlock;
  isUbuntu = specialArgs.distro == "ubuntu";
in
{

  options.ui = {
    hyprlock.enable = lib.mkEnableOption "Enable Hyprlock";
  };

  config = lib.mkIf cfg.enable {

    programs.hyprlock = {
      enable = true;

      settings = {
        general =
          if isUbuntu then
            {
              hide_cursor = false;
              no_fade_out = true;
              no_fade_in = true;
            }
          else
            {
              hide_cursor = false;
              screencopy_mode = 1;
              immediate_render = true;
            };

        auth = lib.mkIf (!isUbuntu) {
          pam = {
            enabled = true;
          };
        };

        animations = lib.mkIf (!isUbuntu) {
          enabled = false;
        };

        background = {
          monitor = "";
          path = "screenshot";
          color = "rgba(0,0,0,0.9)";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.01;
          contrast = 1;
          brightness = 1;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.9;
        };

        input-field = {
          monitor = "";
          size = "400, 50";
          outline_thickness = 0;
          dots_size = 0.3; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.4; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0,0,0,0)";
          inner_color = "rgba(200, 200, 200, 0)";
          font_color = "rgb(255,255,255)";
          fade_on_empty = true;
          placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
          fail_text = "$PAMFAIL";
          hide_input = false;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };

        label = {
          monitor = "";
          text = "$TIME";
          color = "rgba(200, 200, 200, 1.0)";
          font_size = 25;
          font_family = "Noto Sans";

          position = "0, 80";
          halign = "center";
          valign = "center";
        };
      };
    };
  };
}
