{ config, pkgs, lib, ... }:
let
  cfg = config.programs.ptpython;
in {
  options.programs.ptpython = with lib; {
    enable = mkEnableOption "ptpython";

    package = mkPackageOption pkgs.python3Packages "ptpython" { };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
