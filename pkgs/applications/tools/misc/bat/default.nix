{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, installShellFiles
, makeWrapper

, libgit2
, zlib

, less
}:
rustPlatform.buildRustPackage rec {
  pname = "bat";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "bat";
    tag = "v${version}";
    hash = "sha256-82IhLhw0TdaMh21phBxcUZ5JI5xOXb0DrwnBmPwyfAQ=";
  };
  cargoHash = "sha256-07D3N1xJnrTueI+7SpQPUnCzKOLJTldyyIG2mNfJzME=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  # Skip test cases which depends on `more`
  checkFlags = let
    skipTests = [
      "alias_pager_disable_long_overrides_short"
      "config_read_arguments_from_file"
      "env_var_bat_paging"
      "pager_arg_override_env_noconfig"
      "pager_arg_override_env_withconfig"
      "pager_basic"
      "pager_basic_arg"
      "pager_env_bat_pager_override_config"
      "pager_env_pager_nooverride_config"
      "pager_more"
      "pager_most"
      "pager_overwrite"
    # Fails if the filesystem performs UTF-8 validation (such as ZFS with utf8only=on)
      "file_with_invalid_utf8_filename"
    ];
  in map (testName: "--skip=${testName}") skipTests;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/bat-test.XXXX)
    echo -ne 'Foobar\n\n\n42' > $testFile
    $out/bin/bat -p $testFile | grep "Foobar"
    $out/bin/bat -p $testFile -r 4:4 | grep 42
    rm $testFile

    runHook postInstallCheck
  '';

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{bash,fish,zsh}
  '';

  meta = with lib; {
    description = "Cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "bat";
    maintainers = with maintainers; [
      dywedir
      zowoq
      SuperSandro2000
      sigmasquadron
    ];
  };
}
