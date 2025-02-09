{ pkgs, lib, hosts, ... }:
pkgs.nur.repos.kokakiwi.lib.mkUpdateChecker {
  doWarn = true;

  packages = let
    ignoredPackages = [
      # Let's nixpkgs handle these
      "nixfmt" "nix-output-monitor" "nvd"
      "bash" "bash-interactive"
      # Too old
      "hub"
      # My own packages
      "cargo-shell" "mux" "xinspect"
      "doll" "szurubooru-cli"
      # No version
      "agenix"
      # Aliased
      "neovim" "yazi"
      # Unstable packages
      "glances"
      # Haskell stuff
      "ShellCheck"
    ];

    hostPackages = lib.flatten (lib.mapAttrsToList (_: host:
      lib.flatten (lib.mapAttrsToList (_: system:
        system.packages
      ) host.config.systems)
    ) hosts.hosts);
    extraPackages = let
      neovim = pkgs.kiwiPackages.neovim;
    in with pkgs; [
      neovim neovim.tree-sitter neovim.lua
      neovim.wasmtime-c-api neovim.unibilium neovim.libuv

      git-interactive-rebase-tool syncthing
      usage viceroy yazi-unwrapped
      tig hoppscotch
    ];
    allPackages = hostPackages ++ extraPackages;

    namedPackages = lib.filter (drv: drv ? pname) allPackages;
    includedPackages = lib.filter (drv: !lib.elem drv.pname ignoredPackages) namedPackages;
  in lib.listToAttrs (map (drv: lib.nameValuePair drv.pname drv) includedPackages);

  configs = {
    aria2.prefix = "release-";
    binaryen.include_regex = "version_.*";
    bitwarden-cli.include_regex = "cli-v.*";
    bitwarden-cli.prefix = "cli-v";
    bun.include_regex = "bun-v.*";
    bun.prefix = "bun-v";
    cargo-nextest.include_regex = "cargo-nextest-.*";
    cargo-nextest.prefix = "cargo-nextest-";
    dorion.prefix = "v";
    gleam.prefix = "v";
    hoppscotch.prefix = "v";
    imhex.prefix = "v";
    kitty.prefix = "v";
    kubo.prefix = "v";
    minio-client.prefix = "RELEASE.";
    obsidian.prefix = "v";
    patool.prefix = "upstream/";
    stockfish.include_regex = "sf_.*";
    stockfish.prefix = "sf_";
    tig.prefix = "tig-";
    zoxide.prefix = "v";
  };
  sources = {
    glab = {
      source = "gitlab";
      gitlab = "gitlab-org/cli";
      use_max_tag = true;
    };
    cargo-depgraph = {
      source = "github";
      github = "jplatte/cargo-depgraph";
      use_max_tag = true;
    };
    gajim = {
      source = "gitlab";
      host = "dev.gajim.org";
      gitlab = "gajim/gajim";
      use_max_tag = true;
    };
    git-with-svn = {
      source = "archpkg";
      archpkg = "git";
      strip_release = true;
    };
    gnupg = {
      source = "archpkg";
      archpkg = "gnupg";
      strip_release = true;
    };
    kx-aspe-cli = {
      source = "git";
      git = "https://codeberg.org/keyoxide/kx-aspe-cli.git";
      use_commit = true;
    };
    ncmpcpp = {
      source = "archpkg";
      archpkg = "ncmpcpp";
      strip_release = true;
    };
    lix = {
      source = "gitea";
      host = "git.lix.systems";
      gitea = "lix-project/lix";
      use_max_tag = true;
    };
    npins = {
      source = "github";
      github = "andir/npins";
      use_max_tag = true;
    };
    man-db = {
      source = "gitlab";
      gitlab = "man-db/man-db";
      use_max_tag = true;
    };
    sequoia-sq = {
      source = "gitlab";
      gitlab = "sequoia-pgp/sequoia-sq";
      use_max_tag = true;
    };
    tor = {
      source = "gitlab";
      host = "gitlab.torproject.org";
      gitlab = "tpo/core/tor";
      use_max_tag = true;
      prefix = "tor-";
    };
  };
  overrides = {
    aura.exclude_regex = "^$";
    binaryen.prefix = "version_";
    lix.exclude_regex = "^$";
    pgcli.use_latest_tag = true;
  };

  nvcheckerConfig = {
    keyfile = "~/.config/nvchecker/keyfile.toml";
  };
}
