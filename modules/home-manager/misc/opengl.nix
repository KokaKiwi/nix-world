{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.opengl;

  packageLib = config.lib.package;
in {
  options.opengl = {
    vaDrivers = mkOption {
      type = with types; listOf package;
      default = [ ];
    };
  };

  config = {
    lib.opengl = {
      wrapPackage = drv: {
        extraWrapperFlags ? [ ],
      }: let
        mesa-drivers = [ pkgs.mesa.drivers ];
        libvdpau = [ pkgs.libvdpau-va-gl ];

        libPaths = [
          (makeLibraryPath mesa-drivers)
          (makeSearchPathOutput "lib" "lib/vdpau" libvdpau)
          (makeLibraryPath [ pkgs.libglvnd ])
        ];
      in packageLib.wrapPackage drv {
        suffix = "-glwrapped";
      } ''
        rm -rf $out/bin/*
        shopt -s nullglob
        for executable in ${drv.out}/bin/*; do
          makeWrapper $executable "$out/bin/$(basename $executable)" \
            --inherit-argv0 \
            --prefix LD_LIBRARY_PATH ":" ${concatStringsSep ":" libPaths} \
            --prefix __EGL_VENDOR_LIBRARY_FILENAMES ":" ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json \
            --set LIBGL_DRIVERS_PATH ${makeSearchPathOutput "lib" "lib/dri" mesa-drivers} \
            --set LIBVA_DRIVERS_PATH ${makeSearchPathOutput "out" "lib/dri" (mesa-drivers ++ cfg.vaDrivers)} \
            ${toString extraWrapperFlags}
        done
        shopt -u nullglob # Revert nullglob back to its normal default state
      '';
    };
  };
}
