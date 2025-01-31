{ ... }:
{
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    linger = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFgH1s3lNSCcl6q2zmrwe2KWmh5eAqT9AbqSd2cdMTBR kokakiwi@rosenberg"
    ];
  };

  home-manager.users.nixos = ./home.nix;
}
