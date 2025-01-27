{ lib, stdenvNoCC

, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "font-awesome";
  version = "6.5.2";

  src = fetchFromGitHub {
    owner = "FortAwesome";
    repo = "Font-Awesome";
    rev = version;
    hash = "sha256-kUa/L/Krxb5v8SmtACCSC6CI3qTTOTr4Ss/FMRBlKuw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0644 -t $out/share/fonts/OTF otfs/*.otf
    install -Dm0644 -t $out/share/fonts/TTF webfonts/*.ttf

    runHook postInstall
  '';
}
