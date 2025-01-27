{ lib, stdenvNoCC

, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "codicon";
  version = "0.0.35";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-codicons";
    rev = version;
    hash = "sha256-d0UuB/fNXTonaLWdCa1ZlZxnwZuI8+spBk8bFwYSuK4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm0644 -t $out/share/fonts/TTF dist/codicon.ttf

    runHook postInstall
  '';
}
