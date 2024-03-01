{ pkgs, lib, ... }: {

  myvars.unfreePackages =
    [
      (lib.getName pkgs.discord)
      (lib.getName pkgs.obsidian)
      (lib.getName pkgs.spotify)
      (lib.getName pkgs.vscode)
    ];


  programs = {
    zsh.enable = true;
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs;[
    obsidian
    spotify
    discord
    vscode
  ];
}
