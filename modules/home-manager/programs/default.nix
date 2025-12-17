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
    ./atuin.nix
    ./git.nix
    ./ghostty.nix
    ./ssh.nix
    ./nixvim
    ./zsh
  ];

  programs = {
    direnv = {
      enable = true;
    };
  };
}
