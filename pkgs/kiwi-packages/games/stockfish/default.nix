{ lib, stdenv

, fetchurl
, fetchFromGitHub

, targetArch ? null
}:
let
  # The x86-64-modern may need to be refined further in the future
  # but stdenv.hostPlatform CPU flags do not currently work on Darwin
  # https://discourse.nixos.org/t/darwin-system-and-stdenv-hostplatform-features/9745
  archDarwin = if stdenv.isx86_64 then "x86-64-modern" else "apple-silicon";
  defaultArch = if stdenv.isDarwin then archDarwin else
         if stdenv.isx86_64 then "x86-64" else
         if stdenv.isi686 then "x86-32" else
         if stdenv.isAarch64 then "armv8" else
         "unknown";
  arch = if targetArch != null then targetArch else defaultArch;
  comp = if stdenv.cc.isClang then "clang" else "gcc";

  nnueFiles = let
    fetchNnueFile = name: hash: fetchurl {
      inherit name hash;
      url = "https://tests.stockfishchess.org/api/nn/${name}";
    };
  in lib.mapAttrsToList fetchNnueFile {
    # https://github.com/official-stockfish/Stockfish/blob/sf_17/src/evaluate.h
    "nn-1111cefa1111.nnue" = "sha256-ERHO+hERa3cWG9SxTatMUPJuWSDHVvSGFZK+Pc1t4XQ=";
    "nn-37f18f62d772.nnue" = "sha256-N/GPYtdy8xB+HWqso4mMEww8hvKrY+ZVX7vKIGNaiZ0=";
  };
in stdenv.mkDerivation rec {
  pname = "stockfish";
  version = "17";

  src = fetchFromGitHub {
    owner = "official-stockfish";
    repo = "Stockfish";
    rev = "sf_${version}";
    sha256 = "sha256-oXvLaC5TEUPlHjhm7tOxpNPY88QxYHFw+Cev3Q8NEeQ=";
  };

  postUnpack = ''
    sourceRoot+=/src
    ${lib.concatMapStrings (nnueFile: ''
      cp ${nnueFile} $sourceRoot/${nnueFile.name}
    '') nnueFiles}
  '';

  makeFlags = [ "PREFIX=$(out)" "ARCH=${arch}" "COMP=${comp}" "CXX=${stdenv.cc.targetPrefix}c++" ];
  buildFlags = [ "build" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    mainProgram = "stockfish";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
      '';
    maintainers = with maintainers; [ luispedro siraben ];
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    license = licenses.gpl3Only;
  };

}
