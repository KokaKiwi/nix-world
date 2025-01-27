{ config, pkgs, ... }:
{
  lib.python = {
    extendPackageEnv = drv: f: let
      python = drv.pythonModule or pkgs.python3;
      env = python.withPackages(ps: (f ps) ++ [
        (python.pkgs.toPythonModule drv)
      ]);
    in config.lib.package.wrapPackage drv {
      suffix = "-with-env";
    } ''
      rm $out/bin/*
      for executable in ${drv.out}/bin/*; do
        ln -s ${env.out}/bin/$(basename $executable) $out/bin/$(basename $executable)
      done
    '';
  };
}
