{ lib

, fetchFromGitLab

, makeWrapper
, rustPlatform

, tmux
}:
rustPlatform.buildRustPackage {
  pname = "mux";
  version = "0.1-unstable-2025-02-19";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "mux";
    rev = "c57d9aead082bd88c8eaacbb4ab9b68f89a1bc4e";
    hash = "sha256-0FgyiH9Qe4HaU4XwDs/Wu/zJuaOKnKfAZjbQqO9cIxI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Lqa4KFXCtwau8M3BvHLFxqtJNvYjbJ4swCZC8N13XiU=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/mux \
      --prefix PATH ":" ${lib.makeBinPath [ tmux ]}
  '';

  meta = {
    mainProgram = "mux";
  };
}
