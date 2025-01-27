let
  sources = import ./npins;

  pkgs = import sources.nixpkgs { };
  inherit (pkgs) lib callPackage;

  patches = {
    agenix = [
      "0001-Fix-rekey.patch"
    ];
    catppuccin = [
      "0001-Expose-lib.ctp.patch"
    ];
    home-manager = [
      "0001-PR-5957-espanso-add-sandboxing-for-systemd-service.patch"
    ];
  };

  lix = callPackage ./pkgs/lix.nix { };

  applyPatches = lib.mapAttrs (name: source: if lib.hasAttr name patches then pkgs.srcOnly {
    inherit name;
    stdenv = pkgs.stdenvNoCC;
    src = source;
    patches = map (filename: ./npins/patches/${name}/${filename}) patches.${name};
    preferLocalBuild = true;
  } else source);
in applyPatches sources // {
  inherit lix;
}
