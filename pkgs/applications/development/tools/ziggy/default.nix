{ lib, stdenv
, callPackage

, fetchFromGitHub
, writeShellScript

, zig
, zon2nix
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ziggy";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "ziggy";
    rev = "fe73beef9f52f04048d8b19016fc4fbc66b4596f";
    hash = "sha256-GSiVrl3GMp5Y8DF/gxdl1ToUoN5s3RQxNKxmab5tSHs=";
  };

  deps = callPackage ./deps.nix { };

  postPatch = ''
    ln -s $deps $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    zig.hook
  ];

  passthru = {
    update-deps = writeShellScript "update-deps" ''
      ${lib.getExe zon2nix} ${finalAttrs.src} > ${toString ./deps.nix}
    '';
  };

  meta = with lib; {
    description = "A data serialization language for expressing clear API messages, config files, etc";
    homepage = "https://github.com/kristoff-it/ziggy";
    license = licenses.mit;
    mainProgram = "ziggy";
    inherit (zig.meta) platforms;
  };
})
