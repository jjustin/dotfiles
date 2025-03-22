{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  my.vars.host = {
    work = true;
    hostName = "mccree";
  };

  my.services.caps2esc.enable = true;
}
