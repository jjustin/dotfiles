{ config, lib, pkgs, nixpkgs, inputs, myvars, private, ... }:

# https://nix-community.github.io/home-manager/options.xhtml

{
  programs.home-manager.enable = true;

  home.username = myvars.user.username;
  home.homeDirectory = myvars.user.homeDirectory;

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

    direnv = {
      enable = true;
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
        # p10k
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # kubectl
        source <(kubectl completion zsh)

        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        # End Nix
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

    git = {
      enable = true;
      aliases = {
        a = "add";
        au = "add -u";
        aa = "add --all Branches";
        br = "branch";
        brd = "branch -d";
        newbr = "!f(){ git checkout -b $1 origin/HEAD; };f";
        c = "commit";
        ca = "commit --amend";
        can = "commit --amend --no-edit";
        cm = "commit -m";
        cl = "clone";
        co = "checkout";
        d = "diff";
        f = "fetch";
        fap = "fetch --all --prune";
        faprbma = "!git fap && git rbma";
        ls = "ls-files";
        m = "merge --ff-only";
        ps = "push";
        psc = "!git ps origin $(git symbolic-ref --short HEAD)";
        psd = "!git ps origin :$(git symbolic-ref --short HEAD)";
        psu = "!git ps -u origin $(git symbolic-ref --short HEAD)";
        psf = "!git ps --force-with-lease origin $(git symbolic-ref --short HEAD)";
        psff = "ps --force";
        pl = "pull";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbi = "rebase --interactive";
        rbs = "rebase --skip";
        rbma = "!git stash && git rebase origin/HEAD && git stash pop";
        rs = "reset";
        rsma = "reset origin/HEAD";
        rsh = "reset --hard";
        rshma = "reset --hard origin/HEAD";
        st = "status";
        sts = "status --short";
      };

      userName = myvars.user.fullName;

      includes =
        let
          includeConfig = private.gitIncludes;
        in
        map
          (key:
            {
              contents = includeConfig.${key} // { meta."is${key}" = true; };
              contentSuffix = "gitconfig_" + key;
              condition =
                let path = "~/${key}" + (if key == "" then "" else "/");
                in "gitdir:${path}";
            }
          )
          (builtins.attrNames includeConfig);


      extraConfig = {
        init.defaultBranch = "main";

        core.editor = "nvim";
        web.browser = "brave";

        color = {
          branch = {
            current = "yellow bold";
            local = "green bold";
            remote = "cyan bold";
          };

          status = {
            added = "green bold";
            changed = "yellow bold";
            untracked = "red bold";
          };
        };

        url = {
          "ssh://git@github.com/".insteadOf = "https://github.com/";
          "ssh://git@gitlab.com/".insteadOf = "https://gitlab.com/";
        };

        branch.sort = "-commiterdate";
        commit.gpgsign = true;
        pull.ff = "only";
        push.deafult = "nothing"; # Prevents from accidentally pushing to a wrong branch
        tag.forceSignAnnotated = true;
      };

      difftastic.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        plenary-nvim
        gruvbox-material
        mini-nvim
      ];
    };

    extraConfig = ''
      syntax on
      set spell spelllang=en_us
      autocmd Filetype gitcommit set textwidth=72
    '';
  };
}
