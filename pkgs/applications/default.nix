{ pkgs, sources }:
let
  inherit (pkgs) kiwiPackages;
  inherit (pkgs) libsForQt5 kdePackages python3Packages rustTools;
  callPackage = kiwiPackages.callPackageIfNewer;

  nixd = callPackage ./development/tools/language-servers/nixd {
    _override = true;

    llvmPackages = pkgs.llvmPackages_19;

    _overrideArgs = {
      nix = pkgs.nixVersions.stable_upstream;
    };
  };
in {
  act = callPackage ./development/tools/act { };
  activate-linux = callPackage ./misc/activate-linux {
    _override = true;
  };
  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };
  amber-lang = callPackage ./development/compilers/amber-lang { };
  ast-grep = callPackage ./development/tools/ast-grep { };
  attic-client = callPackage ./tools/networking/attic-client {
    nix = pkgs.nixVersions.nix_2_24;
  };
  b3sum = callPackage ./tools/b3sum { };
  bat = callPackage ./tools/misc/bat { };
  binaryen = callPackage ./development/compilers/binaryen { };
  bitwarden-cli = callPackage ./misc/bitwarden-cli { };
  cargo-about = callPackage ./development/tools/rust/cargo-about { };
  cargo-audit = callPackage ./development/tools/rust/cargo-audit { };
  cargo-c-next = callPackage ./development/tools/rust/cargo-c { };
  cargo-component = callPackage ./development/tools/rust/cargo-component { };
  cargo-deny = callPackage ./development/tools/rust/cargo-deny { };
  cargo-depgraph = callPackage ./development/tools/rust/cargo-depgraph { };
  cargo-expand = callPackage ./development/tools/rust/cargo-expand { };
  cargo-generate = callPackage ./development/tools/rust/cargo-generate { };
  cargo-leptos = callPackage ./development/tools/rust/cargo-leptos { };
  cargo-make = callPackage ./development/tools/rust/cargo-make { };
  cargo-msrv = callPackage ./development/tools/rust/cargo-msrv { };
  cargo-ndk = callPackage ./development/tools/rust/cargo-ndk { };
  cargo-nextest = callPackage ./development/tools/rust/cargo-nextest { };
  cargo-pgo = callPackage ./by-name/ca/cargo-pgo/package.nix { };
  cargo-outdated = callPackage ./development/tools/rust/cargo-outdated { };
  cargo-release = callPackage ./development/tools/rust/cargo-release { };
  cargo-semver-checks = callPackage ./development/tools/rust/cargo-semver-checks { };
  cargo-shell = callPackage ./development/tools/rust/cargo-shell { };
  cargo-show-asm = callPackage ./development/tools/rust/cargo-show-asm { };
  cargo-tarpaulin = callPackage ./development/tools/analysis/cargo-tarpaulin { };
  cargo-udeps = callPackage ./development/tools/rust/cargo-udeps { };
  catppuccin-cursors = callPackage ./misc/catppuccin-cursors { };
  colmena = callPackage ./networking/cluster/colmena { };
  commitizen = callPackage ./development/tools/commitizen { };
  consul = callPackage ./tools/admin/consul { };
  delta = callPackage ./version-management/delta { };
  deno = callPackage ./development/deno { };
  docker-credential-helpers = callPackage ./misc/docker-credential-helpers { };
  doggo = callPackage ./networking/doggo { };
  dorion = callPackage ./networking/instant-messengers/dorion {
    _override = true;
  };
  du-dust = pkgs.dust;
  dust = callPackage ./misc/dust { };
  espanso = callPackage ./office/espanso { };
  espanso-wayland = pkgs.espanso.override {
    x11Support = false;
    waylandSupport = true;
  };
  eza = callPackage ./misc/eza { };
  fastfetch = callPackage ./misc/fastfetch {
    stdenv = pkgs.llvmStdenv;
  };
  fastly = callPackage ./misc/fastly { };
  fd = callPackage ./misc/fd { };
  fixx = callPackage "${sources.ixx}/fixx/derivation.nix" { };
  gh = callPackage ./version-management/gh { };
  git-absorb = callPackage ./version-management/git-absorb { };
  git-cliff = callPackage ./version-management/git-cliff {
    _override = true;
    inherit (rustTools.rust) rustPlatform;
  };
  git-interactive-rebase-tool = callPackage ./version-management/git-interactive-rebase-tool { };
  git-lfs = callPackage ./version-management/git-lfs { };
  gitnr = callPackage ./version-management/gitnr { };
  gitui = callPackage ./misc/gitui { };
  glab = callPackage ./misc/glab {
    buildGoModule = pkgs.buildGo123Module;
  };
  gleam = callPackage ./compilers/gleam { };
  glow = callPackage ./editors/glow { };
  hd = callPackage ./development/tools/hd { };
  hexyl = callPackage ./tools/misc/hexyl { };
  hyfetch = callPackage ./tools/misc/hyfetch { };
  ixx = callPackage "${sources.ixx}/ixx/derivation.nix" { };
  jellyfin-media-player = libsForQt5.callPackage ./misc/jellyfin-media-player { };
  just = callPackage ./tools/just { };
  kitty = callPackage ./terminal-emulators/kitty {
    go = pkgs.go_1_23;
    buildGoModule = pkgs.buildGo123Module;
  };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  kubo = callPackage ./networking/kubo { };
  lan-mouse = callPackage ./misc/lan-mouse { };
  litecli = callPackage ./development/tools/database/litecli { };
  mise = callPackage ./development/tools/mise { };
  minio-client = callPackage ./tools/networking/minio-client { };
  miniserve = callPackage ./tools/misc/miniserve {
    inherit (rustTools.rust_1_81) rustPlatform;
  };
  minisign = callPackage ./tools/security/minisign { };
  module-server = callPackage ./misc/module-server {
    inherit (rustTools.stable) cargo;
  };
  mux = callPackage ./misc/mux { };
  ncmpcpp = callPackage ./audio/ncmpcpp { };
  nextcloud-client = callPackage ./networking/nextcloud-client { };
  nitrokey-app2 = kdePackages.callPackage ./tools/security/nitrokey-app2 { };
  nix-update = callPackage ./tools/package-management/nix-update { };
  inherit (nixd) nixf nixt nixd;
  nomad_1_8 = callPackage ./networking/cluster/nomad/1_8.nix { };
  nomad_1_9 = callPackage ./networking/cluster/nomad/1_9.nix { };
  npins = callPackage ./development/tools/npins { };
  nushell = callPackage ./shells/nushell { };
  obsidian = callPackage ./misc/obsidian { };
  oha = callPackage ./tools/networking/oha { };
  onefetch = callPackage ./misc/onefetch { };
  opentofu = callPackage ./networking/cluster/opentofu { };
  oxipng = callPackage ./tools/oxipng { };
  patool = callPackage ./misc/patool { };
  pdm = callPackage ./development/tools/pdm { };
  pgcli = python3Packages.callPackage ./development/tools/pgcli { };
  ponysay = callPackage ./misc/ponysay { };
  pre-commit = callPackage ./tools/misc/pre-commit { };
  procs = callPackage ./tools/admin/procs { };
  ptpython = python3Packages.callPackage ./development/tools/ptpython { };
  pynitrokey = callPackage ./tools/security/pynitrokey { };
  pueue = callPackage ./misc/pueue { };
  rage = callPackage ./tools/crypto/rage { };
  sea-orm-cli = callPackage ./development/tools/sea-orm-cli { };
  sequoia-sq = callPackage ./tools/security/sequoia-sq { };
  silicon = callPackage ./misc/silicon { };
  skopeo = callPackage ./tools/misc/skopeo { };
  sq = callPackage ./development/tools/sq { };
  sqlx-cli = callPackage ./development/tools/rust/sqlx-cli { };
  starship = callPackage ./tools/misc/starship { };
  syncthing = callPackage ./networking/syncthing { };
  syncthingtray = kdePackages.callPackage ./misc/syncthingtray { };
  szurubooru-cli = callPackage ./misc/booru-cli { };
  taplo = callPackage ./development/tools/taplo { };
  tmux = callPackage ./tools/misc/tmux { };
  trunk = callPackage ./development/tools/trunk { };
  usage = callPackage ./tools/usage { };
  uv = callPackage ./development/tools/uv {
    inherit (rustTools.stable) rustPlatform rustc cargo;
  };
  vesktop = callPackage ./misc/vesktop { };
  viceroy = callPackage ./development/tools/viceroy { };
  wasm-bindgen-cli = callPackage ./development/tools/wasm-bindgen-cli { };
  wasm-tools = callPackage ./tools/misc/wasm-tools { };
  wit-bindgen = callPackage ./development/tools/rust/wit-bindgen { };
  worker-build = callPackage ./development/tools/worker-build { };
  xh = callPackage ./tools/networking/xh { };
  xinspect = callPackage ./development/tools/xinspect { };
  yt-dlp = callPackage ./misc/yt-dlp { };
  ziggy = callPackage ./development/tools/ziggy { };
  zoxide = callPackage ./tools/misc/zoxide { };
}
