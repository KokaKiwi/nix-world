{ config, pkgs, lib, ... }:
let
  cfg = config.programs.just;

  ruleType = with lib; types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      text = mkOption {
        type = types.str;
      };
    };
  });

  justfile = let
    generateRule = rule: let
    in ''
      ${rule.name}:
        ${rule.text}
    '';
  in pkgs.writeText "justfile" ''
    ${lib.optionalString (cfg.justfile.defaultRule != null) ''
      _default:${lib.optionalString (cfg.justfile.defaultRule != "") " ${cfg.justfile.defaultRule}"}
    ''}
    ${lib.concatMapStrings generateRule (lib.attrValues cfg.justfile.rules)}
  '';
in {
  disabledModules = [
    "programs/just.nix"
  ];

  options.programs.just = with lib; {
    enable = mkEnableOption "just";

    package = mkPackageOption pkgs "just" { };

    justfile = {
      enable = mkEnableOption "user Justfile";

      path = mkOption {
        type = types.str;
        default = "Justfile";
      };
      source = mkOption {
        type = types.path;
        default = justfile;
      };

      defaultRule = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      rules = mkOption {
        type = types.attrsOf ruleType;
        default = { };
      };
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.${cfg.justfile.path} = mkIf cfg.justfile.enable {
      inherit (cfg.justfile) source;
    };
  };
}
