{ pkgs, lib, ... }: {

  myvars.unfreePackages =
    [
      (lib.getName pkgs.ngrok)
    ];

  environment.systemPackages = with pkgs;[
    aws-vault
    awscli2
    cloudflared
    direnv
    gcc
    git
    gitlab-ci-ls
    go_1_22
    go-task #taskfile
    gnupg
    hadolint # docker lint
    htop
    httpie
    jq
    jwt-cli
    k6
    k9s
    kubectl
    minio-client
    neofetch
    neovim
    ngrok
    nil # nix LSP
    nodejs_20
    nixpkgs-fmt
    postgresql
    python3
    rustup
    sshuttle
    tcpdump
    tig
    wget
    watch
  ];
}
