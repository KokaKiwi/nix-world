{ lib

, fetchCrate

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6SFEzbXarfF8FXQqzc8n5S283xKfqqS/sfIBzpGxS04=";
  };

  cargoHash = "sha256-ciskV8HdNnIOV7qApqaGPhUSTzeoK8MYDPo4XU4aFm8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
