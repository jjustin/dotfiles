{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.caps2esc;
in
{
  options.my.services.caps2esc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    device = mkOption {
      type = types.str;
      example = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
    };
  };

  config = lib.mkIf cfg.enable {
    services.interception-tools = {
      enable = true;
      plugins = with pkgs; [
        interception-tools-plugins.caps2esc
      ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            LINK: ${cfg.device}
      '';
    };
  };
}
