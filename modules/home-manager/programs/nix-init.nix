{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nix-init;

  tomlFormat = pkgs.formats.toml { };
in {
  disabledModules = [
    "programs/nix-init.nix"
  ];

  options.programs.nix-init = {
    enable = mkEnableOption "nix-init";

    package = mkPackageOption pkgs "nix-init" { };

    settings = mkOption {
      type = tomlFormat.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."nix-init/config.toml" = mkIf (cfg.settings != { }) {
      source = tomlFormat.generate "config.toml" cfg.settings;
    };
  };
}
