{ config, pkgs, lib, ... }:
let
  cfg = config.programs.rust.cargo-generate;

  toml = pkgs.formats.toml { };
in {
  options.programs.rust.cargo-generate = with lib; {
    enable = mkEnableOption "cargo-generate";
    package = mkPackageOption pkgs "cargo-generate" { };

    config = mkOption {
      type = toml.type;
      default = { };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".cargo/cargo-generate.toml" = mkIf (cfg.config != { }) {
      source = toml.generate "cargo-generate-config.toml" cfg.config;
    };
  };
}
