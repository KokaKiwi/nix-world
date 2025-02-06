{ pkgs, lib
, callPackage

, fetchurl
}:
callPackage "${pkgs.path}/pkgs/applications/editors/vscode/generic.nix" rec {
  pname = "vscodium";
  version = "1.97.0.25037";

  src = fetchurl {
    url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-linux-x64-${version}.tar.gz";
    sha256 = "sha256-KmU44ORDUlKIwREdWeN+RBLmiB078vOSM2TCcxA+P5Q=";
  };

  sourceRoot = ".";
  commandLineArgs = "";
  useVSCodeRipgrep = false;

  executableName = "codium";
  longName = "VSCodium";
  shortName = "vscodium";

  updateScript = null;

  meta = with lib; {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS (VS Code without MS branding/telemetry/licensing)
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/VSCodium/vscodium";
    downloadPage = "https://github.com/VSCodium/vscodium/releases";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "codium";
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
  };
}
