let
  sources = import ./npins;

  pkgs = import sources.nixpkgs { };
  inherit (pkgs) lib callPackage;

  patches = lib.mapAttrs (name: type:
    lib.mapAttrsToList (name: type: name) (builtins.readDir ./npins/patches/${name})
  ) (builtins.readDir ./npins/patches);

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
