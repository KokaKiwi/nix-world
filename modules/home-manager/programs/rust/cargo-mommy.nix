{ config, pkgs, lib, ... }:
let
  cfg = config.programs.rust.cargo-mommy;

  package = config.lib.package;

  moodType = lib.types.enum [ "chill" "ominous" "thirsty" "yikes" ];

  mkConfigOption = args: lib.mkOption ({
    type = with lib.types; nullOr (either str (listOf str));
    default = null;
  } // args);
in {
  options.programs.rust.cargo-mommy = with lib; {
    enable = mkEnableOption "cargo-mommy";
    package = mkPackageOption pkgs "cargo-mommy" { };

    enableAlias = mkEnableOption "cargo alias for cargo-mommy";

    config = {
      little = mkConfigOption { };
      pronouns = mkConfigOption { };
      roles = mkConfigOption { };
      emotes = mkConfigOption { };
      moods = mkConfigOption {
        type = with types; nullOr (either moodType (listOf moodType));
      };

      # NSFW config
      parts = mkConfigOption { };
      fucking = mkConfigOption { };
    };

    finalPackage = mkOption {
      type = types.package;
      internal = true;
      readOnly = true;
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];

    home.shellAliases = mkIf cfg.enableAlias {
      cargo = "cargo-mommy";
    };

    programs.rust.cargo-mommy.finalPackage = let
      setEnv = name: value: let
        valueStr = if builtins.isList value
          then concatStringsSep "/" value
          else value;
      in optionalString (value != null) "--set ${name} \"${valueStr}\"";

      envs = {
        CARGO_MOMMYS_LITTLE = cfg.config.little;
        CARGO_MOMMYS_PRONOUNS = cfg.config.pronouns;
        CARGO_MOMMYS_ROLES = cfg.config.roles;
        CARGO_MOMMYS_EMOTES = cfg.config.emotes;
        CARGO_MOMMYS_MOODS = cfg.config.moods;

        # NSFW config
        CARGO_MOMMYS_PARTS = cfg.config.parts;
        CARGO_MOMMYS_FUCKING = cfg.config.fucking;
      };
    in package.wrapPackage cfg.package {
      makeWrapper = pkgs.makeBinaryWrapper;
    } ''
      wrapProgram $out/bin/cargo-mommy \
        ${concatStringsSep " " (mapAttrsToList setEnv envs)}
    '';
  };
}
