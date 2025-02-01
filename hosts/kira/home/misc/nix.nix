{ config, pkgs, lib, sources, ... }:
{
  home.packages = [
    config.nix.package
  ];

  nix = {
    package = pkgs.nix.override {
      inherit (pkgs.kiwiPackages.llvmPackages) stdenv;
      inherit (pkgs.kiwiPackages) llvmPackages;

      openssl = pkgs.quictls;
      curl = pkgs.curl.override {
        openssl = pkgs.quictls;

        http3Support = true;
      };
      python3 = pkgs.python313;
    };

    builders = {
      nix-games = {
        # enable = false;
        uri = "ssh-ng://nix-games";
        systems = [ "x86_64-linux" "aarch64-linux" ];
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 3;
        speedFactor = 5;
        supportedSystemFeatures = [
          "big-parallel"
        ];
      };
      nix-alyx = {
        enable = false;
        uri = "ssh-ng://nix-alyx";
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 1;
        speedFactor = 1;
      };
    };

    gc = {
      automatic = true;
      options = toString [
        "--delete-older-than" "15d"
      ];
    };

    channels = let
      names = [ "nixos-24.05" "nixos-24.11" ];
    in {
      nixpkgs = sources.nixpkgs;
      nixpkgs-unstable = sources.nixpkgs;
    }
    // builtins.listToAttrs (map (name: lib.nameValuePair name sources.${name}) names)
    // {
      inherit (sources) fenix;
    };
    keepOldNixPath = false;

    settings = {
      extra-platforms = [ "aarch64-linux" ];
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
  };

  caches = {
    extraCaches = let
      mkCachix = name: key: {
        url = "https://${name}.cachix.org";
        inherit key;
      };
    in [
      {
        url = "https://attic.bismuth.it/kokakiwi";
        key = "kokakiwi:e3jihe8aS1LCVYET8hAm79TM68DZ3RDsbzPLuvZYEKA=";
      }
      {
        url = "https://cache.lix.systems";
        key = "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=";
      }
      (mkCachix "nix-community" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=")
      (mkCachix "cachix" "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=")
      (mkCachix "catppuccin" "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU=")
      (mkCachix "colmena" "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg=")
      (mkCachix "zig2nix" "zig2nix.cachix.org-1:LSXEcFKIAN2NtNsznYLMbhEtyHHorV0caI2UgTIxk2k=")
    ];
  };
}
