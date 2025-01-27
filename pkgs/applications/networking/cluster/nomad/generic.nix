{ lib

, fetchFromGitHub
, installShellFiles

, buildGoModule
, bashInteractive
, fish

, version
, srcHash
, vendorHash
}:
buildGoModule {
  pname = "nomad";
  inherit version;

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    rev = "v${version}";
    hash = srcHash;
  };

  inherit vendorHash;

  nativeBuildInputs = [
    installShellFiles
    bashInteractive
    fish
  ];

  subPackages = [ "." ];

  preCheck = ''
    export PATH="$PATH:$NIX_BUILD_TOP/go/bin"
  '';

  postInstall = ''
    echo "complete -C $out/bin/nomad nomad" > nomad.bash
    cat > nomad.fish <<EOF
    function __complete_nomad
        set -lx COMP_LINE (commandline -cp)
        test -z (commandline -ct)
        and set COMP_LINE "$COMP_LINE "
        $out/bin/nomad
    end
    complete -f -c nomad -a "(__complete_nomad)"
    EOF
    installShellCompletion nomad.bash nomad.fish
  '';

  meta = with lib; {
    homepage = "https://www.nomadproject.io/";
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    mainProgram = "nomad";
    license = licenses.bsl11;
  };
}
