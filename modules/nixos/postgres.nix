{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.postgres;
in
{
  options.my.services.postgres = {
    enable = mkEnableOption "postgres";
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
    };
  };
}
