{ config, lib, ... }:
with lib;
let
  hosts = config.programs.ssh.matchBlocks;

  ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes128-gcm@openssh.com"
    "aes256-gcm@openssh.com"
    "aes256-ctr"
    "aes192-ctr"
    "aes128-ctr"
  ];

  machines = {
    kiwi-games = {
      hostname = "192.168.1.225";
    };
  };
in {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      aur = {
        host = "aur aur.archlinux.org";
        hostname = "aur.archlinux.org";
        user = "aur";
        identityFile = "~/.ssh/id_aur";
      };

      "kiwivault*" = {
        user = "nixos";
      };
      kiwivault = hm.dag.entryAfter [ "kiwivault*" ] {
        hostname = "192.168.1.80";
      };
      "kiwivault.ygg" = hm.dag.entryAfter [ "kiwivault*" ] {
        hostname = "200:872c:820e:7bb6:1b98:e6e6:913:a512";
      };

      alyx = {
        hostname = "alyx.kokakiwi.net";
        user = "kokakiwi";
      };
      isaac = {
        hostname = "isaac.kokakiwi.net";
        user = "nixos";
      };
      mel = {
        hostname = "mel.kokakiwi.net";
        user = "nixos";
      };

      archrepo = {
        inherit (hosts.alyx.data) hostname;
        user = "archrepo";
        identityFile = "~/.ssh/id_ed25519";
      };

      galileo = {
        hostname = "192.168.1.1";
        user = "pi";
        identityFile = "~/.ssh/id_router";
      };

      nix-games = {
        inherit (machines.kiwi-games) hostname;
        user = "nixos";
        identityFile = "~/.ssh/id_ed25519";
      };

      arch-games = {
        inherit (machines.kiwi-games) hostname;
        user = "arch";
      };
    };

    authorizedKeys = [ ];

    extraConfig = ''
      VerifyHostKeyDNS yes
      Ciphers ${concatStringsSep "," ciphers}
    '';
  };

  home.sessionVariables = {
    SSH_ASKPASS = "/usr/bin/ksshaskpass";
    SSH_ASKPASS_REQUIRE = "force";
    GIT_ASKPASS = "/usr/bin/ksshaskpass";
  };
}
