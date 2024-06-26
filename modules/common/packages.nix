{ pkgs, lib, inputs, ... }: {

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
    hadolint # docker lint
    htop
    jq
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

    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "gitlab-ci-ls";
      version = inputs.gitlab-ci-ls.rev;
      src = inputs.gitlab-ci-ls;
      cargoLock.lockFile = src + /Cargo.lock;
      nativeBuildInputs = [ ] ++ lib.optionals stdenv.isLinux [
        pkg-config
      ];
      buildInputs = [ ] ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.SystemConfiguration
      ] ++ lib.optionals stdenv.isLinux [
        openssl
      ];
    })
  ];
}
