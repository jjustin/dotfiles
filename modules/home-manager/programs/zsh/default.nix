{
  config,
  lib,
  pkgs,
  nixpkgs,
  inputs,
  private,
  ...
}:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
    };

    plugins = [
      {
        name = "zsh-aws-vault";
        src = inputs.zsh-aws-vault;
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    initExtra = ''
      # kubectl
      source <(kubectl completion zsh)

      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      # Homebrew
      export PATH=/opt/homebrew/bin:$PATH
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "git"
        "mise"
        "z"
      ];
    };
  };
}
