# auto-generated file -- DO NOT EDIT!
{ lib, stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = {
      inherit (args) version;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
fetch_librusty_v8 {
  version = "0.106.0";
  shas = {
    x86_64-linux = "sha256-jLYl/CJp2Z+Ut6qZlh6u+CtR8KN+ToNTB+72QnVbIKM=";
    aarch64-linux = "sha256-uAkBMg6JXA+aILd8TzDtuaEdM3Axiw43Ad5tZzxNt5w=";
    x86_64-darwin = "sha256-60aR0YvQT8KyacY8J3fWKZcf9vny51VUB19NVpurS/A=";
    aarch64-darwin = "sha256-pd/I6Mclj2/r/uJTIywnolPKYzeLu1c28d/6D56vkzQ=";
  };
}
