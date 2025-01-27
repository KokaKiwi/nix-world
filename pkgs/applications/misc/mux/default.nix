{ lib

, fetchFromGitLab

, makeWrapper
, rustPlatform

, tmux
}:
rustPlatform.buildRustPackage {
  pname = "mux";
  version = "0.1-unstable-2024-11-23";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "mux";
    rev = "9b98177f18fcbe60763b773e1b83f638363e5d34";
    hash = "sha256-/6Prxys2l3JVXu8ljJKZnkwtnXNwiFF8wXLKEOt1UdI=";
  };

  cargoHash = "sha256-xXyKDuqsdV96cWY25Llz1oZv5G01zAow8ToCZO3OyWw=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mux \
      --prefix PATH ":" ${lib.makeBinPath [ tmux ]}
  '';

  meta = {
    mainProgram = "mux";
  };
}
