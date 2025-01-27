{ config, pkgs, ... }:
{
  home.file.".gdbinit".text = ''
    set debuginfod enabled on

    add-auto-load-safe-path /usr/share/gdb
    add-auto-load-safe-path ${config.home.homeDirectory}
    add-auto-load-safe-path ${pkgs.go}/share/go/src/runtime/runtime-gdb.py
  '';
}
