{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.taplo;

  configFormat = pkgs.formats.toml {};
in {
  options.programs.taplo = {
    enable = mkEnableOption "taplo";

    package = mkPackageOption pkgs "taplo" { };

    rootConfig = mkOption {
      type = configFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."taplo.toml" = mkIf (cfg.rootConfig != { }) {
      source = configFormat.generate "taplo.toml" cfg.rootConfig;
    };
  };
}
