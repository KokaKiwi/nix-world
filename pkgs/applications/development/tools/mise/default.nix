{ lib

, fetchFromGitHub

, installShellFiles
, addUsageCompletion
, rustPlatform

, pkg-config

, coreutils
, bash
, direnv
, git
, openssl
}: rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2025.2.7";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${version}";
    hash = "sha256-PvZCKi6fvEc0J5SzDazMkf2SS3+r0DTXM6NWCPi95J0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qVs1PogSDfMCVgfvgqLltqiGl7yvO+d4Ly0oeQpSftw=";

  nativeBuildInputs = [
    addUsageCompletion
    installShellFiles
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/generate/git_pre_commit.rs \
      ./src/cli/generate/snapshots/*.snap

    substituteInPlace ./src/test.rs \
      --replace-fail '/usr/bin/env bash' '${lib.getExe bash}'

    substituteInPlace ./src/git.rs \
      --replace-fail '"git"' '"${lib.getExe git}"'

    substituteInPlace ./src/env_diff.rs \
      --replace-fail '"bash"' '"${lib.getExe bash}"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${lib.getExe' coreutils "env"}"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${lib.getExe direnv}"'
  '';

  doCheck = false; # Broken
  cargoTestFlags = [ "--all-features" ];
  dontUseCargoParallelTests = true;

  checkFlags = let
    skipTests = [
      # last_modified will always be different in nix
      "tera::tests::test_last_modified"
      # requires https://github.com/rbenv/ruby-build
      "plugins::core::ruby::tests::test_list_versions_matching"

      "task::task_file_providers::remote_task_http::tests::test_http_remote_task_get_local_path_with_cache"
      "task::task_file_providers::remote_task_http::tests::test_http_remote_task_get_local_path_without_cache"
    ];
  in map (name: "--skip=${name}") skipTests;

  postInstall = ''
    installManPage ./man/man1/mise.1

    addUsageCompletion "mise" ./completions "$out/bin/mise usage"

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise
  '';

  meta = with lib; {
    homepage = "https://mise.jdx.dev";
    description = "The front-end to your dev env";
    changelog = "https://github.com/jdx/mise/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "mise";
  };
}
