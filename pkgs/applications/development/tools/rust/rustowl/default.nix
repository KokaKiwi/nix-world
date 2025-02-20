{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "rustowl";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "cordx56";
    repo = "rustowl";
    tag = "v${version}";
    hash = "sha256-BSBg1ekytSs4D17tc2J36BRW21505uDksKTBm0Jpjms=";
  };

  cargoRoot = "rustowl";
  buildAndTestSubdir = cargoRoot;

  useFetchCargoVendor = true;
  cargoHash = "sha256-+LwXbib0Sv5ILaO6DM+Jk9IFQMqrfAY8IDB8XjXAN2g=";

  meta = {
    description = "Visualize Ownership and Lifetimes in Rust";
    homepage = "https://github.com/cordx56/rustowl";
    license = lib.licenses.mpl20;
    mainProgram = "rustowl";
    platforms = lib.platforms.all;
  };
}
