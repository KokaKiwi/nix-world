{ lib

, fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "doll";
  version = "0-unstable-2024-06-28";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "kokakiwi";
    repo = "doll";
    rev = "b2865424e3bbe18c3b46c529d17b46e527521bfc";
    hash = "sha256-gLCLapuBMUU7Iaqo+jz+Lb0RGkPa2jcENhH5MXMUBxM=";
  };

  cargoHash = "sha256-k8grWNK4jXbWRobCtpqByVzcx6oocPg0Fz3O3FnvlSY=";

  meta = with lib; {
    description = "Doll and drones related tooling";
    homepage = "https://gitlab.kokakiwi.net/kokakiwi/doll";
    license = licenses.bsd3;
    mainProgram = "doll";
  };
}
