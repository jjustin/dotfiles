{ pkgs, ... }:

{
  environment.variables.EDITOR = "nvim";

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
