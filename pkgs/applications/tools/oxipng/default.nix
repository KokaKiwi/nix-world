{ lib, stdenv

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "oxipng";
  version = "9.1.3";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "refs/tags/v${version}";
    hash = "sha256-8EOEcIw10hCyYi9SwDLDZ8J3ezLXa30RUY5I9ksfqTs=";
  };

  cargoHash = "sha256-4PCLtBJliK3uteL8EVKLBVR2YZW1gwQOiSLQok+rqug=";

  doCheck = !stdenv.hostPlatform.isAarch64 && !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    mainProgram = "oxipng";
  };
}
