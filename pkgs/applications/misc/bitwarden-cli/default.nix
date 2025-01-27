{ lib

, fetchFromGitHub

, buildNpmPackage
, nodejs
, python3
}:
buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2025.1.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-Ayz3v0f7gCJtVXS+uFFJhTYyttnbRjeOKYKh0bi4dGM=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-ZbfI4NU5/9dlNSLZMf6WK+9qyeI3rXYYTqHbD9EitTk=";

  nativeBuildInputs = [
    python3
  ];

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
