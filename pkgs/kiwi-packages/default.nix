{ pkgs, lib, super }:
rec {
  callPackage = lib.callPackageWith (pkgs // {
    inherit (pkgs.kiwiPackages) libgit2;
  });
  callPackageIfNewer = path: args: let
    newArgs = builtins.removeAttrs args [ "_override" "_overrideArgs" ];
    overrideArgs = args._overrideArgs or { };

    drv = let
      base = super.${drv'.pname} or null;
    in if base != null then base.override overrideArgs else null;

    drv' = let
      finalArgs = overrideArgs // newArgs;
    in callPackage path finalArgs;

    override = args._override or false;

    isNewer = drv == null || lib.versionOlder drv.version drv'.version;
    finalDrv = if (isNewer || override) then drv' else drv;
  in finalDrv // {
    local = drv';
    remote = drv;
    isLocal = isNewer || override;
  };
  overrideAttrsIfNewer = drv: fnOrAttrs: let
    drv' = drv.overrideAttrs fnOrAttrs;

    isNewer = lib.versionOlder drv.version drv'.version;
    finalDrv = if isNewer then drv' else drv;
  in finalDrv // {
    local = drv';
    remote = drv;
    isLocal = isNewer;
  };

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;

  inherit (pkgs) go;
  buildGoModule = super.buildGoModule.override {
    inherit go;
  };

  cargo-pgrx = callPackage ./cargo-pgrx { };
  cargo-setup-project = callPackage ./cargo-setup-project { };
  doll = callPackage ./doll { };
  dwarfs = callPackage ./dwarfs {
    stdenv = pkgs.llvmStdenv;
  };
  libgit2 = pkgs.libgit2;
  man-db = callPackage ./man-db { };
  neovim = callPackage ./neovim { };
  stockfish = callPackage ./games/stockfish { };
  vencord = callPackage ./vencord {
    pnpm = pkgs.pnpm_9;
  };
  vscodium = callPackage ./vscodium { };

  llvm = pkgs.llvm_19;
  llvmPackages = pkgs.llvmPackages_19;

  vesktop = let
    vesktop = pkgs.vesktop.overrideAttrs (final: super: {
      patches = super.patches ++ [
        ./vesktop/0001-fix-handle-loadURL-failures-correctly.patch
        ./vesktop/0002-feat-New-Vesktop-icon.patch
      ];
    });
  in vesktop.override {
    electron = pkgs.electron_33;

    withSystemVencord = true;
    inherit vencord;
  };

  gnupg = overrideAttrsIfNewer super.gnupg24 (self: prev: {
    version = "2.4.7";

    src = pkgs.fetchurl {
      url = "mirror://gnupg/gnupg/${self.pname}-${self.version}.tar.bz2";
      hash = "sha256-eyRwbk2n4OOwbKBoIxAnQB8jgQLEHJCWMTSdzDuF60Y=";
    };
  });

  git = pkgs.git.overrideAttrs (self: prev: {
    version = "2.48.1";

    src = pkgs.fetchurl {
      url = "https://www.kernel.org/pub/software/scm/git/git-${self.version}.tar.xz";
      hash = "sha256-HF1UX13B61HpXSxQ2Y/fiLGja6H6MOmuXVOFxgJPgq0=";
    };

    postBuild = ''
      make -C Documentation
      ${prev.postBuild}
    '';

    meta = prev.meta // {
      changelog = "https://github.com/git/git/blob/v${self.version}/Documentation/RelNotes/${self.version}.txt";
    };
  });
}
