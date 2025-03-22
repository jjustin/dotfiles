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
