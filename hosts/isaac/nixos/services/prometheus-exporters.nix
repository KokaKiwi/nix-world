{ config, ... }:
{
  networking.firewall.interfaces.${config.services.yggdrasil.settings.IfName}.allowedTCPPorts = [
    9100
  ];
  services.prometheus.exporters = {
    node = {
      enable = true;
      listenAddress = "[${config.lib.yggdrasil.address}]";
      port = 9100;
      enabledCollectors = [
        "logind"
        "systemd"
      ];
      disabledCollectors = [
        "textfile"
      ];
    };
  };
}
