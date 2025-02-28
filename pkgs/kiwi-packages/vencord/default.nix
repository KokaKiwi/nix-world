{
  esbuild,
  fetchFromGitHub,
  git,
  lib,
  nodejs,
  pnpm,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vencord";
  version = "1.11.6-unstable-2025-02-28";

  src = fetchFromGitHub {
    owner = "Vendicated";
    repo = "Vencord";
    rev = "11715da9e02dcd5a0504519c2611e9976d3302f9";
    hash = "sha256-Lo55AUBi33Quumcfa7xwE6QvJsK04UkqBfGdgmf/xqc=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname src;

    hash = "sha256-g9BSVUKpn74D9eIDj/lS1Y6w/+AnhCw++st4s4REn+A=";
  };

  nativeBuildInputs = [
    git
    nodejs
    pnpm.configHook
  ];

  env = {
    ESBUILD_BINARY_PATH = lib.getExe (esbuild.overrideAttrs (final: _: {
      version = "0.25.0";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        tag = "v${final.version}";
        hash = "sha256-L9jm94Epb22hYsU3hoq1lZXb5aFVD4FC4x2qNt0DljA=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    }));
    VENCORD_REMOTE = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
    VENCORD_HASH = "${finalAttrs.version}";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build -- --standalone --disable-updater

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist/ $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Vencord web extension";
    homepage = "https://github.com/Vendicated/Vencord";
    license = licenses.gpl3Only;
  };
})
