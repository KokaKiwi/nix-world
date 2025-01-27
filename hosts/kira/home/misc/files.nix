{ lib, ... }:
with lib;
{
  lib.files = rec {
    localFilePath = name: path.append ../files name;
    readLocalFile = name: builtins.readFile (localFilePath name);

    localConfigPath = name: localFilePath "config/${name}";
    readLocalConfig = name: readLocalFile "config/${name}";
  };
}
