{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.fish;

  completionType = types.submodule {
    options = {
      content = mkOption {
        type = with types; nullOr lines;
        default = null;
      };
      source = mkOption {
        type = with types; nullOr path;
        default = null;
      };

      builder = mkOption {
        type = with types; nullOr lines;
        default = null;
      };
    };
  };
in {
  options = {
    programs.fish = {
      completions = mkOption {
        type = with types; attrsOf (either lines completionType);
        default = { };
      };

      conf = mkOption {
        type = with types; attrsOf (either str lines);
        default = { };
      };

      variables = mkOption {
        type = with types; attrsOf (oneOf [ str int path ]);
        default = { };
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      xdg.configFile = let
        fromContent = name: content:
          pkgs.writeText "${name}.fish" content;
        fromBuilder = name: builder:
          pkgs.runCommandLocal "${name}.fish" { } ''
            (
              ${builder}
            ) > $out
          '';

        completions = mapAttrs (_: value:
          if builtins.isAttrs value
          then value
          else { content = value; }
        ) cfg.completions;
      in mapAttrs' (name: {
        content ? null,
        source ? null,
        builder ? null,
      }: {
        name = "fish/completions/${name}.fish";
        value.source =
          if content != null then fromContent name content
          else if source != null then source
          else if builder != null then fromBuilder name builder
          else throw "Invalid completion definition"
        ;
      }) completions;
    }
    {
      xdg.configFile = mapAttrs' (name: content: {
        name = "fish/conf.d/${name}.fish";
        value.text = content;
      }) cfg.conf;
    }
    {
      programs.fish.conf."10-variables" = mkIf (cfg.variables != { })
        (concatLines (mapAttrsToList (name: value: ''set -x ${name} "${value}"'') cfg.variables));
    }
  ]);
}
