{ config, pkgs, lib, ... }:
let
  cfg = config.services.searchix;

  defaults = builtins.fromTOML (builtins.readFile cfg.package.defaultConfig);

  settingsFormat = pkgs.formats.toml { };

  defaultServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    ReadWritePaths = [ cfg.homeDir cfg.settings.dataPath ];
    StateDirectory = lib.mkIf (cfg.homeDir == "/var/lib/searchix") [ "searchix" ];
    Restart = "on-failure";

    CacheDirectory = "searchix";
    CapabilityBoundingSet = "";
    DeviceAllow = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectSystem = "strict";
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [ "@system-service" "~@privileged @setuid @keyring" ];
    UMask = "0066";
  };
in {
  options.services.searchix = with lib; {
    enable = mkEnableOption "searchix";
    package = mkPackageOption pkgs "searchix" { };

    user = mkOption {
      type = types.str;
      default = "searchix";
      description = "User account under which searchix runs.";
    };

    group = mkOption {
      type = types.str;
      default = "searchix";
      description = "Group under which searchix runs.";
    };

    homeDir = mkOption {
      type = types.path;
      default = "/var/lib/searchix";
      description = "Home directory for searchix user";
    };

    settings = mkOption {
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          dataPath = mkOption {
            type = types.str;
            description = "Where to store search index and other data.";
            default = "${cfg.homeDir}/data";
          };

          logLevel = mkOption {
            type = with types; enum [ "error" "warn" "info" "debug" ];
            description = "Only log messages with the given severity or above.";
            default = "info";
          };

          web = mkOption {
            default = { };
            type = types.submodule {
              freeformType = settingsFormat.type;
              options = {
                port = mkOption {
                  type = types.port;
                  description = "Port for searchix to listen on";
                  default = 51313;
                };

                listenAddress = mkOption {
                  type = types.str;
                  description = "Listen on a specific IP address.";
                  default = "localhost";
                };

                baseURL =
                  let
                    inherit (config.services.searchix.settings) web;
                  in
                  mkOption {
                    type = types.str;
                    description = "The base URL that searchix will be served on.";
                    default = "http://${web.listenAddress}:${toString web.port}";
                  };

                environment = mkOption {
                  type = types.str;
                  description = "Environment name for logging";
                  default = "production";
                };

                sentryDSN = mkOption {
                  type = types.str;
                  description = "Optionally enable sentry to track errors.";
                  default = "";
                };

                contentSecurityPolicy = mkOption {
                  type = types.submodule {
                    freeformType = settingsFormat.type;
                  };
                  description = "Control resources a browser should be allowed to load.";
                  default = defaults.Web.ContentSecurityPolicy;
                };

                headers = mkOption {
                  type = with types; attrsOf str;
                  description = "HTTP Headers to send with every request. Case-insensitive.";
                  default = defaults.Web.Headers;
                };
              };
            };
          };

          importer = mkOption {
            default = { };
            type = types.submodule {
              freeformType = settingsFormat.type;

              options = {
                timeout = mkOption {
                  type = types.str;
                  default = "30m";
                  description = ''
                    Maximum time to wait for all import jobs.
                    May need to be increased based on the number of sources.
                  '';
                };

                updateAt = mkOption {
                  type = types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}";
                  default = defaults.Importer.UpdateAt;
                  example = "02:00:00";
                  description = "Time of day to fetch and import new options.";
                };

                sources = mkOption {
                  type = types.attrs;
                  default = defaults.Importer.Sources;
                  description = "Declarative specification of options sources for searchix.";
                };
              };
            };
          };
        };
      };
      description = ''
        Configuration for searchix.

        See https://git.alanpearce.eu/searchix/tree/defaults.toml
      '';
    };
  };

  config = with lib; mkIf cfg.enable {
    systemd.services.searchix = {
      description = "Searchix Nix option search";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ nix ];
      serviceConfig = defaultServiceConfig // {
        ExecStart = "${cfg.package}/bin/searchix-web --config ${(settingsFormat.generate "searchix-config.toml" cfg.settings)}";
      } // lib.optionalAttrs (cfg.settings.web.port < 1024) {
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };

    users.users = optionalAttrs (cfg.user == "searchix") {
      searchix = {
        inherit (cfg) group;
        home = cfg.homeDir;
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.group == "searchix") {
      searchix = { };
    };
  };
}
