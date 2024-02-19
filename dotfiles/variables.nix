{ config, pkgs, lib, ... }:

with lib;
{
  options.myvars = {
    unfreePackages = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    user = {
      username = mkOption {
        type = types.str;
        default = "jjustin";
      };

      fullName = mkOption {
        type = types.str;
        default = "Janez Justin";
      };
    };
  };
}
