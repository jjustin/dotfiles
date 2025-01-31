{ config, lib, pkgs, ... }:
let
  cfg = config.my.ghostty;
in
{
  options.my = with lib; {
    ghostty = {
      config = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Extra ghostty configuration.";
      };
    };
  };

  config = {
    xdg.configFile."ghostty/config" =
      {

        text = lib.generators.toKeyValue
          {
            mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
            listsAsDuplicateKeys = true;
          }
          cfg.config;
      };

    my.ghostty.config = {
      confirm-close-surface = false;
      keybind = [
        "global:ctrl+super+/=toggle_quick_terminal"
        "super+f=write_screen_file:open"
      ];
    };
  };
}
