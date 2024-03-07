{ pkgs, ... }:

{
  environment.variables.EDITOR = "nvim";

  # Check: is this darwin only?
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    meslo-lgs-nf
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
}
