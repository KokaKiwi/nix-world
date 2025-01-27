{ config, pkgs, lib, ... }:
let
  cfg = config.programs.act;

  presets = {
    Micro = {
      ubuntu-latest = "node:16-buster-slim";
      "ubuntu-22.04" = "node:16-bullseye-slim";
      "ubuntu-20.04" = "node:16-buster-slim";
      "ubuntu-18.04" = "node:16-buster-slim";
    };
    Medium = {
      ubuntu-latest = "catthehacker/ubuntu:act-latest";
      "ubuntu-22.04" = "catthehacker/ubuntu:act-22.04";
      "ubuntu-20.04" = "catthehacker/ubuntu:act-20.04";
      "ubuntu-18.04" = "catthehacker/ubuntu:act-18.04";
    };
    Large = {
      ubuntu-latest = "catthehacker/ubuntu:full-latest";
      "ubuntu-22.04" = "catthehacker/ubuntu:full-22.04";
      "ubuntu-20.04" = "catthehacker/ubuntu:full-20.04";
      "ubuntu-18.04" = "catthehacker/ubuntu:full-18.04";
    };
  };
in {
  options.programs.act = with lib; {
    enable = mkEnableOption "act";
    package = mkPackageOption pkgs "act" { };

    preset = mkOption {
      type = with types; nullOr (enum [ "Micro" "Medium" "Large" ]);
      default = null;
    };
    platforms = mkOption {
      type = with types; attrsOf str;
      default = { };
    };

    extraRcFlags = mkOption {
      type = with types; listOf anything;
      default = [ ];
    };
  };

  config = with lib; mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.act.platforms = mkIf (cfg.preset != null) presets.${cfg.preset};

    xdg.configFile."act/actrc" = let
      platformRcFlags = mapAttrsToList (name: image:
        "--platform ${name}=${image}"
      ) cfg.platforms;

      rcFlags =
        platformRcFlags
        ++ cfg.extraRcFlags;
    in mkIf (rcFlags != [ ]) {
      text = concatStringsSep "\n" rcFlags;
    };
  };
}
