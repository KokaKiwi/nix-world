{ config, pkgs, lib, ... }:
let
  cfg = config.programs.rust;

  toml = pkgs.formats.toml { };
in {
  imports = [
    ./rust/cargo-generate.nix
    ./rust/cargo-mommy.nix
  ];

  options.programs.rust = with lib; {
    cargoConfig = mkOption {
      type = toml.type;
      default = { };
    };
  };

  config = with lib; {
    home.file.".cargo/config.toml" = mkIf (cfg.cargoConfig != { }) {
      source = toml.generate "cargo-config.toml" cfg.cargoConfig;
    };
  };
}
