{ pkgs, ... }:
{
  programs.sccache = {
    enable = true;
    package = pkgs.sccache;
  };
}
