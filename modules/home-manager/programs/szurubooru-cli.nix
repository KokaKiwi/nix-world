{ config, pkgs, lib, ... }:
let
  cfg = config.programs.szurubooru-cli;

  tomlFormat = pkgs.formats.toml { };
in {
  options.programs.szurubooru-cli = with lib; {
    enable = mkEnableOption "szurubooru-cli";

    package = mkPackageOption pkgs "szurubooru-cli" { };

    config = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."booru/config.toml" = mkIf (cfg.config != { }) {
      source = tomlFormat.generate "booru-config.toml" cfg.config;
    };
  };
}
