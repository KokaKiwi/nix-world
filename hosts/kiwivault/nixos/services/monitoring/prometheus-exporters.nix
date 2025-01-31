{ config, ... }:
let
  yggdrasil = config.lib.yggdrasil;
in {
  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = "[${yggdrasil.address}]";
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
    };
    smartctl = {
      enable = true;
      listenAddress = "[${yggdrasil.address}]";
      port = 9633;
    };
  };
}
