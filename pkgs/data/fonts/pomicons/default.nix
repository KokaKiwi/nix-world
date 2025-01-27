{ lib, stdenvNoCC

, fetchFromGitHub
}: let
  rev = "d04478259e7be6ca44234661a2752975f977a4fe";
in stdenvNoCC.mkDerivation {
  pname = "pomicons";
  version = lib.gitVersion "1.0" rev;

  src = fetchFromGitHub {
    owner = "gabrielelana";
    repo = "pomicons";
    inherit rev;
    hash = "sha256-yn5v4IwYPNP3jpzMW9ZsPuOEzkcK3qbi+6MBN11RkqE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0644 -t $out/share/fonts/TTF fonts/*.ttf

    runHook postInstall
  '';
}
