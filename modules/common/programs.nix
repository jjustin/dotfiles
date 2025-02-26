{ pkgs, lib, ... }:
{
  programs = {
    zsh.enable = true;
    gnupg.agent.enable = true;
  };
}
