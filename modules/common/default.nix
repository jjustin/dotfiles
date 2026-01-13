{
  config,
  lib,
  pkgs,
  nixpkgs,
  inputs,
  ...
}:
{
  imports = [
    ./misc.nix
    ./packages.nix
    ./programs.nix
  ];
}
