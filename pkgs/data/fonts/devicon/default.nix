{ lib, stdenvNoCC

, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "devicon";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "devicons";
    repo = "devicon";
    rev = "v${version}";
    hash = "sha256-VLr84XWkus6d3Hj1mV9TDQjtewAhadNVjiwd9p/aXfY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0644 -t $out/share/fonts/TTF fonts/*.ttf

    runHook postInstall
  '';
}
