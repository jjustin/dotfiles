{ config, pkgs, lib, ... }:

with lib;
let cfg = config.my.services.caps2esc;
in {
  options.my.services.caps2esc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    system.keyboard =
      {
        enableKeyMapping = true;
        nonUS.remapTilde = true;
        remapCapsLockToEscape = true;
      };
  };
}
