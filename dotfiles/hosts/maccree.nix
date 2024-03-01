{ config, pkgs, lib, ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  myvars.unfreePackages =
    [
      (lib.getName pkgs.discord)
      (lib.getName pkgs.ngrok)
      (lib.getName pkgs.obsidian)
      (lib.getName pkgs.spotify)
      (lib.getName pkgs.vscode)
    ];

  my.services.caps2esc.enable = true;

  users.users.${config.myvars.user.username} = {
    name = config.myvars.user.username;
    home = config.myvars.user.homeDirectory;
  };

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  environment.systemPackages = with pkgs;
    [
      direnv
      gcc
      git
      go
      gnupg
      htop
      k9s
      kubectl
      neofetch
      neovim
      ngrok
      nil # nix LSP
      nixpkgs-fmt
      rustup
      tig
      wget

      obsidian
      spotify
      discord
      vscode
    ];
}
