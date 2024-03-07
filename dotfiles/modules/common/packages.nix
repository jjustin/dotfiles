{ pkgs, lib, ... }: {

  myvars.unfreePackages =
    [
      (lib.getName pkgs.ngrok)
    ];

  environment.systemPackages = with pkgs;[
    cloudflared
    direnv
    gcc
    git
    go_1_22
    gnupg
    htop
    jq
    k9s
    kubectl
    neofetch
    neovim
    ngrok
    nil # nix LSP
    nixpkgs-fmt
    postgresql
    rustup
    sshuttle
    tig
    wget
  ];
}
