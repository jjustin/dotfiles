{
  pkgs,
  lib,
  ...
}:
{
  my.vars = {
    host = {
      personal = true;
      work = false;
    };
    unfreePackages = [
      (lib.getName pkgs.rar)
    ];
  };
}
