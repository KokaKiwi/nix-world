{ pkgs, lib, ... }:
let
  llvmPackages = pkgs.llvmPackages_latest;

  # Some LLVM bintools aliases
  llvmBintools = let
    executables = [
      "nm" "objcopy" "objdump" "ranlib" "readelf"
      "size" "strings" "strip" "ar"
    ];
  in pkgs.runCommandLocal "llvm-utils-${llvmPackages.llvm.version}" { } ''
    mkdir -p $out/bin
    ${lib.concatMapStrings (name: ''
      ln -s ${llvmPackages.llvm}/bin/llvm-${name} $out/bin/${name}
    '') executables}
  '';
in {
  home.packages = [
    llvmBintools
  ];
}
