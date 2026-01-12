{
  pkgs,
  lib,
  config,
  ...
}:
{

  my.vars.unfreePackages = [
    (lib.getName pkgs.ngrok)
  ];

  environment.systemPackages =
    with pkgs;
    [
      dig
      git
      gnupg
      gnumake
      htop
      jq
      jwt-cli
      minio-client
      mise
      neofetch
      neovim
      ngrok
      nil # nix LSP
      nixfmt-rfc-style
      usage # autocompletion for mise
      uv # use for python. See ../nixos/packages.nix if you need dynamic libraries installed.
      tcpdump
      tig
      wget
      whois
      watch
    ]
    ++ lib.optionals config.my.vars.host.work [
      aws-vault
      awscli2
      direnv
      dive
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
      gitlab-ci-ls
      go_1_24
      go-task # taskfile
      hadolint # docker lint
      httpie
      natscli
      k6
      k9s
      kubectl
      kubernetes-helm
      nodejs_22
      postgresql
      python3
      restish
      rustup
      sshuttle
    ]
    ++ lib.optionals config.my.vars.host.personal [
      rar
    ];
}
