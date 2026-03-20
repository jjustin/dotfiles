{
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.fira-code
  ];
}
