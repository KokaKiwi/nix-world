{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "rustowl";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    tag = "v${version}";
    hash = "sha256-va+og3rgmm1bbWPk3GQofQ8S6QKIGr39At8QyKTOA/A=";
  };

  cargoRoot = "rustowl";
  buildAndTestSubdir = cargoRoot;

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ovj3/CO2tkdVWELu2cPpb85+obO1CMv0A3AYL6PbvRw=";

  meta = {
    description = "Visualize Ownership and Lifetimes in Rust";
    homepage = "https://github.com/cordx56/rustowl";
    license = lib.licenses.mpl20;
    mainProgram = "rustowl";
    platforms = lib.platforms.all;
  };
}
