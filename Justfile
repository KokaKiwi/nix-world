set dotenv-load

host := trim(read("/etc/hostname"))

alias world := build-world

alias upp := update-package
alias upk := update-kiwi-package

_default:

_run-shell NAME COMMAND *ARGS:
  nix-shell {{ARGS}} -A {{NAME}} --run '{{COMMAND}}'

run NAME COMMAND *ARGS: (_run-shell NAME COMMAND ARGS)
check: (_run-shell 'check' 'checkUpdates')
upload-cache: (_run-shell 'upload-cache' 'uploadCache')

build MODULE='':
  nom-build -A {{host}}{{ if MODULE != '' { '.' + MODULE } else { '' } }}
build-world:
  nom-build

activate:
  result/activate
dry-activate:
  DRY_RUN=1 result/activate
switch MODULE='': (build MODULE) activate

build-package ATTR:
  nom-build -A pkgs.{{ATTR}}
build-host-package ATTR:
  nom-build -A hosts.{{host}}.config.{{ATTR}}

copy-package SRC DST:
  mkdir -p $(dirname pkgs/{{DST}})
  cp -Tr ~/.local/state/nix/defexpr/50-home-manager/nixpkgs-unstable/pkgs/{{SRC}} pkgs/{{DST}}
  chmod -R +w pkgs/{{DST}}
copy-application SRC DST: (copy-package (SRC) ('applications/' + DST))

update-package ATTR *ARGS:
  nix-update --commit {{ARGS}} pkgs.{{ATTR}}
update-kiwi-package ATTR *ARGS: (update-package ('kiwiPackages.' + ATTR) ARGS)

update-neovim: (update-kiwi-package 'neovim' '--version=branch=master')
update-vscode:
  nix-update --commit pkgs.kiwiPackages.vscodium --override-filename ./pkgs/kiwi-packages/vscodium/default.nix
update-bun:
  nix-update --commit pkgs.bun \
    --override-filename ./pkgs/overrides.nix \
    --version=(curl 'https://api.github.com/repos/oven-sh/bun/releases/latest' | jq '.tag_name | ltrimstr("bun-v")')

update:
  npins update
  -git add npins/sources.json && git commit -m 'chore: Update pinned sources'

repl:
  nix repl -f default.nix

push:
  git push -f origin main
rebase:
  git rebase -i origin/main

import? 'Justfile.local'
