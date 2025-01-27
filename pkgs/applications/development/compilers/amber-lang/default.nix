{ lib

, fetchFromGitHub

, rustPlatform
, makeWrapper

, bc
, util-linux
, shfmt
}:
rustPlatform.buildRustPackage rec {
  pname = "amber-lang";
  version = "0.3.5-alpha";

  src = fetchFromGitHub {
    owner = "Ph0enixKM";
    repo = "Amber";
    rev = version;
    hash = "sha256-wf0JNWNliDGNvlbWoatPqDKmVaBzHeCKOvJWuE9PnpQ=";
  };

  cargoHash = "sha256-6T4WcQkCMR8W67w0uhhN8W0FlLsrTUMa3/xRXDtW4Es=";

  preConfigure = ''
    substituteInPlace src/compiler.rs \
      --replace-fail 'Command::new("/usr/bin/env")' 'Command::new("env")'
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    bc
    shfmt
    # 'rev' in generated bash script of test
    # tests::validity::variable_ref_function_invocation
    util-linux
  ];

  checkFlags = [
    "--skip=tests::extra::download"
  ];

  postInstall = ''
    wrapProgram "$out/bin/amber" \
      --prefix PATH : "${lib.makeBinPath [ bc shfmt ]}"
  '';

  meta = with lib; {
    description = "Programming language compiled to bash";
    homepage = "https://amber-lang.com";
    license = licenses.gpl3Plus;
    mainProgram = "amber";
    maintainers = with maintainers; [
      cafkafk
      uncenter
      aleksana
    ];
    platforms = platforms.unix;
  };
}
