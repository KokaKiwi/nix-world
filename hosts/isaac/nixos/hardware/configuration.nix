{ modulesPath, ... }:
{

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.kernelModules = [ "nvme" ];

  boot.loader.grub.device = "/dev/sda";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fa3930a9-3434-49eb-abf3-1093e97f0356";
    fsType = "ext4";
  };
}
