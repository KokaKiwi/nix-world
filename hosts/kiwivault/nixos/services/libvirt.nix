{ config, pkgs, ... }:
let
  inherit (config.lib) yggdrasil;
in {
  virtualisation.libvirtd = {
    enable = true;

    onShutdown = "shutdown";

    qemu = {
      package = pkgs.qemu_kvm;

      runAsRoot = true;
      swtpm.enable = true;

      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  webserver.services = {
    home = {
      proxyPass = "http://192.168.1.81:8123";
    };

    home-remote = {
      default = true;
      proxyPass = "http://192.168.1.81:8123";

      extraConfig = {
        forceSSL = false;

        listen = [
          {
            addr = "[${yggdrasil.address}]";
            port = 8123;
          }
        ];
      };
    };
  };
}
