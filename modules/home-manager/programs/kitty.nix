{ config, lib, ... }:
with lib;
let
  cfg = config.programs.kitty;

  symbolMapSetting = types.submodule {
    options = {
      from = mkOption {
        type = types.str;
      };

      to = mkOption {
        type = types.str;
      };

      font = mkOption {
        type = hm.types.fontType;
      };
    };
  };
in {
  options.programs.kitty = {
    symbolMaps = mkOption {
      type = types.listOf symbolMapSetting;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = unique (map ({ font, ... }: font.package) cfg.symbolMaps);

    programs.kitty = {
      extraConfig = mkIf
        (cfg.symbolMaps != [ ])
        (concatMapStringsSep "\n" ({ from, to, font }: "symbol_map U+${from}-U+${to} ${font.name}") cfg.symbolMaps);
    };
  };
}
