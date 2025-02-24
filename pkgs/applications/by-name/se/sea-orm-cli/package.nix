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
  version = "1.1.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Gav72z6IU+rdLi5WDLy/rr7HIAIY9T21g1YPGYn1m/8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-w3A7K6kUvr6Q9Tnb0WjZ6AU+JqPbiMSaAcx01F6G6c8=";

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
