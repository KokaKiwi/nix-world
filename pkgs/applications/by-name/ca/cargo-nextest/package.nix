{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.88";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-LaM7IgQq+s1F9fRTGdns1wlGgWUjRQ86xt6mXpmO7a8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-btpsmRozKEfvr0D9X6i+HYXE/OB/e/ZPfuDELQ0IjJo=";

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}
