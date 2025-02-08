{ config, pkgs, ... }:
{
  programs.ptpython = {
    enable = true;
    package = config.lib.python.extendPackageEnv pkgs.python3Packages.ptpython (ps: with ps; [
      ipython
    ]);
  };
}
