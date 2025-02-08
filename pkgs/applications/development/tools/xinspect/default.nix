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

  useFetchCargoVendor = true;
  cargoHash = "sha256-kbq3RdXTqY8HoMof8G3Hu8qWv0o6tQ5ib94tTQDgxg8=";

  meta = {
    homepage = "https://gitlab.kokakiwi.net/rusted/tools/cargo-shell";
    mainProgram = "xinspect";
  };
}
