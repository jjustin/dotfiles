{ config, lib, pkgs, nixpkgs, inputs, ... }:

# https://nix-community.github.io/home-manager/options.xhtml

{
  programs.home-manager.enable = true;

  # home.username = config.myvars.user.username;
  # home.homeDirectory = "/home/${config.home.username}";

  home.username = "jjustin";
  home.homeDirectory = "/home/jjustin";

  home.packages = with pkgs; [
    firefox
    obsidian
    signal-desktop
    spotify
    discord
    brave
    vscode
    qbittorrent

    neovim
    wget
    rustup
    gcc
    git
    htop
    nil # nix LSP
    neofetch
    nixpkgs-fmt

    usbutils # lsusb
    gnome.gnome-disk-utility
    gnome.gnome-calculator
    chiaki # ps5 streaming

    wineWowPackages.stable
  ];

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;

      enableAutosuggestions = true;
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
      ];

      initExtra = ''
        source ~/.p10k.zsh
      '';

      oh-my-zsh = {
        enable = true;
        plugins = [
          "aws"
          "git"
          "z"
        ];
      };
    };
  };
}
