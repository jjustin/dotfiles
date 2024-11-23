{ pkgs, lib, config, ... }:
{
  environment.systemPackages = lib.mkIf config.myvars.host.work [
    pkgs.cloudflared
  ];
}
