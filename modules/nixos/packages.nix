{
  pkgs,
  lib,
  config,
  ...
}:
{

  my.vars.unfreePackages = [
    (lib.getName pkgs.ngrok)
  ];

  environment.systemPackages = with pkgs; [
    gcc
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
}
