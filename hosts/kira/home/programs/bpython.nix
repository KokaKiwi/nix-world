{ pkgs, ... }:
{
  programs.bpython = {
    enable = true;
    package = pkgs.python312Packages.bpython;
  };
}
