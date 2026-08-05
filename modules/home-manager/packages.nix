{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      dig
      claude-agent-acp # acp bindings for claude-code
      claude-code
      nono # nono is a sandbox for claude
      git
      gnupg
      gnumake
      htop
      jq
      jwt-cli
      magic-wormhole
      minio-client
      mise
      # neovim # installed via nixvim, installing it here breaks the nixvim modules
      # ngrok
      nil # nix LSP
      nixfmt
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
      go
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
