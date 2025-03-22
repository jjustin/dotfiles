{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
{
  options.my.vars = {
    unfreePackages = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    sshKey = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF26m0pW5B2Y9vUPEx0qqO8CJEyTURaLLFom0ggWjnpq";
      description = ''
        SSH key to use by default.
      '';
    };

    user = {
      username = mkOption {
        type = types.str;
        default = "jjustin";
      };

      homeDirectory = mkOption {
        type = types.str;
        default = "/home/jjustin";
      };

      fullName = mkOption {
        type = types.str;
        default = "Janez Justin";
      };

      sshAuthorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };

    host = {
      personal = mkEnableOption "configuration option marking the host as personal";
      work = mkEnableOption "configuration option marking the host as work";
      hostName = mkOption {
        type = types.str;
        default = throw "hostname not set - my.vars.host.hostname";
      };
    };
  };
}
