{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ui.kanshi;
  afterLoadScript = "${pkgs.writeShellScriptBin "handle-kanshi-after-switch.sh" ''
    #!/bin/bash
    hyprctl workspaces -j \
      | jq '.[].name' -r \
      | ${pkgs.findutils}/bin/xargs -I {} hyprctl dispatch moveworkspacetomonitor {} \
          $(hyprctl monitors -j \
              | jq ".[] | select(.description | startswith(\"$1\")) | .id" -r)
    hyprctl dispatch workspace 1
  ''}/bin/handle-kanshi-after-switch.sh";
in
{
  options.ui = {
    kanshi.enable = lib.mkEnableOption "Enable Kanshi";
  };

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      #systemdTarget = "hyprland-session.target";
      settings = [
        {
          output.alias = "work-primary-mon";
          output.criteria = "Dell Inc. DELL U2410 C592M21B2APL";
        }
        {
          output.alias = "work-lt-mon";
          output.criteria = "LG Display 0x06B3 Unknown";
        }
        {
          output.alias = "personal-dt-mon-alt";
          output.criteria = "Microstep MAG321UX OLED 0x01010101";
          output.scale = 1.5;
        }
        {
          output.alias = "personal-dt-mon";
          output.criteria = "Microstep MAG321UX OLED Unknown";
          output.scale = 1.5;
        }
        {
          profile.name = "personal-alt";
          profile.outputs = [
            {
              criteria = "$personal-dt-mon-alt";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "personal";
          profile.outputs = [
            {
              criteria = "$personal-dt-mon";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "worklaptop-undocked";
          profile.outputs = [
            {
              criteria = "$work-lt-mon";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "worklaptop-undocked-fallback";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "worklaptop-docked";
          profile.exec = "${afterLoadScript} 'Dell Inc. DELL U2410 C592M21B2APL'";
          profile.outputs = [
            {
              criteria = "$work-lt-mon";
              status = "disable";
            }
            {
              criteria = "$work-primary-mon";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "worklaptop-docked-nolaptopmon";
          profile.outputs = [
            {
              criteria = "$work-primary-mon";
              status = "enable";
            }
          ];
        }
      ];
    };
  };
}
