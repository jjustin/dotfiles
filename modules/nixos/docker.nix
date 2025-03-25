{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.my.services.docker;
in
{
  options.my.services.docker = {
    enable = mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${config.my.vars.user.username}.extraGroups = [ "docker" ];
  };
}
