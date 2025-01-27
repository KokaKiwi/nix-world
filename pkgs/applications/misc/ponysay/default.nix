{ lib, stdenv

, fetchFromGitHub

, makeWrapper

, python3
, texinfo
}:
stdenv.mkDerivation rec {
  pname = "ponysay";
  version = "3.0.3-unstable-2023-11-14";

  src = fetchFromGitHub {
    owner = "erkin";
    repo = "ponysay";
    rev = "00b8c84d2fff682bc1a02221d92e798cc60d58ea";
    sha256 = "sha256-wwt5wJYLaPbQ2c7Wqt2Z0Qr8Bk83BdPB5g+bq+ieoRE=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 texinfo ];

  inherit python3;

  installPhase = ''
    find -type f -name "*.py" | xargs sed -i "s@/usr/bin/env python3@$python3/bin/python3@g"
    substituteInPlace setup.py --replace \
        "fileout.write(('#!/usr/bin/env %s\n' % env).encode('utf-8'))" \
        "fileout.write(('#!%s/bin/%s\n' % (os.environ['python3'], env)).encode('utf-8'))"
    python3 setup.py --prefix=$out --freedom=partial install \
        --with-shared-cache=$out/share/ponysay \
        --with-bash
  '';

  meta = with lib; {
    description = "Cowsay reimplemention for ponies";
    homepage = "https://github.com/erkin/ponysay";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bodil ];
    platforms = platforms.unix;
  };
}
