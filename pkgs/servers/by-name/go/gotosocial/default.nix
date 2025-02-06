{ lib

, fetchFromGitHub
, fetchurl

, buildGoModule
}:
let
  owner = "superseriousbusiness";
  repo = "gotosocial";

  version = "0.17.3";

  web-assets = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-85CmcWjcX8a+hZxkyRTfXErmkIx64R2scaaS2Fpf668";
  };
in buildGoModule rec {
  inherit version;
  pname = repo;

  src = fetchFromGitHub {
    inherit owner repo;
    tag = "v${version}";
    hash = "sha256-ql0tDaMc/1NgsLUpPHZB6GoXJj9DwUpadTX3AYufR/o=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  tags = [
    "kvformat"
  ];

  postInstall = ''
    tar xf ${web-assets}
    mkdir -p $out/share/gotosocial
    mv web $out/share/gotosocial/
  '';

  doCheck = false;
  checkFlags = let
    # flaky / broken tests
    skippedTests = [ ];
  in [
    "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$"
  ];

  meta = with lib; {
    homepage = "https://gotosocial.org";
    changelog = "https://github.com/superseriousbusiness/gotosocial/releases/tag/v${version}";
    description = "Fast, fun, ActivityPub server, powered by Go";
    longDescription = ''
      ActivityPub social network server, written in Golang.
      You can keep in touch with your friends, post, read, and
      share images and articles. All without being tracked or
      advertised to! A light-weight alternative to Mastodon
      and Pleroma, with support for clients!
    '';
    maintainers = with maintainers; [ blakesmith ];
    license = licenses.agpl3Only;
  };
}
