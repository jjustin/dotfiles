{ pkgs, lib, ... }: {

  myvars.unfreePackages =
    [
      (lib.getName pkgs.ngrok)
    ];

  environment.systemPackages = with pkgs;[
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
  ];
}
