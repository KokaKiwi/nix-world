{ ... }:
{
  systemd.user = {
    systemctlPath = "/usr/bin/systemctl";
    startServices = "suggest";

    settings = {
      Manager.DefaultCPUAccounting = true;
    };
  };
}
