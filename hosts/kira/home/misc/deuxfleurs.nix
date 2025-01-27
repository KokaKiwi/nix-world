{ config, lib, ... }:
with lib;
let
  files = config.lib.files;

  machines = {
    default = {
      user = "kokakiwi";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      addressFamily = "inet6";
    };
    staging = {
      names = [
        "caribou" "origan" "piranha" "df-pw5"
      ];
      hostname = "%h.machine.staging.deuxfleurs.org";
    };
    prod = {
      names = [
        "concombre" "courgette" "celeri" "dahlia" "diplotaxis"
        "doradille" "df-ykl" "df-ymf" "df-ymk" "abricot"
        "ananas" "onion" "oseille" "io" "ortie"
      ];
      hostname = "%h.machine.deuxfleurs.fr";
    };
  };

  machines-local = {
    onion = "192.168.1.34";
    oseille = "192.168.1.35";
    io = "192.168.1.36";
    ortie = "192.168.1.37";
  };
in {
  data.deuxfleurs = {
    members = [
      "lx" "adrien" "quentin" "baptiste" "maximilien"
      "armael" "boris" "aeddis" "vincent" "trinity-1686a"
      "darkgallium" "marion" "mjal"
    ];
  };

  programs.gpg.publicKeys = map (name: {
    source = files.localFilePath "gpg-keyring/deuxfleurs/${name}.gpg";
    trust = "full";
  }) config.data.deuxfleurs.members;

  programs.ssh.matchBlocks = {
    deuxfleurs-git = {
      host = "git.deuxfleurs.fr";
      user = "git";
      identityFile = "~/.ssh/id_deuxfleurs";
    };
  }
  // mapAttrs' (name: { names, ... }@args: {
    name = "deuxfleurs-${name}";
    value = machines.default // builtins.removeAttrs args [ "names" ] // {
      host = concatStringsSep " " names;
      localForwards = [
        {
          bind.port = 14646;
          host.address = "127.0.0.1";
          host.port = 4646;
        }
        {
          bind.port = 8501;
          host.address = "127.0.0.1";
          host.port = 8501;
        }
      ];
    };
  }) (builtins.removeAttrs machines [ "default" ])
  // mapAttrs' (name: address: {
    name = "deuxfleurs-${name}-local";
    value = {
      host = "${name}-local";
      user = "kokakiwi";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
      hostname = address;
    };
  }) machines-local;
}
