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
    system.activationScripts.keyboard.text =
      let
        mapping = [
          {
            HIDKeyboardModifierMappingSrc = 30064771129; # caps
            HIDKeyboardModifierMappingDst = 30064771113; # esc
          }
        ];
      in
      ''
        echo "remapping keys..." >&2
        hidutil property --set '{"UserKeyMapping":${builtins.toJSON mapping}}' > /dev/null
      '';
  };
}
