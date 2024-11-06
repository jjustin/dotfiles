{ config, lib, myvars, private, ... }: {
  programs.git = {
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
      cp = "cherry-pick";
      cpa = "cherry-pick --abort";
      cpc = "cherry-pick --continue";
      cps = "cherry-pick --skip";
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
      pst = "ps --tags";
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

      branch.sort = "-committerdate";
      commit.gpgsign = true;
      pull.ff = "only";
      push.deafult = "nothing"; # Prevents from accidentally pushing to a wrong branch
      tag.forceSignAnnotated = true;
    };

    difftastic.enable = true;
  };
}
