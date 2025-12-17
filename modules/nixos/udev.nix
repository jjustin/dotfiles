{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.udev;
in
{
  options.my.services.udev = {
    enable = mkEnableOption "udev";
    rules = mkOption {
      type = types.listOf types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev = {
      enable = true;
      extraRules = lib.strings.concatStringsSep "\n" cfg.rules;
    };
  };
}
