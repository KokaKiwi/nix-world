{ lib
, stdenv
, darwin

, fetchFromGitHub

, makeWrapper
, rustPlatform

# Runtime dependencies
, nix
, nix-prefetch-git
, gitMinimal
}: let
  runtimeInputs = [ nix nix-prefetch-git gitMinimal ];
in rustPlatform.buildRustPackage rec {
  pname = "npins";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    rev = version;
    hash = "sha256-mNilBA3T992ZgagTOlCdKlhdTv1oJ+LfF/6FaHIrJRA=";
  };

  cargoHash = "sha256-YwMypBl+P1ygf4zUbkZlq4zPrOzf+lPOz2FLg2/xI3k=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postFixup = ''
    wrapProgram $out/bin/npins \
      --prefix PATH : ${lib.makeBinPath runtimeInputs}
  '';

  # (Almost) all tests require internet
  doCheck = false;

  meta = with lib; {
    description = "Nix dependency pinning. Very similar to Niv but has a few features that I personally wanted";
    homepage = "https://github.com/andir/npins";
    license = licenses.eupl12;
    mainProgram = "npins";
  };
}
