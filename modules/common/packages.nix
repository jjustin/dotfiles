{ pkgs, lib, ... }: {

  myvars.unfreePackages =
    [
      (lib.getName pkgs.ngrok)
    ];

  environment.systemPackages = with pkgs;[
    aws-vault
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
    nodejs_20
    nixpkgs-fmt
    postgresql
    rustup
    sshuttle
    tcpdump
    tig
    wget
  ];
}
