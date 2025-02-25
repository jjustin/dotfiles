{ pkgs, ... }:

{
  environment.variables.EDITOR = "nvim";

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.fira-code
  ];
}
