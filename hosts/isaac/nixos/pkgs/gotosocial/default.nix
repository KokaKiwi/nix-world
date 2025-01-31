{ lib

, fetchFromGitLab
, fetchurl

, buildGoModule
}:
let
  owner = "superseriousbusiness";
  repo = "gotosocial";

  version = "0.17.3";

  web-assets = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}_${version}_web-assets.tar.gz";
    hash = "sha256-85CmcWjcX8a+hZxkyRTfXErmkIx64R2scaaS2Fpf668=";
  };
in buildGoModule rec {
  pname = repo;
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "botsare.gay";
    repo = "gotosocial";
    rev = "refs/tags/v${version}-botsaregay";
    hash = "sha256-xqr8yVu7zNaErajaefACoz7C9K1g6PS6DYCSkORLDAY=";
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

  # tests are working only on x86_64-linux
  # doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;
  # checks are currently very unstable in our setup, so we should test manually for now
  doCheck = false;

  checkFlags =
    let
      # flaky / broken tests
      skippedTests = [
        # See: https://github.com/superseriousbusiness/gotosocial/issues/2651
        "TestPage/minID,_maxID_and_limit_set"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

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
    license = licenses.agpl3Only;
  };
}
