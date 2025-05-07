{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ui.kanshi;
in
{
  options.ui = {
    kanshi.enable = lib.mkEnableOption "Enable Kanshi";
  };

  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "worklaptop-undocked";
          profile.outputs = [
            {
              criteria = "LG Display 0x06B3";
              status = "enable";
              mode = "1920x1080@59.95";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "worklaptop-docked";
          profile.outputs = [
            {
              criteria = "LG Display 0x06B3";
              status = "disable";
            }
            {
              criteria = "Dell Inc. DELL U2410 C592M21B2APL";
              status = "enable";
              mode = "1920x1080@59.95";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "worklaptop-docked-nolaptopmon";
          profile.outputs = [
            {
              criteria = "Dell Inc. DELL U2410 C592M21B2APL";
              status = "enable";
              mode = "1920x1080@59.95";
              position = "0,0";
            }
          ];
        }
      ];
    };
  };
}
