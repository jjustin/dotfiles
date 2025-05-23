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
      aws-vault
      awscli2
      dig
      direnv
      dive
      gcc
      git
      gitlab-ci-ls
      go_1_24
      go-task # taskfile
      gnupg
      hadolint # docker lint
      htop
      httpie
      jq
      jwt-cli
      k6
      k9s
      kubectl
      kubernetes-helm
      minio-client
      mise
      neofetch
      neovim
      ngrok
      nil # nix LSP
      nixfmt-rfc-style
      nodejs_20
      postgresql
      python3
      rustup
      sshuttle
      usage # autocompletion for mise
      tcpdump
      tig
      wget
      whois
      watch
    ]
    ++ lib.optionals config.my.vars.host.personal [
      rar
    ];
}
