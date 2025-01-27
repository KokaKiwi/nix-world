{ config, pkgs, ... }:
{
  programs.ptpython = {
    enable = true;
    package = config.lib.python.extendPackageEnv pkgs.ptpython (ps: with ps; [
      ipython
    ]);
  };
}
