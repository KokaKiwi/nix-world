{ lib, stdenvNoCC

, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "octicons";
  version = "19.9.0";

  src = fetchFromGitHub {
    owner = "primer";
    repo = "octicons";
    rev = "v${version}";
    hash = "sha256-O0lSch8N2YjATy/EBIq2Fi6R6hNQwA+NufWKWlVbwkI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    runHook postInstall
  '';
}
