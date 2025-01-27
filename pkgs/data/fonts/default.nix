{ callPackage }:
{
  codicon = callPackage ./codicon {};
  devicon = callPackage ./devicon {};
  octicons = callPackage ./octicons {};
  pomicons = callPackage ./pomicons {};

  font-awesome = callPackage ./font-awesome {};
}
