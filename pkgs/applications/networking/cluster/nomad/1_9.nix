{ callPackage

, buildGo123Module
}:
callPackage ./generic.nix {
  version = "1.9.5";
  srcHash = "sha256-NIv3QPSYoYrDQxxtNDHc3DdBLb45oUdA5Jyjke+XzD8=";
  vendorHash = "sha256-y4WBOSfkRYNQRWu5B/j2JBLPAxJ1fyLD0DEAjB10Sl8=";

  buildGoModule = buildGo123Module;
}
