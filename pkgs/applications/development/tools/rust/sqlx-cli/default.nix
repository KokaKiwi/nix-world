{ lib, stdenv

, fetchFromGitHub

, rustPlatform

, installShellFiles
, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "sqlx-cli";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "launchbadge";
    repo = "sqlx";
    tag = "v${version}";
    hash = "sha256-kAZUconMYUF9gZbLSg7KW3fVb7pkTq/d/yQyVzscxRw=";
  };

  cargoHash = "sha256-HDiWT13tknEC+Z4nVe4ZDFMP3y5VtRXozRLd68T9BuE=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "native-tls"
    "postgres"
    "sqlite"
    "mysql"
    "completions"
  ];

  doCheck = false;
  cargoBuildFlags = [ "--package sqlx-cli" ];

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      openssl
    ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/sqlx completions $shell > sqlx.$shell
      installShellCompletion sqlx.$shell
    done
  '';

  meta = with lib; {
    description = "SQLx's associated command-line utility for managing databases, migrations, and enabling offline mode with sqlx::query!() and friends.";
    homepage = "https://github.com/launchbadge/sqlx";
    license = licenses.asl20;
    maintainers = with maintainers; [
      greizgh
      xrelkd
      fd
    ];
    mainProgram = "sqlx";
  };
}
