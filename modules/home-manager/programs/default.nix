{ config, lib, pkgs, nixpkgs, inputs, myvars, private, ... }:
{
  imports = [
    ./git.nix
    ./nixvim
    ./zsh
  ];

  programs = {
    direnv = {
      enable = true;
    };
  };
}
