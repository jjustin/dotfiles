{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  my.vars.host = {
    personal = true;
    hostName = "hornet";
  };

  my.services.caps2esc.enable = true;
  my.vars.unfreePackages = [ (lib.getName pkgs.rar) ];
}
