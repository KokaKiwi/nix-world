{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchCrate,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.48";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-y8qGadmp+6exKAJvNIyBQLZnIe0DYRkiWMyIAMXMr0s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6AE/Ym6Uc2kXafWW3Z/qr8O3tLcbO1wkoYdGjDw5/Do=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = let
    emulator = stdenv.hostPlatform.emulator buildPackages;
  in lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
    installShellCompletion --cmd cargo-asm \
      --bash <(${emulator} $out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <(${emulator} $out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <(${emulator} $out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  meta = with lib; {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    changelog = "https://github.com/pacak/cargo-show-asm/blob/${version}/Changelog.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      oxalica
      matthiasbeyer
    ];
    mainProgram = "cargo-asm";
  };
}
