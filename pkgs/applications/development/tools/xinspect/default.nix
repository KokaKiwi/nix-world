{ lib

, fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "xinspect";
  version = "unstable-2024-05-21";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/sys";
    repo = "xinspect";
    rev = "a2375aa9ca7a990db99205d0527942e743d3bc7a";
    hash = "sha256-qfU9XrOvEC9dEvl3Vprk13w8Zn3LtWi35u1T9jZkU9U=";
  };

  cargoHash = "sha256-05CD4k+rCkx9Utw7VZUFWJt2VAPljDXZr25jN5pcSv8=";

  meta = {
    homepage = "https://gitlab.kokakiwi.net/rusted/tools/cargo-shell";
    mainProgram = "xinspect";
  };
}
