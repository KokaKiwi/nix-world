{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.paru;

  settings = concatLines (
    (map (path: "Include = ${path}") cfg.include)
    ++ optional (cfg.include != [ ]) ""
    ++ [ cfg.extraSettings ]
  );
in {
  options.programs.paru = {
    enable = mkEnableOption "paru";

    package = mkPackageOption pkgs "paru" {};

    includeBaseConfig = mkOption {
      type = types.bool;
      default = true;
    };
    include = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    extraSettings = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.paru.include = mkIf cfg.includeBaseConfig [
      "${cfg.package}/etc/paru.conf"
    ];

    xdg.configFile."paru/paru.conf".source = pkgs.writeText "paru.conf" settings;
  };
}
