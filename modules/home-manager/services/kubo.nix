{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.kubo;

  settingsFormat = pkgs.formats.json {};

  profile = if cfg.localDiscovery then "local-discovery" else "server";

  rawDefaultConfig = lib.importJSON (
    pkgs.runCommandLocal "kubo-default-config" {
      nativeBuildInputs = [ cfg.package ];
    } ''
      export IPFS_PATH="$TMPDIR"
      ipfs init --profile=${profile} --empty-repo
      ipfs --offline config show > "$out"
    ''
  );
  defaultConfig = builtins.removeAttrs rawDefaultConfig [ "Identity" "Pinning" ];
  fullConfig = recursiveUpdate defaultConfig cfg.settings;
  configFile = settingsFormat.generate "kubo-config.json" fullConfig;

  preStartScript = pkgs.writeShellApplication {
    name = "ipfs-pre-start";

    runtimeInputs =
      [ cfg.package pkgs.jq ]
      ++ optional cfg.autoMigrate pkgs.kubo-migrator;

    text = ''
      if [[ ! -f "$IPFS_PATH/config" ]]; then
        ipfs init --empty-repo=true
      else
        rm -vf "$IPFS_PATH/api"
        ${optionalString cfg.autoMigrate "fs-repo-migrations -to '${cfg.package.repoVersion}' -y"}
      fi
      ipfs --offline config show |
        jq -s '.[0].Pinning as $Pinning | .[0].Identity as $Identity | .[1] + {$Identity,$Pinning}' - '${configFile}' |
        ipfs --offline config replace -
    '';
  };
in {
  options.services.kubo = {
    enable = mkEnableOption "kubo";

    package = mkPackageOption pkgs "kubo" {};

    dataDir = mkOption {
      type = types.str;
      default = "${config.xdg.dataHome}/ipfs";
    };

    autoMigrate = mkOption {
      type = types.bool;
      default = true;
      description = "Whether Kubo should try to run the fs-repo-migration at startup.";
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = { };
    };

    extraFlags = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    localDiscovery = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.sessionVariables = {
      IPFS_PATH = cfg.dataDir;
    };

    systemd.user.services.ipfs = {
      Unit = {
        Description = "InterPlanetary File System (IPFS) daemon";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };
      Service = {
        Restart = "on-failure";

        Environment = [
          "IPFS_PATH=${cfg.dataDir}"
        ];

        ExecStartPre = "${getExe preStartScript}";
        ExecStart = "${getExe cfg.package} daemon ${concatStringsSep " " cfg.extraFlags}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
