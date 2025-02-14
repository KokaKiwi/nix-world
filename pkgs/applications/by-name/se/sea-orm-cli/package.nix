{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-k3XZbSOzneZmLA06Zp9lsBLJzIctQKbcguFhVYC47CI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4iBlz+dgNwSgrGi+57NVVmdG6qzvt/hBh/HwhGNrFU0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;
  __darwinAllowLocalNetworking = true;

  meta = {
    mainProgram = "sea-orm-cli";
    homepage = "https://www.sea-ql.org/SeaORM";
    description = "Command line utility for SeaORM";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ traxys ];
  };
}
