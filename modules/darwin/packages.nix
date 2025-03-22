{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = lib.mkIf config.my.vars.host.work [
    pkgs.cloudflared
  ];
}
