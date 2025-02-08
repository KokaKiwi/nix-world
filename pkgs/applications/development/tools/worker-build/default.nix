{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    tag = "v${version}";
    hash = "sha256-z6m14IbMzgycwnQpA28e4taokDSVpfZOKIRmFIwLjbg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rtnFGGXu5WuYYJgeBeQvU2N91ZMuWq7gwAxsyWFtOvY=";

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ happysalada ];
  };
}
