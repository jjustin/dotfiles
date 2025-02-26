{
  config,
  lib,
  pkgs,
  nixpkgs,
  inputs,
  myvars,
  private,
  ...
}:
{
  imports = [
    ./git.nix
    ./ghostty.nix
    ./nixvim
    ./zsh
  ];

  programs = {
    direnv = {
      enable = true;
    };
  };
}
