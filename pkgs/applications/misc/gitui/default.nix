{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, cmake

, openssl
, xclip
}:
rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = "gitui";
    rev = "v${version}";
    hash = "sha256-jKJ1XnF6S7clyFGN2o3bHnYpC4ckl/lNXscmf6GRLbI=";
  };

  cargoHash = "sha256-T00TqxR2EWnDkZo3MUQhiG0oAUf1PgpkUMZLt7f4FH0=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ openssl xclip ];

  postPatch = ''
    # The cargo config overrides linkers for some targets, breaking the build
    # on e.g. `aarch64-linux`. These overrides are not required in the Nix
    # environment: delete them.
    rm .cargo/config.toml

    # build script tries to get version information from git
    rm build.rs
    substituteInPlace Cargo.toml --replace-fail 'build = "build.rs"' ""
  '';

  GITUI_BUILD_NAME = version;
  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # Getting app_config_path fails with a permission denied
  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];

  meta = {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    changelog = "https://github.com/extrawurst/gitui/blob/v${version}/CHANGELOG.md";
    mainProgram = "gitui";
    license = lib.licenses.mit;
  };
}
