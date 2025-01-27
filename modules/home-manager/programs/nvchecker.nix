{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nvchecker;

  keyfileFormat = pkgs.formats.toml {};
in {
  options.programs.nvchecker = {
    enable = mkEnableOption "nvchecker";

    package = mkPackageOption pkgs "nvchecker" { };

    keyfile = mkOption {
      type = with types; nullOr (either keyfileFormat.type path);
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."nvchecker/keyfile.toml" = mkIf (cfg.keyfile != null) {
      source = if builtins.isAttrs cfg.keyfile
        then keyfileFormat.generate "keyfile.toml" cfg.keyfile
        else cfg.keyfile;
    };
  };
}
